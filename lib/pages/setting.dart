import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/http/login_api.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/utils/utils.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget _buildMenuItem({required String name, Widget? right, GestureTapCallback? onTap}) {
    return InkWell(
      child: Container(
          height: 60.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                Text(name, style: TextStyle(fontSize: 15.sp)),
              ]),
              Row(children: [
                if (right != null) right,
                if (right == null) Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              ])
            ],
          )),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置', style: TextStyle(fontSize: 17.sp))),
      body: SafeArea(child: GetBuilder<BaseController>(builder: (bc) {
        return Container(
          height: double.infinity,
          color: Colors.grey[100],
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('列表', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 10.w),
                Container(
                    padding: EdgeInsets.fromLTRB(12.w, 0.w, 12.w, 0.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(children: [
                      _buildMenuItem(
                          name: '首页Tab管理',
                          onTap: () {
                            Get.toNamed('/edit_tab');
                          }),
                      Const.lineWidget,
                      _buildMenuItem(
                          name: '字体排版设置',
                          onTap: () {
                            Get.toNamed('/layout');
                          }),
                      Const.lineWidget,
                      _buildMenuItem(
                          name: '自动签到',
                          right: TDSwitch(
                            size: TDSwitchSize.small,
                            isOn: bc.currentConfig.ignoreThankConfirm,
                            onChanged: (bool v) {
                              bc.currentConfig.ignoreThankConfirm = !bc.currentConfig.ignoreThankConfirm;
                              bc.saveConfig();
                              return true;
                            },
                          )),
                      Const.lineWidget,
                      _buildMenuItem(
                          name: '替换Imgur源',
                          right: TDSwitch(
                            size: TDSwitchSize.small,
                            isOn: bc.currentConfig.replaceImgur,
                            onChanged: (bool v) {
                              bc.currentConfig.replaceImgur = !bc.currentConfig.replaceImgur;
                              bc.saveConfig();
                              return true;
                            },
                          )),
                      Const.lineWidget,
                      _buildMenuItem(
                          name: '自动加载帖子内容',
                          right: TDSwitch(
                            size: TDSwitchSize.small,
                            isOn: bc.currentConfig.autoLoadPostContent,
                            onChanged: (bool v) {
                              bc.currentConfig.autoLoadPostContent = !bc.currentConfig.autoLoadPostContent;
                              bc.saveConfig();
                              return true;
                            },
                          )),
                      Const.lineWidget,
                      _buildMenuItem(
                          name: '用户标签',
                          right: TDSwitch(
                            size: TDSwitchSize.small,
                            isOn: bc.currentConfig.openTag,
                            onChanged: (bool v) {
                              bc.currentConfig.openTag = !bc.currentConfig.openTag;
                              bc.saveConfig();
                              return true;
                            },
                          )),
                      Const.lineWidget,
                      _buildMenuItem(
                          name: '显示高赞回复',
                          right: TDSwitch(
                            size: TDSwitchSize.small,
                            isOn: bc.currentConfig.showTopReply,
                            onChanged: (bool v) {
                              bc.currentConfig.showTopReply = !bc.currentConfig.showTopReply;
                              bc.saveConfig();
                              return true;
                            },
                          )),
                      Const.lineWidget,
                      _buildMenuItem(
                          name: '显示 ${bc.currentConfig.topReplyCount} 个高赞回复',
                          onTap: () {
                            TDPicker.showMultiPicker(context, title: '显示多少个高赞回复', onConfirm: (selected) {
                              bc.currentConfig.topReplyCount = selected[0] + 3;
                              Get.back();
                              bc.saveConfig();
                            }, data: [List.generate(30, (index) => (index + 1).toString()).sublist(2, 30)]);
                          }),
                      Const.lineWidget,
                      _buildMenuItem(
                          name: '至少 ${bc.currentConfig.topReplyLoveMinCount} 个赞判定为高赞',
                          onTap: () {
                            TDPicker.showMultiPicker(context, title: '多少个赞判定为高赞', onConfirm: (selected) {
                              bc.currentConfig.topReplyLoveMinCount = selected[0] + 3;
                              Get.back();
                              bc.saveConfig();
                            }, data: [List.generate(30, (index) => (index + 1).toString()).sublist(2, 30)]);
                          }),
                      Const.lineWidget,
                      _buildMenuItem(
                          name: '检查更新',
                          onTap: () {
                            TDPicker.showMultiPicker(context, title: '显示多少个高赞回复', onConfirm: (selected) {
                              bc.currentConfig.topReplyCount = selected[0] + 3;
                              Get.back();
                              bc.saveConfig();
                            }, data: [List.generate(30, (index) => (index + 1).toString()).sublist(2, 30)]);
                          }),
                      Const.lineWidget,
                      _buildMenuItem(
                          name: '关于 V2Next',
                          onTap: () {
                            TDPicker.showMultiPicker(context, title: '显示多少个高赞回复', onConfirm: (selected) {
                              bc.currentConfig.topReplyCount = selected[0] + 3;
                              Get.back();
                              bc.saveConfig();
                            }, data: [List.generate(30, (index) => (index + 1).toString()).sublist(2, 30)]);
                          }),
                      if (bc.isLogin) ...[
                        Const.lineWidget,
                        _buildMenuItem(
                            name: '退出登录',
                            right: Text(''),
                            onTap: () async {
                              await LoginApi.logout();
                              Restart.restartApp(
                                // Customizing the restart notification message (only needed on iOS)
                                notificationTitle: 'Restarting App',
                                notificationBody: 'Please tap here to open the app again.',
                              );
                            }),
                      ]
                    ]))
              ],
            ),
          )),
        );
      })),
    );
  }
}
