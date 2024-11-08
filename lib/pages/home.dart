import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/tab_page/tab_hot_page.dart';
import 'package:v2ex/components/tab_page/tab_page.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/http/request.dart';
import 'package:v2ex/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  BaseController bc = BaseController.to;

  List<Widget> tabs = [];
  List<Widget> pages = [];
  var tabKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    setState(() {
      tabs = bc.tabList.map((e) {
        return Tab(text: e.cnName);
      }).toList();
      pages = bc.tabList.map((e) {
        if (e.type == TabType.hot) return new TabHotPage(tab: e);
        return new TabPage(tab: e);
      }).toList();
    });
  }

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );

  submit() async {
    BaseController c = Get.find();
    // c.initStorage();
    // Api.pullOnce();
    // c.initStorage();
    // Http().setCookie();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      key: tabKey,
      length: tabs.length,
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TabBar(
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      labelStyle: TextStyle(fontSize: 15.sp),
                      unselectedLabelStyle: TextStyle(fontSize: 15.sp),
                      tabs: tabs,
                    ),
                    flex: 7,
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Icon(
                                  Icons.sort,
                                  size: 22.sp,
                                )),
                            onTap: () async {
                              await Get.toNamed('/edit_tab');
                              setState(() {
                                tabs = bc.tabList.map((e) {
                                  return Tab(text: e.cnName);
                                }).toList();
                                pages = bc.tabList.map((e) {
                                  if (e.type == TabType.hot) return new TabHotPage(tab: e);
                                  return new TabPage(tab: e);
                                }).toList();
                                tabKey = UniqueKey();
                              });
                            },
                          ),
                          InkWell(
                            child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Icon(
                                  Icons.search,
                                  size: 22.sp,
                                )),
                            onTap: () => Get.toNamed('/search'),
                          ),
                        ],
                      ),
                    ),
                    flex: 3,
                  )
                ],
              ),
              Expanded(child: TabBarView(children: pages))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              submit();
            },
            child: Text('test')),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
