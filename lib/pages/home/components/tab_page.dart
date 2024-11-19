import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v2next/components/footer.dart';
import 'package:v2next/components/loading_list_page.dart';
import 'package:v2next/components/no_data.dart';
import 'package:v2next/components/post_item.dart';
import 'package:v2next/components/tab_child_node.dart';
import 'package:v2next/http/api.dart';
import 'package:v2next/http/request.dart';
import 'package:v2next/model/BaseController.dart';
import 'package:v2next/model/model.dart';
import 'package:v2next/utils/event_bus.dart';

class TabPageController extends GetxController {
  bool loading = true;
  bool needAuth = false;
  List<Post> postList = [];
  List<V2Node> nodeList = [];
  final BaseController home = Get.find();
  NodeItem tab;
  int pageNo = 1;
  int totalPage = 1;
  bool isLoadingMore = false;

  TabPageController({required this.tab});

  @override
  void onClose() {
    super.onClose();
    EventBus().off('post_detail', mergePost);
  }

  @override
  void onInit() async {
    super.onInit();
    getData(isRefresh: true);
    EventBus().on('post_detail', mergePost);
  }

  mergePost(post) {
    print('mergePost${post}');
    var rIndex = postList.indexWhere((v) => v.postId == post.postId);
    if (rIndex > -1) {
      postList[rIndex].replyCount = post.replyCount;
      update();
    }
  }

  getPostContent(Post item) {
    Http().get('/api/topics/show.json?id=${item.postId}').then((res) {
      try {
        String t = res.data[0]['content_rendered'];
        String t1 = res.data[0]['content'];
        item.contentRendered = t.trim();
        //内容可能为空，导致重复请求，加个空格保证不为空，避免重复请求
        item.contentText = t1.trim() + ' ';
        update();
      } catch (e) {}
    });
  }

  getData({bool isRefresh = false}) async {
    print('getList:type:${tab.type},id:${tab.name}');
    if (isRefresh) {
      loading = true;
      update();
    }
    Result res = await Api.getPostListByTab(tab: tab, pageNo: pageNo);
    if (res.success) {
      if (isRefresh) postList = [];
      needAuth = false;
      postList.addAll(res.data['list'].cast<Post>());
      nodeList = nodeList.isEmpty ? res.data['nodeList'] : nodeList;
      totalPage = res.data['totalPage'];
    } else {
      needAuth = res.data == Auth.notAllow;
    }
    if (isRefresh) {
      loading = false;
      if (BaseController.to.currentConfig.autoLoadPostContent) {
        var maxI = postList.length > 3 ? 3 : postList.length;
        for (var i = 0; i < maxI; i++) {
          var item = postList[i];
          getPostContent(item);
        }
      }
    }
    update();
  }

  Future onRefresh() async {
    pageNo = 1;
    isLoadingMore = false;
    await getData(isRefresh: true);
  }

  loadMore() async {
    if (isLoadingMore) return;
    if (pageNo >= totalPage) return;
    print('加载更多:${tab.title}');
    pageNo++;
    isLoadingMore = true;
    update();
    await getData();
    isLoadingMore = false;
    update();
  }
}

class TabPage extends StatefulWidget {
  final NodeItem tab;

  const TabPage({super.key, required this.tab});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with AutomaticKeepAliveClientMixin {
  final ScrollController scrollCtrl = ScrollController();
  Map<int, GlobalKey> _itemKeys = {}; // 存储每个子项的 GlobalKey

  Future<void> onRefresh() async {
    final TabPageController c = Get.find(tag: widget.tab.name);
    await c.onRefresh();
    _itemKeys = {};
  }

  @override
  void initState() {
    super.initState();
    scrollCtrl.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollCtrl.removeListener(scrollListener);
    scrollCtrl.dispose();
    super.dispose();
  }

  void onScrollEnd() {
    if (!BaseController.to.currentConfig.autoLoadPostContent) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 获取 ListView 的 RenderObject
      final RenderObject? listViewRenderObject = scrollCtrl.position.context.storageContext.findRenderObject();
      if (listViewRenderObject is RenderBox) {
        // 获取可见区域
        //ctrl.position.viewportDimension list高度
        List<int> visibleItems = [];

        _itemKeys.forEach((index, GlobalKey key) {
          final RenderObject? renderObject = key.currentContext?.findRenderObject();
          if (renderObject is RenderBox) {
            final Offset childOffset = renderObject.localToGlobal(Offset.zero);
            //childOffset.dy item的绝对y坐标
            if (childOffset.dy > 0 && childOffset.dy < scrollCtrl.position.viewportDimension + 300) {
              visibleItems.add(index);
            }
          }
        });

        final TabPageController c = Get.find(tag: widget.tab.name);
        //如果猛的一次滑动到后面，那么会出现同时有7-10个可见的情况。这里做个限制
        visibleItems.sublist(0, visibleItems.length > 3 ? 3 : visibleItems.length).forEach((v) {
          _itemKeys.remove(v);
          var item = c.postList[v];
          if (item.contentText.isEmpty) {
            print('请求内容: ${item.title}');
            c.getPostContent(item);
          }
        });
        print('可见: ${visibleItems},_itemKeys$_itemKeys');
      }
    });
  }

  void scrollListener() {
    if (scrollCtrl.position.pixels == scrollCtrl.position.maxScrollExtent) {
      TabPageController c = Get.find(tag: widget.tab.name);
      c.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        child: GetBuilder<TabPageController>(
            init: TabPageController(tab: widget.tab),
            tag: widget.tab.name,
            builder: (_) {
              if (_.loading && _.postList.length == 0) return LoadingListPage();
              if (_.needAuth)
                return NoData(cb: () {
                  if (BaseController.to.isLogin) {
                    _.onRefresh();
                  }
                });
              return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification) {
                      onScrollEnd();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    physics: new AlwaysScrollableScrollPhysics(),
                    controller: scrollCtrl,
                    itemCount: _.postList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final key = GlobalKey();
                      _itemKeys[index] = key;
                      if (_.postList.length - 1 == index) {
                        return Column(key: key, children: [
                          PostItem(item: _.postList[index], tab: widget.tab),
                          FooterTips(loading: _.isLoadingMore),
                          if (_.nodeList.isNotEmpty) TabChildNodes(list: _.nodeList)
                        ]);
                      }
                      return PostItem(key: key, item: _.postList[index], tab: widget.tab);
                    },
                  ));
            }),
        onRefresh: onRefresh);
  }

  @override
  bool get wantKeepAlive => true;
}
