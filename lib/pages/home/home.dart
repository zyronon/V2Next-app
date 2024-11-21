import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2next/model/base_controller.dart';
import 'package:v2next/model/model.dart';

import 'package:v2next/pages/home/components/tab_hot_page.dart';
import 'package:v2next/pages/home/components/tab_page.dart';
import 'package:v2next/utils/const_val.dart';
import 'package:v2next/utils/event_bus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  BaseController bc = BaseController.to;
  late TabController _tabController;

  List<Widget> tabs = [];
  List<Widget> pages = [];
  var tabKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    init();
    EventBus().on('refreshHomeTab', (_) {
      init();
      setState(() {
        tabKey = UniqueKey();
      });
    });
  }

  init() {
    _tabController = TabController(length: bc.tabList.length, vsync: this);

    setState(() {
      tabs = bc.tabList.map((e) {
        return Tab(text: e.title);
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
    // var allItems = await bc.database.select(bc.database.dbReply).get();
    // print('items in database: ${allItems.length}');
    BaseController c = Get.find();
    // Api.pullOnce();
    c.initStorage();
    // c.initData();
    // Http().setCookie();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: tabKey,
      body: Container(
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Const.line)),
                ),
                child: Row(
                  children: [
                    Expanded(
                        flex: 7,
                        child: TabBar(
                          controller: _tabController,
                          tabAlignment: TabAlignment.start,
                          labelPadding: EdgeInsets.symmetric(horizontal: 12.w),
                          isScrollable: true,
                          labelStyle: TextStyle(fontSize: 15.sp),
                          unselectedLabelStyle: TextStyle(fontSize: 15.sp),
                          tabs: tabs,
                        )),
                    Expanded(
                      flex: 3,
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
                              onTap: () {
                                Get.toNamed('/edit_tab');
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
                    )
                  ],
                )),
            Expanded(child: TabBarView(
                controller: _tabController,
                children: pages))
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       submit();
      //     },
      //     child: Text('test')),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
