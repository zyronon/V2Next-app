import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/footer.dart';
import 'package:v2ex/components/loading_list_page.dart';
import 'package:v2ex/components/no_data.dart';
import 'package:v2ex/components/post_item.dart';
import 'package:v2ex/components/tab_child_node.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/http/request.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/utils/event_bus.dart';

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
    EventBus().off('post_detail', mergePost as EventCallback);
  }

  @override
  void onInit() async {
    super.onInit();
    getData(isRefresh: true);
    EventBus().on('post_detail', mergePost as EventCallback);
  }

  mergePost(post) {
    print('mergePost${post}');
    var rIndex = postList.indexWhere((v) => v.postId == post.postId);
    if (rIndex > -1) {
      postList[rIndex].replyCount = post.replyCount;
      update();
    }
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
      if (isRefresh) {
        var maxI = postList.length > 3 ? 3 : postList.length;
        for (var i = 0; i < maxI; i++) {
          var item = postList[i];
          Http().get('/api/topics/show.json?id=${item.postId}').then((res) {
            try {
              String t = res.data[0]['content_rendered'];
              item.contentRendered = t + ' ';
              update();
            } catch (e) {}
          });
        }
      }
    } else {
      needAuth = res.data == Auth.notAllow;
    }
    if (isRefresh) loading = false;
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
  final ScrollController ctrl = ScrollController();
  Map<int, GlobalKey> _itemKeys = {}; // 存储每个子项的 GlobalKey

  Future<void> onRefresh() async {
    final TabPageController c = Get.find(tag: widget.tab.name);
    await c.onRefresh();
    _itemKeys = {};
  }

  @override
  void initState() {
    super.initState();
    ctrl.addListener(scrollListener);
    ctrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    ctrl.removeListener(_onScroll);
    ctrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 获取 ListView 的 RenderObject
      final RenderObject? listViewRenderObject = ctrl.position.context.storageContext.findRenderObject();
      if (listViewRenderObject is RenderBox) {
        // 获取可见区域
        //ctrl.position.viewportDimension list高度
        List<int> visibleItems = [];

        _itemKeys.forEach((index, GlobalKey key) {
          final RenderObject? renderObject = key.currentContext?.findRenderObject();
          if (renderObject is RenderBox) {
            final Offset childOffset = renderObject.localToGlobal(Offset.zero);
            //childOffset.dy item的绝对y坐标
            if (childOffset.dy > 0 && childOffset.dy < ctrl.position.viewportDimension + 300) {
              visibleItems.add(index);
            }
          }
        });

        final TabPageController c = Get.find(tag: widget.tab.name);
        visibleItems.forEach((v) {
          var item = c.postList[v];
          if (item.contentRendered.isEmpty) {
            _itemKeys.remove(v);
            print('请求内容: ${item.title}');
            Http().get('/api/topics/show.json?id=${item.postId}').then((res) {
              try {
                String t = res.data[0]['content_rendered'];
                item.contentRendered = t + ' ';
                c.update();
              } catch (e) {}
            });
          }
        });
        // print('可见: ${visibleItems},_itemKeys$_itemKeys');
      }
    });
  }

  void scrollListener() {
    if (ctrl.position.pixels == ctrl.position.maxScrollExtent) {
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
              return ListView.builder(
                physics: new AlwaysScrollableScrollPhysics(),
                controller: ctrl,
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
              );
            }),
        onRefresh: onRefresh);
  }

  @override
  bool get wantKeepAlive => true;
}
