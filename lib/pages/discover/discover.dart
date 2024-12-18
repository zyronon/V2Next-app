import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2next/components/base_webview.dart';
import 'package:v2next/model/model.dart';

import 'package:v2next/pages/discover/tab_page.dart';
import 'package:v2next/utils/const_val.dart';

class DiscoverController extends GetxController {}

class DiscoverPage extends StatefulWidget {
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with AutomaticKeepAliveClientMixin {
  List<NodeItem> tabMap = [
    new NodeItem(title: '今日热议', name: '', type: TabType.tab),
    new NodeItem(title: '3天最热', name: '3d', type: TabType.tab),
    new NodeItem(title: '7天最热', name: '7d', type: TabType.tab),
    new NodeItem(title: '30天最热', name: '30d', type: TabType.tab),
  ];
  late TextEditingController editingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder(
        init: DiscoverController(),
        builder: (_) {
          return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Container(color: Const.bg,child: Column(
              children: [
                TDSearchBar(
                  controller: editingController,
                  placeHolder: '搜索',
                  onSubmitted: (val) {
                    Get.toNamed('/search', arguments: val);
                    Future.delayed(Duration(seconds: 1),(){
                      editingController.text = '';
                    });
                  },
                ),
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 14.w, right: 14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.w),
                          InkWell(
                            child: Container(
                              padding: Const.paddingWidget,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: Const.borderRadiusWidget),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child: Icon(Icons.rss_feed, color: Colors.white, size: 30.w),
                                        padding: EdgeInsets.all(6.w),
                                        decoration: BoxDecoration(color: Color(0xffe27938), borderRadius: BorderRadius.circular(100.r)),
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('VXNA', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(
                                            'V2EX博客聚合器',
                                            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                                ],
                              ),
                            ),
                            onTap: () {
                              // Get.toNamed('/node_group');
                              // return;
                              Get.to(BaseWebView(url: 'https://www.v2ex.com/xna'), transition: Transition.cupertino);
                            },
                          ),
                          SizedBox(height: 10.w),
                          Expanded(
                            child: DefaultTabController(
                              length: tabMap.length,
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: Const.borderRadiusWidget),
                                child: Column(
                                  children: [
                                    TabBar(
                                      labelPadding: EdgeInsets.zero,
                                      labelStyle: TextStyle(fontSize: 15.sp),
                                      unselectedLabelStyle: TextStyle(fontSize: 15.sp),
                                      tabs: tabMap.map((e) => Tab(text: e.title)).toList(),
                                    ),
                                    Expanded(child: TabBarView(children: tabMap.map((e) => TabPage(tab: e)).toList())),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(height: 10)
              ],
            )),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
