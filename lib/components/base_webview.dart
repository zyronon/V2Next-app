import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/utils/utils.dart';

class BaseWebView extends StatefulWidget {
  late String url;

  BaseWebView({required this.url});

  @override
  State<BaseWebView> createState() => _BaseWebViewState();
}

class _BaseWebViewState extends State<BaseWebView> {
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );

  PullToRefreshController? pullToRefreshController;
  double progress = 1;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController?.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          TDNavBar(
            height: 48,
            screenAdaptation: false,
            useDefaultBack: true,
          ),
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  initialSettings: settings,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) async {
                    await Utils.dioSyncCookie2InApp(widget.url);
                    webViewController = controller;
                    controller.loadUrl(urlRequest: URLRequest(url: WebUri(widget.url)));
                  },
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(resources: request.resources, action: PermissionResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;
                    print('在 webview 中点击的url：${uri}');
                    if (uri.toString().contains('v2ex.com/t/')) {
                      var match = RegExp(r'(\d+)').allMatches(uri.toString().replaceAll('v2ex.com/t/', ''));
                      var result = match.map((m) => m.group(0)).toList();
                      Get.toNamed('/post_detail', arguments: Post(postId: int.parse(result[0]!)));
                      return NavigationActionPolicy.CANCEL;
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController?.endRefreshing();
                  },
                  onReceivedError: (controller, request, error) {
                    pullToRefreshController?.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController?.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
                progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
              ],
            ),
          ),
        ])));
  }
}
