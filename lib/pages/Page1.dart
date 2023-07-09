import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late final WebViewController controller;

  String html = """
 
  
  """;

  int _selectedIndex = 1;
  double stateHeight = 0;

  @override
  void initState() {
    stateHeight = MediaQueryData.fromWindow(window).padding.top;

    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            rootBundle.loadString('assets/index.js').then((data) {
              print('页面加载完全' + data);
              controller.runJavaScript(data);
            });
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
      ..loadRequest(Uri.parse('https://v2ex.com'))
      ..addJavaScriptChannel('Channel', onMessageReceived: (JavaScriptMessage message) {
        print(message.message);
      });
  }

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
}
