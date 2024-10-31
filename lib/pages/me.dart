import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/components/BaseHtmlWidget.dart';
import 'package:v2ex/components/base_webview.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/utils.dart';

class MePage extends StatelessWidget {
  Widget _buildNumItem(String name, int num, [GestureTapCallback? onTap]) {
    return Expanded(
        child: InkWell(
            child: Column(children: [
              Text(num.toString(), style: TextStyle(fontSize: 18.sp)),
              Text(name, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
            ]),
            onTap: onTap));
  }

  Widget _buildMenuItem({required String name, required IconData icon, Widget? right, GestureTapCallback? onTap}) {
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
                Text(name, style: TextStyle(fontSize: 15.sp)),
              ]),
              Row(children: [
                if (right != null) right,
                Icon(Icons.keyboard_arrow_right,color: Colors.grey),
              ])
            ],
          )),
      onTap: onTap,
    );
  }

  Widget _card(Widget content) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      body: GetBuilder<BaseController>(builder: (_) {
        return Container(
          padding: EdgeInsets.all(20.w),
          color: Colors.grey[100],
          child: Column(
            children: [
              _card(Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _.member.avatar.isNotEmpty
                            ? BaseAvatar(src: _.member.avatar, diameter: 70.r, radius: 100.r)
                            : Container(
                          child: Image.asset(
                            'assets/images/user.png',
                            width: 70,
                            height: 70,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          children: [
                            InkWell(
                              child: Text(
                                _.isLogin ? _.member.username : '登录',
                                style: TextStyle(fontSize: 18.sp),
                              ),
                              onTap: () => Get.toNamed('/login'),
                            ),
                          ],
                        )
                      ],
                    ),
                    Icon(Icons.keyboard_arrow_right,color: Colors.grey),
                  ],
                ),
                Divider(color: Const.line,height: 30.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNumItem('节点收藏', _.member.actionCounts[0], () {
                      if (!Utils.checkIsLogin()) return;
                      Get.to(BaseWebView(url: 'https://www.v2ex.com/my/nodes'), transition: Transition.cupertino);
                    }),
                    Container(width: 1.w, height: 25.w, color: Colors.grey[200]),
                    _buildNumItem('主题收藏', _.member.actionCounts[1], () {
                      if (!Utils.checkIsLogin()) return;
                      Get.to(BaseWebView(url: 'https://www.v2ex.com/my/topics'), transition: Transition.cupertino);
                    }),
                    Container(width: 1.w, height: 25.w, color: Colors.grey[200]),
                    _buildNumItem('特别关注', _.member.actionCounts[2], () {
                      if (!Utils.checkIsLogin()) return;
                      Get.to(BaseWebView(url: 'https://www.v2ex.com/my/following'), transition: Transition.cupertino);
                    }),
                    // Container(width: 1.w, height: 25.w, color: Colors.grey[200]),
                    // _buildNumItem('历史浏览', 3),
                  ],
                )
              ],)),
              SizedBox(height: 20.w),
              Container(
                  padding: EdgeInsets.fromLTRB(12.w, 0.w, 12.w, 0.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(children: [
                    _buildMenuItem(
                        name: '创作新主题',
                        icon: Icons.create_outlined,
                        right: BaseHtmlWidget(html: _.member.balance),
                        onTap: () {
                          if (!Utils.checkIsLogin()) return;
                          Get.to(BaseWebView(url: 'https://www.v2ex.com/balance'), transition: Transition.cupertino);
                        }),
                    Divider(height: 1.w, color: Colors.grey[200]),
                    _buildMenuItem(
                        name: '最近浏览',
                        icon: Icons.history,
                        right: BaseHtmlWidget(html: _.member.balance),
                        onTap: () {
                          if (!Utils.checkIsLogin()) return;
                          Get.to(BaseWebView(url: 'https://www.v2ex.com/balance'), transition: Transition.cupertino);
                        }),
                    Divider(height: 1.w, color: Colors.grey[200]),
                    _buildMenuItem(
                        name: '余额',
                        icon: TDIcons.money_circle,
                        right: BaseHtmlWidget(html: _.member.balance),
                        onTap: () {
                          if (!Utils.checkIsLogin()) return;
                          Get.to(BaseWebView(url: 'https://www.v2ex.com/balance'), transition: Transition.cupertino);
                        }),
                    Divider(height: 1.w, color: Colors.grey[200]),
                    _buildMenuItem(
                        name: '记事本',
                        icon: Icons.format_list_bulleted,
                        onTap: () {
                          // Get.toNamed('/notes');
                          if (!Utils.checkIsLogin()) return;
                          Get.to(BaseWebView(url: 'https://www.v2ex.com/notes'), transition: Transition.cupertino);
                        }),
                    Divider(height: 1.w, color: Colors.grey[200]),
                    _buildMenuItem(
                        name: '反馈',
                        icon: TDIcons.service,
                        onTap: () {
                          Utils.openBrowser(Const.issues);
                        }),
                    Divider(height: 1.w, color: Colors.grey[200]),
                    _buildMenuItem(
                        name: '设置',
                        icon: TDIcons.setting,
                        onTap: () {
                          Get.toNamed('/setting');
                        }),
                  ]))
            ],
          ),
        );
      }),
    );
  }
}
