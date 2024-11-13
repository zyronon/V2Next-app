import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/base_divider.dart';
import 'package:v2ex/components/loading_list_page.dart';
import 'package:v2ex/components/notice_item.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/model/model.dart';

class NotificationController extends GetxController {
  final ScrollController ctrl = ScrollController();

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
    } else {
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

class ListPage extends StatelessWidget {
  List list = [];
  Function onDel;

  ListPage({required this.list, required this.onDel});

  @override
  Widget build(BuildContext context) {
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
                      onDel.call();
                      // _.data.list.remove(v);
                      // _.update();
                    });
              },
              separatorBuilder: (BuildContext context, int index) {
                return BaseDivider();
              },
            ),
      onRefresh: _.onRefresh,
    );
  }
}
