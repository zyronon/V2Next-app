import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:v2ex/components/TabPage/TabPageController.dart';

class TabBarViewPage extends StatefulWidget {
  final String node;

  const TabBarViewPage({super.key, required this.node});

  @override
  State<TabBarViewPage> createState() => _TabBarViewPageState();
}

class _TabBarViewPageState extends State<TabBarViewPage> with AutomaticKeepAliveClientMixin {
  getPost(post) {
    Get.toNamed('PostDetail');
  }

  Future<void> onRefresh() async {
    final TabPageController c = Get.find(tag: widget.node);
    c.getList(widget.node);
    return;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<TabPageController>(
        init: TabPageController(node: widget.node),
        tag: widget.node,
        builder: (_) {
      if (_.postList.length == 0) {
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
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
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
                        // style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15.sp),
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
                      ),
                    ),
                    onTap: () => {getPost(_.postList[index])},
                  ),
                  InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        '''手贱升级了小而美，8.0.51 ，安卓

服务号消息全给折叠了

折叠就不要我看的意思对吧，我忍，银行扣款我不看了～～～

但是你这个未读红点提示是什么鬼。“服务号”点进去红点也消不掉，还得再点一层，进入折叠详情才能消掉。。。。

把最恶心的缺点集中一起做成 💩 喂用户吃。。。。。

什么鬼😧😧😧😧😧😧😧😧😧😧😧😧😧''',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp,color: Colors.black87),
                      ),
                    ),
                    onTap: () => {getPost(_.postList[index])},
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10.w),
                      child: Row(
                        children: [
                          Text(
                            _.postList[index]?.lastReplyDate ?? '',
                            style: TextStyle(fontSize: 10.sp, height: 1.2, color: Colors.grey),
                          ),
                          SizedBox(width: 8.w),
                          // Text(
                          //   '最后回复来自',
                          //   style: TextStyle(fontSize: 10.sp, height: 1.2, color: Colors.grey),
                          // ),
                          // SizedBox(width: 2.w),
                          // Expanded(
                          //     child: Text(
                          //   _.postList[index]?.lastReplyUsername ?? '',
                          //   style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.black),
                          // )),
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
}
