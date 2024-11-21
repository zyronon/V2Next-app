import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2next/components/base_avatar.dart';
import 'package:v2next/components/loading_list_page.dart';
import 'package:v2next/http/api.dart';
import 'package:v2next/model/base_controller.dart';

import 'package:v2next/model/model.dart';
import 'package:v2next/utils/const_val.dart';

class TabPageController extends GetxController {
  bool loading = true;
  bool needAuth = false;
  List<Post> postList = [];
  final BaseController home = Get.find();
  NodeItem tab;
  bool isLoadingMore = false;

  TabPageController({required this.tab});

  @override
  void onInit() async {
    super.onInit();
    getData(isRefresh: true);
  }

  getData({bool isRefresh = false}) async {
    print('getList:type:${tab.type},id:${tab.title}');
    if (isRefresh) {
      loading = true;
      update();
    }
    Result res = await Api.getDiscoverInfo(date: tab.name);
    if (res.success) {
      if (isRefresh) postList = [];
      postList.addAll(res.data.cast<Post>());
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
  final NodeItem tab;

  const TabPage({super.key, required this.tab});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with AutomaticKeepAliveClientMixin {
  Future<void> onRefresh() async {
    final TabPageController c = Get.find(tag: widget.tab.name);
    await c.onRefresh();
    return;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        child: GetBuilder<TabPageController>(
            init: TabPageController(tab: widget.tab),
            tag: widget.tab.title,
            builder: (_) {
              if (_.loading && _.postList.length == 0) return LoadingListPage();
              return ListView.separated(
                physics: new AlwaysScrollableScrollPhysics(),
                itemCount: _.postList.length,
                itemBuilder: (BuildContext context, int index) {
                  Post v = _.postList[index];
                  return InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: Const.padding, left: Const.padding, right: Const.padding, bottom: Const.padding),
                        child: Row(children: [
                          Expanded(
                              child: Row(
                            children: [
                              BaseAvatar(user: v.member, diameter: 30.w, radius: 6.r),
                              SizedBox(width: 10.w),
                              Expanded(child: Text(v.title)),
                            ],
                          )),
                          SizedBox(width: 15),
                          Text(v.replyCount.toString(), style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ]),
                      ),
                      onTap: () => Get.toNamed('/post_detail', arguments: v));
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
