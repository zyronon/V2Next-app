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
              print('页面加载完全');
              controller.runJavaScript(data);
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://v2ex.com'))
      ..addJavaScriptChannel('Channel', onMessageReceived: (JavaScriptMessage message) {
        print('v2-channel' + message.message);
      });
  }

  submit() {
    print("test");
    controller.loadRequest(Uri.parse('https://v2ex.com'));
    // Navigator.pushNamed(context, 'Home');
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
                child: Stack(
                  children: <Widget>[
                    // Positioned(
                    //     top: 0,
                    //     left: 0,
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 600,
                    //     child: WebViewWidget(controller: controller)),
                    Positioned(
                      top: 0,
                      left: 0,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
                        children: <Widget>[
                          // Positioned(
                          //   bottom: 200,
                          //   right: 100,
                          //   child: ElevatedButton(
                          //     child: Text("normal12"),
                          //     onPressed: () {
                          //       controller.reload();
                          //     },
                          //   ),
                          // ),
                          Positioned(
                              top: 0,
                              left: 0,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: ListView.separated(
                                itemCount: 100,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Row(
                                          children: [
                                            CircleAvatar(
                                              maxRadius: 16.w,
                                              backgroundImage: NetworkImage(
                                                  "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4"),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                'zyronon四',
                                                style: TextStyle(fontSize: 14.sp, height: 1.2),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                '1小时30分钟前',
                                                style: TextStyle(fontSize: 10, height: 1.2),
                                              ),
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          verticalDirection: VerticalDirection.down),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                        ),
                                        child: Text(
                                          '为什么很多人都用《》表示引用，而不用 “” 或「」',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                        ),
                                      ),
                                      // Text(
                                      //   '为什么很多人  或「」',
                                      //   textAlign: TextAlign.left,
                                      // ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: [
                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius: BorderRadius.circular(3.0), //3像素圆角
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                                child: Text(
                                                  "NAS",
                                                  style: TextStyle(color: Colors.black, fontSize: 10.sp),
                                                ),
                                              ),
                                            ),
                                            DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius: BorderRadius.circular(6.0), //3像素圆角
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                                child: Text(
                                                  "123",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        ),
                                      )
                                    ]),
                                  );
                                },
                                //分割器构造器
                                separatorBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 6,
                                    color: Color(0xfff1f1f1),
                                  );
                                },
                              ))
                        ],
                      ),
                    )
                  ],
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
