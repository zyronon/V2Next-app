import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/base_divider.dart';
import 'package:v2ex/components/loading_list_page.dart';
import 'package:v2ex/components/not_allow.dart';
import 'package:v2ex/components/notice_item.dart';
import 'package:v2ex/model/BaseController.dart';

import '../http/api.dart';
import '../model/model.dart';

class NotificationController extends GetxController {
  MemberNoticeModel data = MemberNoticeModel();
  bool loading = false;
  int pageNo = 1;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  List<MemberNoticeItem> getList(NoticeType noticeType) {
    return data.noticeList.where((v) => v.noticeType == noticeType).toList();
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
  List<NodeItem> tabMap = [
    new NodeItem(title: '全部', name: 'all', type: TabType.tab),
    new NodeItem(title: '回复', name: 'hot', type: TabType.hot),
    new NodeItem(title: '感谢', name: 'sandbox', type: TabType.node),
    new NodeItem(title: '收藏', name: 'new', type: TabType.latest),
  ];

  Widget _buildPage(List<MemberNoticeItem> list) {
    NotificationController _ = Get.find();
    return list.length == 0
        ? LoadingListPage()
        : RefreshIndicator(
            child: ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                var v = list[index];
                return NoticeItem(
                    noticeItem: v,
                    onDeleteNotice: () async {
                      String noticeId = v.delIdOne;
                      String once = v.delIdTwo;
                      await Api.onDelNotice(noticeId, once);
                      _.data.noticeList.remove(v);
                      _.update();
                    });
              },
              separatorBuilder: (BuildContext context, int index) {
                return BaseDivider();
              },
            ),
            onRefresh: _.getData,
          );
  }

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
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  TabBar(
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    labelStyle: TextStyle(fontSize: 15.sp),
                    unselectedLabelStyle: TextStyle(fontSize: 15.sp),
                    tabs: tabMap.map((e) {
                      return Tab(text: e.title);
                    }).toList(),
                  ),
                  Expanded(
                    child: bc.isLogin
                        ? TabBarView(physics: NeverScrollableScrollPhysics(), children: [
                            _buildPage(_.data.noticeList),
                            _buildPage(_.getList(NoticeType.reply)),
                            _buildPage(_.getList(NoticeType.thanks)),
                            _buildPage(_.getList(NoticeType.favTopic)),
                          ])
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
