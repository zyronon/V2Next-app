import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/utils/api.dart';

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

  onRefresh() {
    pageNo = 0;
    getList(isRefresh: true);
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
    } else {
      Get.snackbar('提示', '没有更多数据了');
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
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  getPost(Post2 post) {
    Get.toNamed('/post-detail', arguments: post);
    // Get.toNamed('/test', arguments: post);
  }

  Future<void> onRefresh() async {
    final TabHotPageController c = Get.find(tag: widget.tab.id);
    c.onRefresh();
    return;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    final TabHotPageController c = Get.find(tag: widget.tab.id);
    c.loadMore();
  }

  Widget _buildItem(Post2 item) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Row(children: [
                if (widget.tab.type != TabType.latest)
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: BaseAvatar(
                      src: item.member.avatar,
                      diameter: 34.w,
                      radius: 4.w,
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.member.username,
                      style: TextStyle(fontSize: 14.sp, height: 1.2),
                    ),
                    SizedBox(height: 4.w),
                    Row(
                      children: [
                        if (item.isTop) ...[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                              child: Text(
                                '置顶',
                                style: TextStyle(color: Colors.white, fontSize: 10.sp, height: 1.4),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                        ],
                        if (item.lastReplyDateAgo.isNotEmpty) ...[
                          Text(
                            item.lastReplyDateAgo,
                            style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                          ),
                          SizedBox(width: 10.w),
                        ],
                        if (item.createDateAgo.isNotEmpty) ...[
                          Text(
                            item.createDateAgo + '发布',
                            style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                          ),
                          SizedBox(width: 10.w),
                        ],
                        if (item.node.title.isNotEmpty)
                          // 这里的点击事件，最新index.xml获取到的数据没有url
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xffe4e4e4),
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                              child: Text(
                                item.node.title,
                                style: TextStyle(color: Colors.black54, fontSize: 10.sp, height: 1.4),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                )
              ]),
              if (item.replyCount != 0)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(4.r), //3像素圆角
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                    child: Text(
                      item.replyCount.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 10.sp, fontWeight: FontWeight.w500, height: 1.4),
                    ),
                  ),
                ),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            verticalDirection: VerticalDirection.down,
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                item.title,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w100, fontSize: 15.sp),
              ),
            ),
            onTap: () => {getPost(item)},
          ),
          // InkWell(
          //   child: Padding(
          //     padding: EdgeInsets.only(
          //       top: 10,
          //     ),
          //     child: BaseHtmlWidget(html: item.contentHtml),
          //   ),
          //   onTap: () => {getPost(item)},
          // ),
        ]),
      ),
      onTap: () => {getPost(item)},
    );
  }

  List<Widget> _buildSlivers() {
    final TabHotPageController c = Get.find(tag: widget.tab.id);
    List<Widget> slivers = [];
    for (var item in c.mapPostList) {
      slivers.add(
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.all(8.w),
            color: Colors.grey[100],
            child: Text(item['date']),
          ),
        ),
      );
      slivers.add(SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildItem(item['list'][index]);
        },
        childCount: item['list'].length,
      )));
    }
    slivers.add(SliverToBoxAdapter(
      child: c.isLoadingMore
          ? Padding(
              padding: EdgeInsets.all(8.w),
              child: Center(child: CircularProgressIndicator()),
            )
          : SizedBox.shrink(), // 没有更多数据时不显示
    ));
    return slivers;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            onRefresh();
          },
          child: Text('刷新')),
      body: RefreshIndicator(
          child: GetBuilder<TabHotPageController>(
              init: TabHotPageController(tab: widget.tab),
              tag: widget.tab.id,
              builder: (_) {
                if (_.loading) {
                  return ListView.separated(
                    itemCount: 7,
                    itemBuilder: (BuildContext context, int index) {
                      return Skeletonizer.zone(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Bone.circle(size: 28),
                              SizedBox(width: 10.w),
                              Bone.text(width: 80.w),
                            ], crossAxisAlignment: CrossAxisAlignment.center, verticalDirection: VerticalDirection.down),
                            Padding(padding: EdgeInsets.only(top: 10), child: Bone.multiText()),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      Bone.text(width: 40.w),
                                      SizedBox(width: 10.w),
                                      Bone.text(width: 70.w),
                                      SizedBox(width: 10.w),
                                      Bone.text(width: 70.w),
                                      SizedBox(width: 10.w),
                                      Bone.text(width: 70.w),
                                    ],
                                  ),
                                  Bone.text(width: 30.w),
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              ),
                            )
                          ]),
                        ),
                      );
                    },
                    //分割器构造器
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 6,
                        color: Color(0xfff1f1f1),
                      );
                    },
                  );
                }
                if (_.needAuth)
                  return Container(
                    height: 0.8.sh,
                    child: Center(
                        child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/nodata.png', width: 125, height: 125),
                          Text('没有数据', style: TextStyle(fontSize: 24.sp)),
                          SizedBox(height: 20.w),
                          TDButton(
                            text: '登录',
                            size: TDButtonSize.large,
                            type: TDButtonType.fill,
                            shape: TDButtonShape.rectangle,
                            theme: TDButtonTheme.primary,
                            onTap: () {
                              Get.toNamed('/login');
                            },
                          )
                        ],
                      ),
                    )),
                  );
                return CustomScrollView(
                  controller: _scrollController,
                  physics: new AlwaysScrollableScrollPhysics(),
                  slivers: _buildSlivers(),
                );
              }),
          onRefresh: onRefresh),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
