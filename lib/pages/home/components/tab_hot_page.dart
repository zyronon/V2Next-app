import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v2next/components/footer.dart';
import 'package:v2next/components/loading_list_page.dart';
import 'package:v2next/components/post_item.dart';
import 'package:v2next/http/api.dart';
import 'package:v2next/http/request.dart';
import 'package:v2next/model/base_controller.dart';

import 'package:v2next/model/model.dart';
import 'package:v2next/utils/event_bus.dart';
import 'package:v2next/utils/utils.dart';

class TabHotPageController extends GetxController {
  bool loading = true;
  bool needAuth = false;
  List<Map> mapPostList = [];

  final BaseController home = Get.find();
  NodeItem tab;
  String test = '';
  int pageNo = 0;
  List<String> dateList = [];
  bool isLoadingMore = false;

  TabHotPageController({required this.tab});

  @override
  void onClose() {
    super.onClose();
    EventBus().off(EventKey.postDetail, mergePost);
  }

  @override
  void onInit() async {
    super.onInit();
    getList(isRefresh: true);
    dateList = await Api.getV2HotDateMap();
    EventBus().on(EventKey.postDetail, mergePost);
  }

  List<Post> get allList {
    return mapPostList.map((item) => item['list']).expand((list) => list).toList().cast();
  }

  mergePost(post) {
    print('mergePost${post}');
    var rIndex = allList.indexWhere((v) => v.postId == post.postId);
    if (rIndex > -1) {
      allList[rIndex].replyCount = post.replyCount;
      update();
    }
  }

  String get currentDate {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    return formatted;
  }

  getList({String? date, bool isRefresh = false}) async {
    print('getHotList');
    if (isRefresh) {
      loading = true;
      update();
    }
    Result res = await Api.getHotPostList(date: date);
    if (res.success) {
      needAuth = false;
      if (isRefresh) mapPostList = [];
      if (date == null) {
        mapPostList.add({'date': currentDate, 'list': res.data});
      } else {
        mapPostList.add({'date': date, 'list': res.data});
      }
    } else {
      needAuth = res.data == Auth.notAllow;
    }
    if (isRefresh) {
      loading = false;
      if (BaseController.to.currentConfig.autoLoadPostContent) {
        var maxI = allList.length > 3 ? 3 : allList.length;
        for (var i = 0; i < maxI; i++) {
          var item = allList[i];
          getPostContent(item);
        }
      }
    }
    update();
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

  onRefresh() async {
    pageNo = 0;
    isLoadingMore = false;
    await getList(isRefresh: true);
    Api.getV2HotDateMap().then((v) => dateList = v);
  }

  loadMore() async {
    if (isLoadingMore) return;
    if ((dateList.length - 1) >= pageNo) {
      String date = dateList[pageNo];
      pageNo++;
      if (date == currentDate) {
        loadMore();
      } else {
        print('加载更多:${date}');
        isLoadingMore = true;
        update();
        await getList(date: date);
        isLoadingMore = false;
        update();
      }
    }
  }
}

class TabHotPage extends StatefulWidget {
  final NodeItem tab;

  const TabHotPage({super.key, required this.tab});

  @override
  State<TabHotPage> createState() => _TabHotPageState();
}

class _TabHotPageState extends State<TabHotPage> with AutomaticKeepAliveClientMixin {
  final ScrollController scrollCtrl = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  Map<int, GlobalKey> _itemKeys = {}; // 存储每个子项的 GlobalKey

  Future<void> onRefresh() async {
    final TabHotPageController c = Get.find(tag: widget.tab.name);
    await c.onRefresh();
    _itemKeys = {};
    return;
  }

  @override
  void initState() {
    super.initState();
    scrollCtrl.addListener(scrollListener);
    EventBus().on(EventKey.refreshTab, refreshTab);
  }

  @override
  void dispose() {
    super.dispose();
    scrollCtrl.removeListener(scrollListener);
    scrollCtrl.dispose();
    EventBus().off(EventKey.refreshTab, refreshTab);
  }

  refreshTab(_) {
    final TabHotPageController c = Get.find(tag: widget.tab.name);
    if (_.name == c.tab.name) {
      scrollCtrl.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
      refreshKey.currentState?.show();
    }
  }

  void scrollListener() {
    if (scrollCtrl.position.pixels == scrollCtrl.position.maxScrollExtent) {
      final TabHotPageController c = Get.find(tag: widget.tab.name);
      c.loadMore();
    }
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

        final TabHotPageController c = Get.find(tag: widget.tab.name);
        //如果猛的一次滑动到后面，那么会出现同时有7-10个可见的情况。这里做个限制
        visibleItems.sublist(0, visibleItems.length > 3 ? 3 : visibleItems.length).forEach((v) {
          _itemKeys.remove(v);
          List<Post> list = c.allList.where((j) => j.postId == v).toList();
          if (list.isNotEmpty) {
            list.forEach((item) {
              if (item.contentText.isEmpty) {
                print('请求内容: ${item.title}');
                c.getPostContent(item);
              }
            });
          }
        });
        print('可见: ${visibleItems},_itemKeys$_itemKeys');
      }
    });
  }

  List<Widget> _buildSlivers() {
    final TabHotPageController c = Get.find(tag: widget.tab.name);
    List<Widget> slivers = [];
    for (var item in c.mapPostList) {
      slivers.add(
          // SliverAppBar(title: Text(item['date']),floating: true, )
          StickySliverToBoxAdapter(
              child: RepaintBoundary(
        child: Container(
          padding: EdgeInsets.all(8.w),
          color: Colors.grey[100],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(item['date'] + '•'),
                Text(item['date'] == c.currentDate ? '实时' : '采集'),
                SizedBox(width: 5.w),
                InkWell(
                  child: Icon(Icons.help_outline, size: 14.w),
                  onTap: () => Utils.toast(msg: item['date'] == c.currentDate ? '列表数据来源于实时请求v2ex.com解析' : '列表数据来源于当天23:30采集，回复时间以当天23:30为准', duration: 5),
                )
              ]),
              // Icon(Icons.calendar_month, size: 18.w)
            ],
          ),
        ),
      )));

      slivers.add(SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          var temp = item['list'][index];
          final key = GlobalKey();
          _itemKeys[temp.postId] = key;
          return PostItem(key: key, item: temp, tab: widget.tab);
        },
        childCount: item['list'].length,
      )));
    }
    slivers.add(SliverToBoxAdapter(child: FooterTips(loading: c.isLoadingMore)));
    return slivers;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        key: refreshKey,
        child: GetBuilder<TabHotPageController>(
            init: TabHotPageController(tab: widget.tab),
            tag: widget.tab.name,
            builder: (_) {
              if (_.loading && _.mapPostList.length == 0) return LoadingListPage();
              return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification) {
                      onScrollEnd();
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    controller: scrollCtrl,
                    physics: new AlwaysScrollableScrollPhysics(),
                    slivers: _buildSlivers(),
                  ));
            }),
        onRefresh: onRefresh);
  }

  @override
  bool get wantKeepAlive => true;
}

//依次吸顶的header。参考自：https://blog.csdn.net/gzx110304/article/details/132798348
class StickySliverToBoxAdapter extends SingleChildRenderObjectWidget {
  const StickySliverToBoxAdapter({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _StickyRenderSliverToBoxAdapter();
}

class _StickyRenderSliverToBoxAdapter extends RenderSliverSingleBoxAdapter {
//查找前一个吸顶的section
  RenderSliver? _prev() {
    if (parent is RenderViewportBase) {
      RenderSliver? current = this;
      while (current != null) {
        current = (parent as RenderViewportBase).childBefore(current);
        if (current is _StickyRenderSliverToBoxAdapter && current.geometry != null) {
          return current;
        }
      }
    }
    return null;
  }

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    //摆放子View，并把constraints传递给子View
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    //获取子View在滑动主轴方向的尺寸
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }

    final double minExtent = childExtent;
    final double minAllowedExtent = constraints.remainingPaintExtent > minExtent ? minExtent : constraints.remainingPaintExtent;
    final double maxExtent = childExtent;
    final double paintExtent = maxExtent;
    final double clampedPaintExtent = clampDouble(
      paintExtent,
      minAllowedExtent,
      constraints.remainingPaintExtent,
    );
    final double layoutExtent = maxExtent - constraints.scrollOffset;

    geometry = SliverGeometry(
      scrollExtent: maxExtent,
      paintOrigin: min(constraints.overlap, 0.0),
      paintExtent: clampedPaintExtent,
      layoutExtent: clampDouble(layoutExtent, 0.0, clampedPaintExtent),
      maxPaintExtent: maxExtent,
      maxScrollObstructionExtent: minExtent,
      hasVisualOverflow: true, // Conservatively say we do have overflow to avoid complexity.
    );

    //上推关键代码: 当前吸顶的Sliver被覆盖了多少，前一个吸顶的Sliver就移动多少
    RenderSliver? prev = _prev();
    if (prev != null && constraints.overlap > 0) {
      setChildParentData(_prev()!, constraints.copyWith(scrollOffset: constraints.overlap), _prev()!.geometry!);
    }
  }
}
