import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v2next/components/base_divider.dart';
import 'package:v2next/components/footer.dart';
import 'package:v2next/components/loading_list_page.dart';
import 'package:v2next/components/no_data.dart';
import 'package:v2next/pages/notifications/notice_item.dart';
import 'package:v2next/http/api.dart';
import 'package:v2next/model/model.dart';

import 'notifications.dart';

class ListPage extends StatefulWidget {
  NoticeType type;

  ListPage({required this.type});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  ScrollController ctrl = ScrollController();
  NotificationController c = Get.find();

  @override
  void initState() {
    super.initState();
    ctrl.addListener(scrollListener);
  }

  @override
  void dispose() {
    ctrl.removeListener(scrollListener);
    ctrl.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (ctrl.position.pixels == ctrl.position.maxScrollExtent) {
      c.loadMore();
    }
  }

  get list {
    return c.getList(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: c.loading
          ? LoadingListPage()
          : list.length == 0
              ? NoData(text: '没有数据')
              : ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: list.length,
                  controller: ctrl,
                  itemBuilder: (BuildContext context, int index) {
                    var v = list[index];
                    if (list.length - 1 == index) {
                      return Column(children: [
                        NoticeItem(
                            noticeItem: v,
                            onDeleteNotice: () async {
                              String noticeId = v.delIdOne;
                              String once = v.delIdTwo;
                              var item = await Api.onDelNotice(noticeId, once);
                              c.onDel(v, item);
                            }),
                        FooterTips(loading: c.isLoadingMore),
                      ]);
                    }
                    return NoticeItem(
                        noticeItem: v,
                        onDeleteNotice: () async {
                          String noticeId = v.delIdOne;
                          String once = v.delIdTwo;
                          var item = await Api.onDelNotice(noticeId, once);
                          c.onDel(v, item);
                        });
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return BaseDivider();
                  },
                ),
      onRefresh: c.onRefresh,
    );
  }
}
