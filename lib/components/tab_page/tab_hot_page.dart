import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v2ex/components/footer.dart';
import 'package:v2ex/components/not_allow.dart';
import 'package:v2ex/components/post_item.dart';
import 'package:v2ex/components/loading_list_page.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/utils/api.dart';
import 'package:v2ex/utils/utils.dart';

class TabHotPageController extends GetxController {
  bool loading = true;
  bool needAuth = false;
  List<Post2> postList = [];
  List<Map> mapPostList = [];
  final BaseController home = Get.find();
  TabItem tab;
  String test = '';
  int pageNo = 0;
  List<String> dateList = [];
  bool isLoadingMore = false;

  TabHotPageController({required this.tab});

  @override
  void onInit() async {
    super.onInit();
    getList(isRefresh: true);
    if (tab.type == TabType.hot) {
      dateList = await Api.getV2HotDateMap();
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
    if (isRefresh) loading = false;
    update();
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
  final TabItem tab;

  const TabHotPage({super.key, required this.tab});

  @override
  State<TabHotPage> createState() => _TabHotPageState();
}

class _TabHotPageState extends State<TabHotPage> with AutomaticKeepAliveClientMixin {
  final ScrollController ctrl = ScrollController();

  Future<void> onRefresh() async {
    final TabHotPageController c = Get.find(tag: widget.tab.enName);
    await c.onRefresh();
    return;
  }

  @override
  void initState() {
    super.initState();
    ctrl.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    ctrl.removeListener(scrollListener);
    ctrl.dispose();
  }

  void scrollListener() {
    if (ctrl.position.pixels == ctrl.position.maxScrollExtent) {
      final TabHotPageController c = Get.find(tag: widget.tab.enName);
      c.loadMore();
    }
  }

  List<Widget> _buildSlivers() {
    final TabHotPageController c = Get.find(tag: widget.tab.enName);
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
                  onTap: () => Utils.toast(
                    msg: item['date'] == c.currentDate ? '列表数据来源于实时请求v2ex.com解析' : '列表数据来源于当天23:30采集，回复时间以当天23:30为准',
                    duration: 5
                  ),
                )
              ]),
              Icon(Icons.calendar_month, size: 18.w)
            ],
          ),
        ),
      )));
      slivers.add(SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          return PostItem(item: item['list'][index], tab: widget.tab);
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
        child: GetBuilder<TabHotPageController>(
            init: TabHotPageController(tab: widget.tab),
            tag: widget.tab.enName,
            builder: (_) {
              if (_.loading && _.mapPostList.length == 0) return LoadingListPage();
              if (_.needAuth) return NotAllow();
              return CustomScrollView(
                controller: ctrl,
                physics: new AlwaysScrollableScrollPhysics(),
                slivers: _buildSlivers(),
              );
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
