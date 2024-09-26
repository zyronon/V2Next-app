import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v2ex/model/LoginForm.dart';
import 'package:v2ex/utils/index.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  HeadlessInAppWebView? headlessWebView;
  String url = "www.v2ex.com/signin";

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
      isInspectable: kDebugMode, mediaPlaybackRequiresUserGesture: false, allowsInlineMediaPlayback: true, iframeAllow: "camera; microphone", iframeAllowFullscreen: true);
  final GlobalKey webViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: settings,
      onLoadStop: (controller, url) async {
        controller.injectJavascriptFileFromAsset(assetFilePath: "assets/index.js");
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
  }

  test() async {
    var arg = {'func': 'getNodePostList', 'val': 'hot'};
    // arg = {'type': 'getNodePostList', 'val': 'hot'};
    // await headlessWebView?.webViewController?.evaluateJavascript(source: 'window.jsBridge("${arg['func']}","${arg['val']}")');
    var r = await headlessWebView?.webViewController?.callAsyncJavaScript(
      functionBody: 'return window.jsBridge("${arg['func']}","${arg['val']}")',
      arguments: arg,
    );
    print(r);

    var result5 = await headlessWebView?.webViewController?.callAsyncJavaScript(functionBody: 'return testAsync()');
    print(result5); // {value: 49, error: null}
  }

  modalWrap(Widget text, Widget other) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  constraints: BoxConstraints(maxHeight: .5.sh),
                  padding: EdgeInsets.all(14.w),
                  width: ScreenUtil().screenWidth * .91,
                  child: SingleChildScrollView(child: text)),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                ),
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 0.w),
                width: double.infinity,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.w,
                        margin: EdgeInsets.only(bottom: 10.w, top: 15.w),
                        decoration: BoxDecoration(color: Color(0xffcacaca), borderRadius: BorderRadius.all(Radius.circular(2.r))),
                      ),
                    ),
                    other
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TextEditingController _codeController = new TextEditingController();
  final loginForm = LoginForm(img: '_captcha').obs;

  input() {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
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
          InkWell(
            child: Obx(() => Image.network('https://www.v2ex.com/${loginForm().img}', height: 50.w, fit: BoxFit.cover)),
            onTap: () {
              // loginForm.value.img = '_captcha?now=${new DateTime.now().millisecondsSinceEpoch}';
              loginForm.update((val) {
                val?.img = '_captcha?now=${new DateTime.now().millisecondsSinceEpoch}';
              });
            },
          ),
          ElevatedButton(
            child: Text("登录"),
            onPressed: () async {
              print(_codeController.text);
              loginForm.update((val) => val?.code = _codeController.text);
              var result5 = await headlessWebView?.webViewController?.callAsyncJavaScript(functionBody: "return window.jsFunc.login(JSON.parse('${loginForm().toString()}'))");
              print(result5);
            },
          )
        ],
      ),
    );
  }

  showLoginModal() async {
    // await headlessWebView?.dispose();
    // await headlessWebView?.run();
    // modalWrap(Text('data'), input());
    // print(1);
    // print(loginForm().toString());
    // print(loginForm.toString());
    // var result5 = await headlessWebView?.webViewController?.callAsyncJavaScript(functionBody: 'return  window.jsFunc.getLoginPageInfo()');
    // print(result5);
    // var res = (result5?.value);
    // if (!res['error']) {
    //   loginForm(LoginForm.fromJson(res['data']));
    //   print(loginForm.value.codeKey);
    //
    //   Timer(Duration(seconds: 1), () async {
    //     var result56 = await headlessWebView?.webViewController?.callAsyncJavaScript(functionBody: "return window.jsFunc.login(JSON.parse('${loginForm().toString()}'))");
    //     print(result56);
    //     print("3秒后执行");
    //   });
    // }

    //------------------

    var result5 = await webViewController?.callAsyncJavaScript(functionBody: 'return window.jsFunc.getLoginPageInfo()');
    print(result5);
    var res = (result5?.value);
    if (!res['error']) {
      loginForm(LoginForm.fromJson(res['data']));
      print(loginForm.value.codeKey);

      Timer(Duration(seconds: 1), () async {
        var result56 = await webViewController?.callAsyncJavaScript(functionBody: "return window.jsFunc.login(JSON.parse('${loginForm().toString()}'))");
        print(result56);
        print("1秒后执行");
      });
    }
  }

  showLoginModal22() async {
    var result5 = await headlessWebView?.webViewController?.callAsyncJavaScript(functionBody: 'return window.jsFunc.getLoginPageInfo()');
    print(result5);
    var res = (result5?.value);
    if (!res['error']) {
      loginForm(LoginForm.fromJson(res['data']));
      print(loginForm.value.codeKey);

      Timer(Duration(seconds: 1), () async {
        var result56 = await headlessWebView?.webViewController?.callAsyncJavaScript(functionBody: "return window.jsFunc.login(JSON.parse('${loginForm().toString()}'))");
        print(result56);
        print("1秒后执行");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      Row(
        children: [
          ElevatedButton(
              onPressed: () async {
                InAppWebViewController.clearAllCache();
                await headlessWebView?.dispose();
                await headlessWebView?.run();
                // await headlessWebView?.webViewController?.clearCache();
                // await headlessWebView?.webViewController?.reload();
              },
              child: const Text("无头刷新")),
          ElevatedButton(
              onPressed: () {
                showLoginModal22();
              },
              child: const Text('无关登录')),
        ],
      ),
      Row(
        children: [
          ElevatedButton(
              onPressed: () async {
                // await headlessWebView?.dispose();
                // await headlessWebView?.run();
                InAppWebViewController.clearAllCache();
                await webViewController?.clearCache();
                await webViewController?.reload();
              },
              child: const Text("刷新")),
          ElevatedButton(
              onPressed: () {
                showLoginModal();
              },
              child: const Text('登录')),
        ],
      ),
      // input()
      Expanded(
          child: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: WebUri("https://www.v2ex.com/signin")),
        initialSettings: settings,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          controller.injectJavascriptFileFromAsset(assetFilePath: "assets/index.js");
        },
        onConsoleMessage: (controller, consoleMessage) {
          if (kDebugMode) {
            print(consoleMessage);
          }
        },
      )),
    ])));
  }
}
