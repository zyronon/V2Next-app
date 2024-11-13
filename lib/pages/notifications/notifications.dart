import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/base_divider.dart';
import 'package:v2ex/components/loading_list_page.dart';
import 'package:v2ex/components/not_allow.dart';
import 'package:v2ex/components/notice_item.dart';
import 'package:v2ex/model/BaseController.dart';

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
    getData(isRefresh: true);
  }

  List<MemberNoticeItem> getList(NoticeType noticeType) {
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
    }else{
      data.list.addAll(res.list);
    }
    if (isRefresh) loading = false;
    update();
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
    return RefreshIndicator(
      child: list.length == 0
          ? LoadingListPage()
          : ListView.separated(
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
                      _.data.list.remove(v);
                      _.update();
                    });
              },
              separatorBuilder: (BuildContext context, int index) {
                return BaseDivider();
              },
            ),
      onRefresh: _.onRefresh,
    );
  }

  BaseController bc = Get.find();

  @override
  void initState() {
    super.initState();
  }

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
                            _buildPage(_.data.list),
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
