import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/model/BaseController.dart';

class Me extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseController>(builder: (_) {
      return Container(
        padding: EdgeInsets.all(20.w),
        color: Colors.grey[300],
        child: Column(
          children: [
            Row(
              children: [
                BaseAvatar(src: _.member.avatar, diameter: 60.r, radius: 100.r),
                SizedBox(width: 10.w),
                Column(
                  children: [
                    Text(
                      _.member.username,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20.w),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Text('3'),
                    Text('节点收藏'),
                  ]),
                  Column(children: [
                    Text('3'),
                    Text('节点收藏'),
                  ]),
                  Column(children: [
                    Text('3'),
                    Text('节点收藏'),
                  ]),
                  Column(children: [
                    Text('3'),
                    Text('历史浏览'),
                  ]),
                ],
              ),
            ),
            CupertinoButton(
                child: Text('登录1'),
                onPressed: () {
                  Get.toNamed('/login');
                })
          ],
        ),
      );
    });
  }
}
