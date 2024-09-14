import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Me extends StatefulWidget {
  const Me({super.key});

  @override
  State<Me> createState() => MeState();
}

class MeState extends State<Me> {
  late final WebViewController controller;

  String html = """
 
  
  """;

  int _selectedIndex = 1;
  double stateHeight = 0;

  @override
  void initState() {
    stateHeight = MediaQueryData.fromWindow(window).padding.top;

    super.initState();
    return;
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
      ..addJavaScriptChannel('Channel',
          onMessageReceived: (JavaScriptMessage message) {
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
                                if (index == 0) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            maxRadius: 14.w,
                                            backgroundImage: NetworkImage(
                                                "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4"),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              'zyronon',
                                              style: TextStyle(
                                                  fontSize: 14.sp, height: 1.2),
                                            ),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        verticalDirection:
                                            VerticalDirection.down,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 6,
                                        ),
                                        child: Text(
                                          '带一岁 5 个月的小男孩在小区楼下学走路，被一个 45 多岁的陌生女人亲嘴了',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      HtmlWidget(
                                        // the first parameter (`html`) is required
                                        '''
<div data-v-f8165980="" data-v-546d3b11="" class="html-wrapper"><div data-v-f8165980="" class=""><div data-v-f8165980="">

<div class="cell">
<div class="topic_content"><div class="markdown_body"><p>事情是这样的，小区楼下有一个新疆羊肉串烧烤店，拉着小孩路过店门口的时候，小孩远远的就被店门口的霓虹灯吸引了在哪儿手舞足蹈，店门口一个四五十岁左右的新疆女人看见了上下摇着脑头笑着逗他，当我们走到店门口的时候她突然跑过来亲了一下小孩的嘴，然后又亲了一下脸，我都没反应过来连忙说了一声哎哎，然后她说了一句他在学走路呀，我说嗯，就又拉着小孩走了。</p>
<p>事后我给媳妇说了，很生气的说我们都没亲过嘴呢，我们又不认识他。我解释说到人家是喜欢你小孩，用亲吻表达出来而已，人家那边就这样吧，没有恶意，前段时间我还看见过她们店里其他女人把食物嚼碎了喂小孩的。</p>
<p>我也寻思着这是善意的还是恶意的，想问问 V 友们</p>
</div></div>
</div>
<div class="subtle">
<span class="fade">第 1 条附言 &nbsp;·&nbsp; 6 小时 51 分钟前</span>
<div class="sep"></div>
<div class="topic_content">看了回复很多挺吓人的，这个女的是烧烤店里面的一个店员，里面全是新疆人。我觉得吧恶意成分应该不大，可能他们不知道很多人会介意这样，我现在后悔的就是当时没有找她理论，表示不满。<br><br>现在事后去找她理论吗，真的有必要去医院检查吗，还有就是才一个晚上能检测出问题吗</div>
</div>
<div class="subtle">
<span class="fade">第 2 条附言 &nbsp;·&nbsp; 1 小时 58 分钟前</span>
<div class="sep"></div>
<div class="topic_content">当时没和她理论，过后去理论能说清楚吗</div>
</div>

</div></div><!----></div>
  ''',
                                        renderMode: RenderMode.column,
                                        textStyle: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            children: [
                                              CircleAvatar(
                                                maxRadius: 14.w,
                                                backgroundImage: NetworkImage(
                                                    "https://avatars2.githubusercontent.com/u/20411648?s=460&v=4"),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      'zyronon',
                                                      style: TextStyle(
                                                          fontSize: 14.sp,
                                                          height: 1.2),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          '1楼',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              height: 1.2),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          '1小时30分钟前',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              height: 1.2),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            verticalDirection:
                                                VerticalDirection.down),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: 10,
                                          ),
                                          child: Text(
                                            '为什么很多人都用《》表示引用，而不用 “” 或「」',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Row(
                                            children: [
                                              DecoratedBox(
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0), //3像素圆角
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 6.0,
                                                      vertical: 2.0),
                                                  child: Text(
                                                    "123",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                          ),
                                        )
                                      ]),
                                );
                              },
                              //分割器构造器
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Container(
                                  height: 1,
                                  color: Color(0xfff1f1f1),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
        onWillPop: () async {
          print("返回键点击了");
          Navigator.pop(context);
          // var isFinish = await controller.canGoBack().then((value) {
          //   if (value) {
          //     controller.goBack();
          //   }
          //   return !value;
          // });
          // return isFinish;
          return false;
        });
  }
}
