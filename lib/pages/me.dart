import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/model/BaseController.dart';

class Me extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseController>(builder: (_) {
      return Column(
        children: [
          BaseAvatar(src: _.member.avatar, diameter: 80.r, radius: 100.r),
          Container(
            child: Center(
              child: Text(
                _.member.username,
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
          ),
          CupertinoButton(
              child: Text('登录1'),
              onPressed: () {
                Get.toNamed('/login');
              })
        ],
      );
    });
  }
}
