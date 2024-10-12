import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/TabBarViewPage.dart';
import 'package:v2ex/main.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/LoginForm.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  List<TabItem> tabMap = [
    new TabItem(title: '最热', id: 'hot', type: TabType.tab, date: '', post: []),
    new TabItem(title: '沙盒', id: 'sandbox', type: TabType.node, date: '', post: []),
    new TabItem(title: '最新', id: 'new', type: TabType.tab, date: '', post: []),
    new TabItem(title: '全部', id: 'all', type: TabType.tab, date: '', post: []),
    new TabItem(title: '技术', id: 'tech', type: TabType.tab, date: '', post: []),
    new TabItem(title: '创意', id: 'creative', type: TabType.tab, date: '', post: []),
    new TabItem(title: '好玩', id: 'play', type: TabType.tab, date: '', post: []),
    new TabItem(title: 'Apple', id: 'apple', type: TabType.tab, date: '', post: []),
    new TabItem(title: '酷工作', id: 'jobs', type: TabType.tab, date: '', post: []),
    new TabItem(title: '交易', id: 'deals', type: TabType.tab, date: '', post: []),
    new TabItem(title: '城市', id: 'city', type: TabType.tab, date: '', post: []),
    new TabItem(title: '问与答', id: 'qna', type: TabType.tab, date: '', post: []),
    new TabItem(title: 'R2', id: 'r2', type: TabType.tab, date: '', post: []),
    new TabItem(title: '节点', id: 'nodes', type: TabType.tab, date: '', post: []),
    new TabItem(title: '关注', id: 'members', type: TabType.tab, date: '', post: []),
  ];

  List<Widget> tabs = [];
  List<Widget> pages = [];

  final String url = "https://v2ex.com/?tab=hot";

  @override
  void initState() {
    super.initState();
    setState(() {
      tabs = tabMap.map((e) {
        return Tab(text: e.title);
      }).toList();
      pages = tabMap.map((e) {
        return new TabBarViewPage(tab: e);
      }).toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  submit() {
    BaseController c = Get.find();
    // IndexController c = Get.find();
    // c.textScaleFactor+=0.1;
    // c.update();
    // var s = UserConfig();
    // s.showTopReply = false;
    // c.setConfig(s);
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
