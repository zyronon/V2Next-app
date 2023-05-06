import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample2 extends StatefulWidget {
  const WebViewExample2({super.key});

  @override
  State<WebViewExample2> createState() => _WebViewExample2State();
}

class _WebViewExample2State extends State<WebViewExample2> {
  late final WebViewController controller;

  String html = """
   setTimeout(()=>{
    document.write("123")
  },3000)
  """;

  @override
  void initState() {
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
          body: WebViewWidget(controller: controller),
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
