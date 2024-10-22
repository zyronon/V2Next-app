import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/tab_page/tab_hot_page.dart';
import 'package:v2ex/components/tab_page/tab_page.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/TabItem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  List<TabItem> tabMap = [
    new TabItem(cnName: '最热', enName: 'hot', type: TabType.hot),
    // new TabItem(cnName: '沙盒', enName: 'sandbox', type: TabType.node),
    new TabItem(cnName: '水深火热', enName: 'flamewar', type: TabType.node),
    new TabItem(cnName: '最新', enName: 'new', type: TabType.latest),
    new TabItem(cnName: '全部', enName: 'all', type: TabType.tab),
    new TabItem(cnName: '技术', enName: 'tech', type: TabType.tab),
    new TabItem(cnName: '创意', enName: 'creative', type: TabType.tab),
    new TabItem(cnName: '好玩', enName: 'play', type: TabType.tab),
    new TabItem(cnName: 'Apple', enName: 'apple', type: TabType.tab),
    new TabItem(cnName: '酷工作', enName: 'jobs', type: TabType.tab),
    new TabItem(cnName: '交易', enName: 'deals', type: TabType.tab),
    new TabItem(cnName: '城市', enName: 'city', type: TabType.tab),
    new TabItem(cnName: '问与答', enName: 'qna', type: TabType.tab),
    new TabItem(cnName: 'R2', enName: 'r2', type: TabType.tab),
    new TabItem(cnName: 'VXNA', enName: 'xna', type: TabType.tab),
    new TabItem(cnName: '节点', enName: 'nodes', type: TabType.tab),
    new TabItem(cnName: '关注', enName: 'members', type: TabType.tab),
  ];

  List<Widget> tabs = [];
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      tabs = tabMap.map((e) {
        return Tab(text: e.cnName);
      }).toList();
      pages = tabMap.map((e) {
        if (e.type == TabType.hot) return new TabHotPage(tab: e);
        return new TabPage(tab: e);
      }).toList();
    });
  }

  submit() {
    BaseController c = Get.find();
    c.initData();
    print("test");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
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
              Expanded(child: TabBarView(children: pages))
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //       submit();
        //     },
        //     child: Text('test')),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
