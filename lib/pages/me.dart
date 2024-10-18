import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/model/BaseController.dart';

class MePage extends StatelessWidget {
  Widget _buildNumItem(String name, int num, [GestureTapCallback? onTap]) {
    return InkWell(
        child: Column(children: [
          Text(num.toString(), style: TextStyle(fontSize: 18.sp)),
          Text(name, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
        ]),
        onTap: onTap);
  }

  Widget _buildMenuItem(String name, IconData icon, [GestureTapCallback? onTap]) {
    return InkWell(
      child: Container(
          height: 60.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                Icon(icon),
                SizedBox(width: 10.w),
                Text(name,style: TextStyle(fontSize: 15.sp)),
              ]),
              Icon(Icons.keyboard_arrow_right),
            ],
          )),
      onTap: onTap,
    );
  }

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
                    InkWell(
                      child: Text(
                        _.isLogin ? _.member.username : '登录',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      onTap: () => Get.toNamed('/login'),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20.w),
            Container(
              padding: EdgeInsets.fromLTRB(12.w, 30.w, 12.w, 30.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNumItem('节点收藏', 3),
                  Container(width: 1.w, height: 25.w, color: Colors.grey[200]),
                  _buildNumItem('主题收藏', 3),
                  Container(width: 1.w, height: 25.w, color: Colors.grey[200]),
                  _buildNumItem('特别关注', 3),
                  Container(width: 1.w, height: 25.w, color: Colors.grey[200]),
                  _buildNumItem('历史浏览', 3),
                ],
              ),
            ),
            SizedBox(height: 20.w),
            Container(
                padding: EdgeInsets.fromLTRB(12.w, 0.w, 12.w, 0.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(children: [
                  _buildMenuItem('余额', TDIcons.money_circle, () {
                    Get.toNamed('/balance');
                  }),
                  Divider(height: 1.w, color: Colors.grey[200]),
                  _buildMenuItem('记事本', Icons.format_list_bulleted, () {
                    Get.toNamed('/notes');
                  }),
                  Divider(height: 1.w, color: Colors.grey[200]),
                  _buildMenuItem('反馈', TDIcons.service, () {
                    Get.toNamed('/feedback');
                  }),
                  Divider(height: 1.w, color: Colors.grey[200]),
                  _buildMenuItem('设置', TDIcons.setting, () {
                    Get.toNamed('/setting');
                  }),
                ]))
          ],
        ),
      );
    });
  }
}
