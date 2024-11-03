// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:v2ex/pages/login.dart';
import 'package:v2ex/utils/api.dart';
import 'package:v2ex/utils/global.dart';

import 'event_bus.dart';

class Login {
  static void onLogin() {
    Navigator.push(
      Routes.navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
        fullscreenDialog: true,
      ),
    ).then(
      (value) => {
        if (value['loginStatus'] == 'cancel') {SmartDialog.showToast('取消登录'), eventBus.emit('login', 'cancel')},
        if (value['loginStatus'] == 'success') {SmartDialog.showToast('登录成功'), eventBus.emit('login', 'success')}
      },
    );
  }

  static void loginDialog(
    String content, {
    String title = '提示',
    String cancelText = '取消',
    String confirmText = '去登录',
    bool isPopContext = false,
    bool isPopDialog = true,
  }) {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  SmartDialog.dismiss();
                  isPopContext ? Navigator.pop(context) : null;
                },
                child: Text(cancelText)),
            TextButton(
                onPressed: () async {
                  if (isPopDialog) {
                    SmartDialog.dismiss().then((value) => Get.toNamed('/login'));
                  } else {
                    Get.toNamed('/login');
                  }
                },
                child: Text(confirmText))
          ],
        );
      },
    );
  }

  static twoFADialog({VoidCallback? onSuccess}) async {
    String _currentPage = Get.currentRoute;
    print('_currentPage: $_currentPage');
    var twoFACode = '';
    return SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('2FA 验证'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('你的 V2EX 账号已经开启了两步验证，请输入验证码继续'),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: '验证码',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.0)),
                ),
                onChanged: (e) {
                  twoFACode = e;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  SmartDialog.dismiss();
                  await Api.logout();
                  if (_currentPage == '/login' || _currentPage == '/post_detail') {
                    Get.back(result: false);
                  }
                },
                child: const Text('取消')),
            TextButton(
                onPressed: () async {
                  if (twoFACode.length == 6) {
                    var res = await Api.twoFALOgin(twoFACode);
                    if (res == 'true') {
                      Api.getUserInfo();
                      SmartDialog.showToast('登录成功', displayTime: const Duration(milliseconds: 500)).then((res) {
                        SmartDialog.dismiss();
                        if (_currentPage == '/login') {
                          print('😊😊 - 登录成功');
                          Get.back(result: true);
                        }
                      });
                    } else {
                      twoFACode = '';
                    }
                  } else {
                    SmartDialog.showToast('验证码有误', displayTime: const Duration(milliseconds: 500));
                  }
                },
                child: const Text('登录'))
          ],
        );
      },
    );
  }
}
