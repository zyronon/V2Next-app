import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/utils.dart';

class PostCollectPage extends StatefulWidget {
  const PostCollectPage({super.key});

  @override
  State<PostCollectPage> createState() => _PostCollectPageState();
}

class _PostCollectPageState extends State<PostCollectPage> {
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
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                    String url = 'https://www.v2ex.com/my/topics';
                    // Utils.syncCookies('https://www.v2ex.com/');
                    Utils.dioSyncCookie2InApp(url);
                    controller?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
                  },
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(resources: request.resources, action: PermissionResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading: (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;
                    print('issssssssssssssssssss：${uri}');
                    if (uri.toString().contains('v2ex.com/t/')) {
                      var match = RegExp(r'(\d+)').allMatches(uri.toString().replaceAll('v2ex.com/t/', ''));
                      var result = match.map((m) => m.group(0)).toList();
                      Get.toNamed('/post-detail', arguments: Post2(id: result[0]!));
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
