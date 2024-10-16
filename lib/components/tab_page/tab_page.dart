import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/footer.dart';
import 'package:v2ex/components/not-allow.dart';
import 'package:v2ex/components/post_item.dart';
import 'package:v2ex/components/post_loading_page.dart';
import 'package:v2ex/components/tab_page/tab_hot_page.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/utils/api.dart';

class TabPageController extends GetxController {
  bool loading = true;
  bool needAuth = false;
  List<Post2> postList = [];
  final BaseController home = Get.find();
  TabItem tab;
  int pageNo = 0;
  bool isLoadingMore = false;

  TabPageController({required this.tab});

  @override
  void onInit() async {
    super.onInit();
    getList(isRefresh: true);
  }

  getList({bool isRefresh = false}) async {
    print('getList:type:${tab.type},id:${tab.id}');
    if (isRefresh) {
      loading = true;
      update();
    }
    update();
    Result res = await Api.getPostListByTab(tab: tab, pageNo: pageNo);
    if (res.success) {
      if (isRefresh) postList = [];
      needAuth = false;
      postList.addAll(res.data.cast<Post2>());
    } else {
      needAuth = res.data == Auth.notAllow;
    }
    if (isRefresh) loading = false;
    update();
  }

  onRefresh() {
    pageNo = 0;
    isLoadingMore = false;
    getList(isRefresh: true);
  }

  loadMore() async {
    if (isLoadingMore) return;
    pageNo++;
    print('加载更多${tab.title}');
    isLoadingMore = true;
    update();
    await getList();
    isLoadingMore = false;
    update();
  }
}

class TabPage extends StatefulWidget {
  final TabItem tab;

  const TabPage({super.key, required this.tab});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with AutomaticKeepAliveClientMixin {
  final ScrollController ctrl = ScrollController();

  Future<void> onRefresh() async {
    final TabPageController c = Get.find(tag: widget.tab.id);
    c.getList(isRefresh: true);
    return;
  }

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
      final TabPageController c = Get.find(tag: widget.tab.id);
      c.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        child: GetBuilder<TabPageController>(
            init: TabPageController(tab: widget.tab),
            tag: widget.tab.id,
            builder: (_) {
              if (_.loading) return PostLoadingPage();
              if (_.needAuth) return NotAllow();
              return ListView.separated(
                controller: ctrl,
                itemCount: _.postList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (_.postList.length - 1 == index) {
                    return Column(children: [
                      PostItem(item: _.postList[index], tab: widget.tab),
                      FooterTips(loading: _.isLoadingMore),
                    ]);
                  }
                  return PostItem(item: _.postList[index], tab: widget.tab);
                },
                //分割器构造器
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 6,
                    color: Color(0xfff1f1f1),
                  );
                },
              );
            }),
        onRefresh: onRefresh);
  }

  @override
  bool get wantKeepAlive => true;
}
