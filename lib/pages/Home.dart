import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final WebViewController controller;

  String html = """
  // \$.noConflict();
  // jQuery(document).ready(function(){
  //   jQuery(".topic-link").hide()
  // })
  
  """;

  int _selectedIndex = 1;
  double stateHeight = 0;

  @override
  void initState() {
    stateHeight = MediaQueryData.fromWindow(window).padding.top;

    super.initState();

    // #docregion webview_controller
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            print('页面加载完全');
            controller.runJavaScript(html);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://v2ex.com'));

    // #enddocregion webview_controller
  }

  // #docregion webview_widget
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: DefaultTextStyle(
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    minWidth: double.infinity, //宽度尽可能大
                    minHeight: double.infinity),
                child: Container(
                  padding: EdgeInsets.only(top: stateHeight),
                  child: WebViewWidget(controller: controller),
                ),
              )),
        ),
        onWillPop: () async {
          print("返回键点击了");
          // Navigator.pop(context);
          var isFinish = await controller.canGoBack().then((value) {
            if (value) {
              controller.goBack();
            }
            return !value;
          });
          return isFinish;
          return false;
        });
  }
// #enddocregion webview_widget
}
