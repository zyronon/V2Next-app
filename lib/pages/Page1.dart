import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:v2ex/bus.dart';
import 'package:v2ex/components/TabBarViewPage.dart';
import 'package:v2ex/model/Post.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late final WebViewController controller;

  List<TabItem> tabMap = [
    new TabItem(title: '最热', node: 'hot', date: '', post: []),
    new TabItem(title: '最新', node: 'new', date: '', post: []),
    new TabItem(title: '全部', node: 'all', date: '', post: []),
    new TabItem(title: '技术', node: 'tech', date: '', post: []),
    new TabItem(title: '创意', node: 'creative', date: '', post: []),
    new TabItem(title: '好玩', node: 'play', date: '', post: []),
    new TabItem(title: 'Apple', node: 'apple', date: '', post: []),
    new TabItem(title: '酷工作', node: 'jobs', date: '', post: []),
    new TabItem(title: '交易', node: 'deals', date: '', post: []),
    new TabItem(title: '城市', node: 'city', date: '', post: []),
    new TabItem(title: '问与答', node: 'qna', date: '', post: []),
    new TabItem(title: 'R2', node: 'r2', date: '', post: []),
    new TabItem(title: '节点', node: 'nodes', date: '', post: []),
    new TabItem(title: '关注', node: 'members', date: '', post: []),
  ];

  List<Widget> tabs = [];
  List<Widget> pages = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      tabs = tabMap.map((e) {
        return Tab(text: e.title);
      }).toList();
      pages = tabMap.map((e) {
        return TabBarViewPage(node: e.node);
      }).toList();
    });
    // return;
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
              bus.emit("loaded");
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
      ..loadRequest(Uri.parse('https://v2ex.com/?tab=hot'))
      ..addJavaScriptChannel('Channel', onMessageReceived: (JavaScriptMessage message) {
        print('v2-channel' + message.message.length.toString());
        var temp = json.decode(message.message);
        bus.emit("onJsBridge", temp);
      });
    bus.on("getPost", (arg) {
      print('on-getPost' + arg);
      controller.runJavaScript('jsBridge("getPost",' + arg + ')');
    });
    bus.on("emitJsBridge", (arg) {
      print('emitJsBridge' + arg['func']);
      controller.runJavaScript('jsBridge(' + arg['func'] + ', ' + arg['val'] + ')');
      controller.runJavaScript('window.jsBridge(' + arg['func'] + ', ' + arg['val'] + ')');
    });
  }

  submit() {
    print("test");
    // controller.loadRequest(Uri.parse('https://www.v2ex.com'));
    // Navigator.pushNamed(context, 'Home');
  }

  getPost(post) {
    // print('object-getpost' + id.toString());
    Navigator.pushNamed(
      context,
      'Me',
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Me(post: post)),
    // );
    // controller.runJavaScript('jsBridge("getPost",' + id.toString() + ')');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        // indicatorPadding: EdgeInsets.only(bottom: 2),
                        // indicatorSize: TabBarIndicatorSize.tab,
                        tabs: tabs),
                    flex: 7,
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 6.w, right: 6.w),
                              child: Icon(
                                Icons.sort,
                                size: 22.sp,
                              )),
                          Padding(
                              padding: EdgeInsets.only(left: 6.w, right: 6.w),
                              child: Icon(
                                Icons.search,
                                size: 22.sp,
                              )),
                          Padding(
                              padding: EdgeInsets.only(left: 6.w, right: 6.w),
                              child: Icon(
                                Icons.mail_outline,
                                size: 22.sp,
                              )),
                        ],
                      ),
                    ),
                    flex: 3,
                  )
                ],
              ),
              Expanded(
                  child: TabBarView(
                children: pages,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
