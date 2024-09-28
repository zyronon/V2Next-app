import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:v2ex/bus.dart';
import 'package:v2ex/components/TabPage/TabPageController.dart';
import 'package:v2ex/model/Controller.dart';
import 'package:v2ex/model/Post.dart';

// class TabBarViewPage extends StatefulWidget {
//   final String node;
//
//   const TabBarViewPage({super.key, required this.node});
//
//   @override
//   State<TabBarViewPage> createState() => _TabBarViewPageState();
// }

class TabBarViewPage extends StatelessWidget {
  final String node;
  final BaseController c = Get.find();
  final TabPageController tc;

  TabBarViewPage({super.key, required this.node}) :
        tc = Get.put(TabPageController());


  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabPageController>(builder: (_) {
      if (_.postList.length == 0) {
        return ListView.separated(
          itemCount: 10,
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
      return RefreshIndicator(
          child: ListView.separated(
            itemCount: _.postList.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.all(8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    children: [
                      Row(children: [
                        CircleAvatar(
                          maxRadius: 14.w,
                          backgroundImage: NetworkImage(_.postList?[index]?.member?.avatar ?? ''),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Text(
                            _.postList[index].member?.username ?? '',
                            style: TextStyle(fontSize: 14.sp, height: 1.2),
                          ),
                        ),
                      ]),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(4.r), //3像素圆角
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                          child: Text(
                            _.postList[index]?.replyCount?.toString() ?? '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
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
                        _.postList[index].title ?? '',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.sp),
                      ),
                    ),
                    onTap: () => {getPost(_.postList[index])},
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10.w),
                      child: Row(
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.w),
                              child: Text(
                                _.postList[index]?.node?.title ?? '',
                                style: TextStyle(color: Colors.black, fontSize: 10.sp),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            _.postList[index]?.lastReplyDate ?? '',
                            style: TextStyle(fontSize: 10.sp, height: 1.2, color: Colors.grey),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '最后回复来自',
                            style: TextStyle(fontSize: 10.sp, height: 1.2, color: Colors.grey),
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                              child: Text(
                                _.postList[index]?.lastReplyUsername ?? '',
                                style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.black),
                              )),
                        ],
                      ))
                ]),
              );
            },
            //分割器构造器
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 6,
                color: Color(0xfff1f1f1),
              );
            },
          ),
          onRefresh: onRefresh);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }
}
