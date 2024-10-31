import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/components/base_divider.dart';
import 'package:v2ex/components/footer.dart';
import 'package:v2ex/components/loading_list_page.dart';
import 'package:v2ex/components/not_allow.dart';
import 'package:v2ex/components/post_item.dart';
import 'package:v2ex/components/tab_child_node.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/api.dart';

class TabPageController extends GetxController {
  bool loading = true;
  bool needAuth = false;
  List<Post2> postList = [];
  final BaseController home = Get.find();
  TabItem tab;
  bool isLoadingMore = false;

  TabPageController({required this.tab});

  @override
  void onInit() async {
    super.onInit();
    getData(isRefresh: true);
  }

  getData({bool isRefresh = false}) async {
    print('getList:type:${tab.type},id:${tab.cnName}');
    if (isRefresh) {
      loading = true;
      update();
    }
    Result res = await Api.getDiscoverInfo(date: tab.enName);
    if (res.success) {
      if (isRefresh) postList = [];
      postList.addAll(res.data.cast<Post2>());
    }
    if (isRefresh) loading = false;
    update();
  }

  onRefresh() async {
    isLoadingMore = false;
    await getData(isRefresh: true);
  }

}

class TabPage extends StatefulWidget {
  final TabItem tab;

  const TabPage({super.key, required this.tab});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with AutomaticKeepAliveClientMixin {
  Future<void> onRefresh() async {
    final TabPageController c = Get.find(tag: widget.tab.enName);
    await c.onRefresh();
    return;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        child: GetBuilder<TabPageController>(
            init: TabPageController(tab: widget.tab),
            tag: widget.tab.cnName,
            builder: (_) {
              if (_.loading && _.postList.length == 0) return LoadingListPage();
              return ListView.separated(
                physics: new AlwaysScrollableScrollPhysics(),
                itemCount: _.postList.length,
                itemBuilder: (BuildContext context, int index) {
                  Post2 v = _.postList[index];
                  return InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: Const.padding, left: Const.padding, right: Const.padding, bottom: Const.padding),
                        child: Row(children: [
                          Expanded(child: Row(children: [
                            BaseAvatar(src: v.member.avatar, diameter: 30.w, radius: 6.r),
                            SizedBox(width: 10.w),
                            Expanded(child: Text(v.title)),
                          ],)),
                          SizedBox(width: 15),
                          Text(v.replyCount.toString(),style: TextStyle(color: Colors.grey,fontSize: 11)),
                        ]),
                      ),
                      onTap: () => Get.toNamed('/post-detail', arguments: v));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: Const.line, height: 1);
                },
              );
            }),
        onRefresh: onRefresh);
  }

  @override
  bool get wantKeepAlive => true;
}
