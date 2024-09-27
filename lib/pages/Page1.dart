import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v2ex/components/TabBarViewPage.dart';
import 'package:v2ex/model/Controller.dart';
import 'package:v2ex/model/LoginForm.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/utils/index.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1>  with AutomaticKeepAliveClientMixin{
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

  final Controller c = Get.put(Controller());
  final String url = "https://v2ex.com/?tab=hot";

  HeadlessInAppWebView? headlessWebView;
  // String url = "www.v2ex.com/signin";

  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    setState(() {
      tabs = tabMap.map((e) {
        return Tab(text: e.title);
      }).toList();
      pages = tabMap.map((e) {
        return new TabBarViewPage(node: e.node);
      }).toList();
    });

    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      onWebViewCreated: (_controller){
        c.wc = webViewController = _controller;
      },
      onLoadStop: (controller, url) async {
        controller.injectJavascriptFileFromAsset(assetFilePath: "assets/index.js").then((_){
          c.loaded.value = true;
        });
      },
    );
    // headlessWebView?.run();
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
  }

  modalWrap(Widget text, Widget other) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  margin: EdgeInsets.only(bottom: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  constraints: BoxConstraints(maxHeight: .5.sh),
                  padding: EdgeInsets.all(14.w),
                  width: ScreenUtil().screenWidth * .91,
                  child: SingleChildScrollView(child: text)),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  ),
                ),
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 0.w),
                width: double.infinity,
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.w,
                        margin: EdgeInsets.only(bottom: 10.w, top: 15.w),
                        decoration: BoxDecoration(color: Color(0xffcacaca), borderRadius: BorderRadius.all(Radius.circular(2.r))),
                      ),
                    ),
                    other
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TextEditingController _codeController = new TextEditingController();
  final loginForm = LoginForm().obs;

  input() {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    InAppWebViewController.clearAllCache();
                    await headlessWebView?.dispose();
                    await headlessWebView?.run();
                    // await headlessWebView?.webViewController?.clearCache();
                    // await headlessWebView?.webViewController?.reload();
                  },
                  child: const Text("无头刷新")),
              ElevatedButton(
                  onPressed: () {
                    showLoginModal22();
                  },
                  child: const Text('无关登录')),
            ],
          ),
          Container(
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: "账号",
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none,
              ),
            ),
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            decoration: BoxDecoration(color: Color(0xfff1f1f1), borderRadius: BorderRadius.circular(6.r)),
            margin: EdgeInsets.only(bottom: 10.w),
          ),
          Container(
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: "账号",
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none,
              ),
            ),
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            decoration: BoxDecoration(color: Color(0xfff1f1f1), borderRadius: BorderRadius.circular(6.r)),
            margin: EdgeInsets.only(bottom: 10.w),
          ),
          Container(
            child: TextField(
              controller: _codeController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: "验证码",
                hintStyle: TextStyle(color: Colors.black26),
                border: InputBorder.none,
              ),
            ),
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            decoration: BoxDecoration(color: Color(0xfff1f1f1), borderRadius: BorderRadius.circular(6.r)),
            margin: EdgeInsets.only(bottom: 10.w),
          ),
          Obx(() {
            if (loginForm().img != null) {
              return InkWell(
                // child: Obx(() => Image.network('https://www.v2ex.com/${loginForm().img}', height: 50.w, fit: BoxFit.cover)),
                child: Obx(() => Image.memory(base64.decode(loginForm().img!), height: 50.w, fit: BoxFit.cover)),
                onTap: () {
                  loginForm.update((val) {
                    val?.img = '_captcha?once=${loginForm().once}&now=${new DateTime.now().millisecondsSinceEpoch}';
                  });
                },
              );
            }
            return Text('data');
          }),
          ElevatedButton(
            child: Text("登录"),
            onPressed: () async {
              print(_codeController.text);
              loginForm.update((val) => val?.code = _codeController.text);
              var result5 = await headlessWebView?.webViewController?.callAsyncJavaScript(functionBody: "return window.jsFunc.login(JSON.parse('${loginForm().toString()}'))");
              print(result5);
            },
          )
        ],
      ),
    );
  }

  submit() {
    headlessWebView?.dispose();
    headlessWebView?.run();
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
    ;
    // Navigator.push(
    //   contex,,
    //   MaterialPageRoute(builder: (context) => Me(post: post)),
    // );
    // controller.runJavaScript('jsBridge("getPost",' + id.toString() + ')');
  }

  showLoginModal22() async {
    var result5 = await headlessWebView?.webViewController?.callAsyncJavaScript(functionBody: 'return window.jsFunc.getLoginPageInfo()');
    print(result5);
    var res = (result5?.value);
    if (!res['error']) {
      loginForm(LoginForm.fromJson(res['data']));
      print(loginForm.value.codeKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              submit();
            },
            child: Text('刷新')),
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        // labelStyle: TextStyle(fontSize: 15.sp),
                        unselectedLabelStyle: TextStyle(fontSize: 15.sp),
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

  @override
  bool get wantKeepAlive => true;
}
