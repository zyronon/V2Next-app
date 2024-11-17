import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/no_data.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/pages/notifications/list_page.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/utils/event_bus.dart';

import '../../http/api.dart';
import '../../model/model.dart';

class NotificationController extends GetxController {
  MemberNoticeModel data = MemberNoticeModel();
  bool loading = false;
  int pageNo = 1;
  bool isLoadingMore = false;

  @override
  void onInit() {
    super.onInit();
    print('NotificationController init');
    getData(isRefresh: true);
  }

  List<MemberNoticeItem> getList(NoticeType noticeType) {
    if (noticeType == NoticeType.all) return data.list;
    return data.list.where((v) => v.noticeType == noticeType).toList();
  }

  getData({bool isRefresh = false}) async {
    if (isRefresh) {
      loading = true;
      update();
    }
    MemberNoticeModel res = await Api.getNotifications(pageNo: pageNo);
    if (isRefresh) data.list = [];
    if (pageNo == 1) {
      data = res;
    } else {
      data.list.addAll(res.list);
    }
    if (isRefresh) loading = false;
    update();
    EventBus().emit('setUnread', 0);
  }

  Future onRefresh() async {
    pageNo = 1;
    isLoadingMore = false;
    await getData(isRefresh: true);
  }

  loadMore() async {
    if (isLoadingMore) return;
    if (pageNo >= data.totalPage) return;
    pageNo++;
    isLoadingMore = true;
    update();
    await getData();
    isLoadingMore = false;
    update();
  }

  onDel(v, item) {
    data.list.remove(v);
    data.list.add(item);
    update();
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with AutomaticKeepAliveClientMixin {
  List<NodeItem> tabMap = [
    new NodeItem(title: '全部', name: 'all', type: TabType.tab),
    new NodeItem(title: '回复', name: 'hot', type: TabType.hot),
    new NodeItem(title: '感谢', name: 'sandbox', type: TabType.node),
    new NodeItem(title: '收藏', name: 'new', type: TabType.latest),
  ];

  BaseController bc = Get.find();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder(
        init: NotificationController(),
        builder: (_) {
          return DefaultTabController(
            length: tabMap.length,
            child: Container(
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(color: Colors.white),
                  ),
                  Positioned(
                      child: Padding(
                    padding: EdgeInsets.only(top: 40.w),
                    child: bc.isLogin
                        ? TabBarView(physics: NeverScrollableScrollPhysics(), children: [
                            ListPage(type: NoticeType.all),
                            ListPage(type: NoticeType.reply),
                            ListPage(type: NoticeType.thanks),
                            ListPage(type: NoticeType.favTopic),
                          ])
                        : NoData(text: '', cb: _.onRefresh),
                  )),
                  Container(
                      height: 40.w,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Const.line)),
                        color: Colors.white,
                      ),
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        labelStyle: TextStyle(fontSize: 15.sp),
                        unselectedLabelStyle: TextStyle(fontSize: 15.sp),
                        tabs: tabMap.map((e) {
                          return Tab(text: e.title);
                        }).toList(),
                      )),
                ],
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
