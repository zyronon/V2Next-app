import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/base_webview.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/pages/discover/tab_page.dart';
import 'package:v2ex/utils/const_val.dart';

class DiscoverController extends GetxController {

}

class DiscoverPage extends StatefulWidget {
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with AutomaticKeepAliveClientMixin {
  List<TabItem> tabMap = [
    new TabItem(cnName: '今日热议', enName: '', type: TabType.tab),
    new TabItem(cnName: '3天最热', enName: '3d', type: TabType.tab),
    new TabItem(cnName: '7天最热', enName: '7d', type: TabType.tab),
    new TabItem(cnName: '30天最热', enName: '30d', type: TabType.tab),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder(
        init: DiscoverController(),
        builder: (_) {
          return SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                TDSearchBar(
                  placeHolder: '搜索',
                  onSubmitted: (val) {
                    Get.toNamed('/search', arguments: val);
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
                                  tabs: tabMap.map((e) => Tab(text: e.cnName)).toList(),
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
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
