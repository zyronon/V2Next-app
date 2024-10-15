import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/components/TabPage/TabPageController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';

class TabBarViewPage extends StatefulWidget {
  final TabItem tab;

  const TabBarViewPage({super.key, required this.tab});

  @override
  State<TabBarViewPage> createState() => _TabBarViewPageState();
}

class _TabBarViewPageState extends State<TabBarViewPage> with AutomaticKeepAliveClientMixin {
  getPost(Post2 post) {
    Get.toNamed('/post-detail', arguments: post);
    // Get.toNamed('/test', arguments: post);
  }

  Future<void> onRefresh() async {
    final TabPageController c = Get.find(tag: widget.tab.id);
    c.getList(widget.tab);
    return;
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
          child: GetBuilder<TabPageController>(
              init: TabPageController(tab: widget.tab),
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
                return ListView.separated(
                  itemCount: _.postList.length,
                  itemBuilder: (BuildContext context, int index) {
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
                                      src: _.postList[index].member.avatar,
                                      diameter: 34.w,
                                      radius: 4.w,
                                    ),
                                  ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _.postList[index].member.username,
                                      style: TextStyle(fontSize: 14.sp, height: 1.2),
                                    ),
                                    SizedBox(height: 4.w),
                                    Row(
                                      children: [
                                        if (_.postList[index].isTop) ...[
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
                                        if (_.postList[index].lastReplyDate.isNotEmpty) ...[
                                          Text(
                                            _.postList[index].lastReplyDate,
                                            style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                                          ),
                                          SizedBox(width: 10.w),
                                        ],
                                        if (_.postList[index].createDateAgo.isNotEmpty) ...[
                                          Text(
                                            _.postList[index].createDateAgo + '发布',
                                            style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                                          ),
                                          SizedBox(width: 10.w),
                                        ],
                                        if (_.postList[index].node.title.isNotEmpty)
                                          // 这里的点击事件，最新index.xml获取到的数据没有url
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: Color(0xffe4e4e4),
                                              borderRadius: BorderRadius.circular(3.r),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                                              child: Text(
                                                _.postList[index].node.title,
                                                style: TextStyle(color: Colors.black54, fontSize: 10.sp, height: 1.4),
                                              ),
                                            ),
                                          ),
                                      ],
                                    )
                                  ],
                                )
                              ]),
                              if (_.postList[index].replyCount != 0)
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(4.r), //3像素圆角
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                                    child: Text(
                                      _.postList[index].replyCount.toString(),
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
                                _.postList[index].title,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontWeight: FontWeight.w100, fontSize: 15.sp),
                              ),
                            ),
                            onTap: () => {getPost(_.postList[index])},
                          ),
                          // InkWell(
                          //   child: Padding(
                          //     padding: EdgeInsets.only(
                          //       top: 10,
                          //     ),
                          //     child: BaseHtmlWidget(html: _.postList[index].contentHtml),
                          //   ),
                          //   onTap: () => {getPost(_.postList[index])},
                          // ),
                        ]),
                      ),
                      onTap: () => {getPost(_.postList[index])},
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
              }),
          onRefresh: onRefresh),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
