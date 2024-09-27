import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/model/LoginForm.dart';

class Login extends StatelessWidget{

  TextEditingController _codeController = new TextEditingController();
  final loginForm = LoginForm().obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    // InAppWebViewController.clearAllCache();
                    // await headlessWebView?.dispose();
                    // await headlessWebView?.run();
                    // await headlessWebView?.webViewController?.clearCache();
                    // await headlessWebView?.webViewController?.reload();
                  },
                  child: const Text("无头刷新")),
              ElevatedButton(
                  onPressed: () {
                    // showLoginModal22();
                  },
                  child: const Text('无关登录')),
            ],
          ),
          Container(
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: "账号",
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none,
              ),
            ),
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            decoration: BoxDecoration(color: Color(0xfff1f1f1), borderRadius: BorderRadius.circular(6.r)),
            margin: EdgeInsets.only(bottom: 10.w),
          ),
          Container(
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: "账号",
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none,
              ),
            ),
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            decoration: BoxDecoration(color: Color(0xfff1f1f1), borderRadius: BorderRadius.circular(6.r)),
            margin: EdgeInsets.only(bottom: 10.w),
          ),
          Container(
            child: TextField(
              controller: _codeController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: "验证码",
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none,
              ),
            ),
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            decoration: BoxDecoration(color: Color(0xfff1f1f1), borderRadius: BorderRadius.circular(6.r)),
            margin: EdgeInsets.only(bottom: 10.w),
          ),
          Obx(() {
            if (loginForm().img != null) {
              return InkWell(
                // child: Obx(() => Image.network('https://www.v2ex.com/${loginForm().img}', height: 50.w, fit: BoxFit.cover)),
                child: Obx(() => Image.memory(base64.decode(loginForm().img!), height: 50.w, fit: BoxFit.cover)),
                onTap: () {
                  loginForm.update((val) {
                    val?.img = '_captcha?once=${loginForm().once}&now=${new DateTime.now().millisecondsSinceEpoch}';
                  });
                },
              );
            }
            return Text('data');
          }),
          ElevatedButton(
            child: Text("登录"),
            onPressed: () async {
              print(_codeController.text);
              loginForm.update((val) => val?.code = _codeController.text);
              // var result5 = await headlessWebView?.webViewController?.callAsyncJavaScript(functionBody: "return window.jsFunc.login(JSON.parse('${loginForm().toString()}'))");
              // print(result5);
            },
          )
        ],
      ),
    );
  }
}