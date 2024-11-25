import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:v2next/utils/utils.dart';

class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({super.key});

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {
  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    // userAgent: 'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.114 Mobile Safari/537.36',
    userAgent: 'Mozilla/5.0 (Linux; Android 14; 2407FRK8EC Build/UP1A.231005.007) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.6668.81 Mobile Safari/537.36',
  );
  PullToRefreshController? pullToRefreshController;

  String aUrl = "";
  double progress = 0;
  var cookieManager = CookieManager.instance();

  @override
  void initState() {
    super.initState();
    aUrl = Get.arguments['aUrl']!;
    print('aUrl:$aUrl');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '登录 - Google账号',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: IconButton(onPressed: closePage, icon: const Icon(Icons.close)),
        actions: [
          IconButton(onPressed: reFresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  InAppWebView(
                    initialSettings: settings,
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) async {
                      webViewController = controller;
                      await Utils.dioSyncCookie2InApp(aUrl);
                      controller.loadUrl(
                        urlRequest: URLRequest(
                          url: WebUri(aUrl),
                          headers: {
                            'refer': 'https://www.v2ex.com//signin?next=/mission/daily',
                          },
                        ),
                      );
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController?.endRefreshing();
                      print('----👋🌲');
                      // google登录完成
                      // ignore: unrelated_type_equality_checks
                      String strUrl = url.toString();
                      if (strUrl == 'https://www.v2ex.com/#' ||
                          // ignore: unrelated_type_equality_checks
                          strUrl == 'https://www.v2ex.com/' ||
                          strUrl == 'https://www.v2ex.com/2fa#' ||
                          strUrl == 'https://www.v2ex.com/2fa') {
                        // 使用cookieJar保存cookie
                        List<Cookie> cookies = await cookieManager.getCookies(url: url!);
                        await Utils.inAppSyncCookie2Dio(cookies, strUrl);
                        if (strUrl.contains('/2fa')) {
                          SmartDialog.show(
                            useSystem: true,
                            animationType: SmartAnimationType.centerFade_otherSlide,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('系统提示'),
                                content: const Text('已登录，是否继续当前账号的2FA认证 ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('取消'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Get.back(result: {'signInGoogle': 'success'});
                                    },
                                    child: const Text('继续'),
                                  )
                                ],
                              );
                            },
                          );
                        } else {
                          Get.back(result: {'signInGoogle': 'success'});
                        }
                      }
                    },
                    onProgressChanged: (controller, progress) async {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                    onCloseWindow: (controller) {},
                  ),
                  progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void reFresh() async {
    webViewController?.reload();
  }

  void closePage() async {
    Get.back(result: {'signInGoogle': 'cancel'});
  }
}
