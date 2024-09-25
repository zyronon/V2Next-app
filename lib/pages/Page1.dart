import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  HeadlessInAppWebView? headlessWebView;
  String url = "www.v2ex.com/?tab=hot";

  @override
  void initState() {
    super.initState();

    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(isInspectable: kDebugMode),
      onWebViewCreated: (controller) {
        const snackBar = SnackBar(
          content: Text('HeadlessInAppWebView created!'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onConsoleMessage: (controller, consoleMessage) {
        final snackBar = SnackBar(
          content: Text('Console Message: ${consoleMessage.message}'),
          duration: const Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      onLoadStart: (controller, url) async {
        final snackBar = SnackBar(
          content: Text('onLoadStart $url'),
          duration: const Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          this.url = url?.toString() ?? '';
        });
      },
      onLoadStop: (controller, url) async {
        final snackBar = SnackBar(
          content: Text('onLoadStop $url'),
          duration: const Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        controller.injectJavascriptFileFromAsset(assetFilePath: "assets/index.js");

        setState(() {
          this.url = url?.toString() ?? '';
        });
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
    var r =  await headlessWebView?.webViewController?.callAsyncJavaScript(
       functionBody: 'return window.jsBridge("${arg['func']}","${arg['val']}")',
       arguments:arg,
     );
    print(r);

    var result5 = await headlessWebView?.webViewController?.callAsyncJavaScript(functionBody: 'return testAsync()');
    print(result5); // {value: 49, error: null}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          "HeadlessInAppWebView Example",
        )),
        body: SafeArea(
            child: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Text("URL: ${(url.length > 50) ? "${url.substring(0, 50)}..." : url}"),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  await headlessWebView?.dispose();
                  await headlessWebView?.run();
                },
                child: const Text("Run HeadlessInAppWebView")),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  if (headlessWebView?.isRunning() ?? false) {
                    test();
                  } else {
                    const snackBar = SnackBar(
                      content: Text('HeadlessInAppWebView is not running. Click on "Run HeadlessInAppWebView"!'),
                      duration: Duration(milliseconds: 1500),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text("Send console.log message")),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  headlessWebView?.dispose();
                  setState(() {
                    url = '';
                  });
                },
                child: const Text("Dispose HeadlessInAppWebView")),
          )
        ])));
  }
}
