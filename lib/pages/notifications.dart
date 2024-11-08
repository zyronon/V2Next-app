import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/not_allow.dart';
import 'package:v2ex/components/notice_item.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/TabItem.dart';

import '../model/Post2.dart';
import '../http/api.dart';

class NotificationController extends GetxController {
  MemberNoticeModel data = MemberNoticeModel();
  bool loading = false;
  int pageNo = 1;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    loading = true;
    update();
    var res = await Api.getNotifications(pageNo: pageNo);
    if (pageNo == 1) {
      data = res;
    } else {
      data.noticeList.addAll(res.noticeList);
    }
    loading = false;
    update();
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with AutomaticKeepAliveClientMixin {
  List<TabItem> tabMap = [
    new TabItem(cnName: '全部', enName: 'all', type: TabType.tab),
    new TabItem(cnName: '回复', enName: 'hot', type: TabType.hot),
    new TabItem(cnName: '感谢', enName: 'sandbox', type: TabType.node),
    new TabItem(cnName: '收藏', enName: 'new', type: TabType.latest),
  ];

  BaseController bc = Get.find();

  @override
  void initState() {
    super.initState();
  }

  Future<void> onRefresh() async {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder(
        init: NotificationController(),
        builder: (_) {
          return DefaultTabController(
            length: tabMap.length,
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    labelStyle: TextStyle(fontSize: 15.sp),
                    unselectedLabelStyle: TextStyle(fontSize: 15.sp),
                    tabs: tabMap.map((e) {
                      return Tab(text: e.cnName);
                    }).toList(),
                  ),
                  Expanded(
                    child: bc.isLogin
                        ? TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: tabMap.map((e) {
                              return RefreshIndicator(
                                child: ListView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  children: [
                                    ..._.data.noticeList.map((v) {
                                      return NoticeItem(noticeItem: v, onDeleteNotice: () => {});
                                    })
                                  ],
                                ),
                                onRefresh: _.getData,
                              );
                            }).toList())
                        : NotAllow(),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
