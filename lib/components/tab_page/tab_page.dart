import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/footer.dart';
import 'package:v2ex/components/loading_list_page.dart';
import 'package:v2ex/components/not_allow.dart';
import 'package:v2ex/components/post_item.dart';
import 'package:v2ex/components/tab_child_node.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/http/api.dart';

class TabPageController extends GetxController {
  bool loading = true;
  bool needAuth = false;
  List<Post2> postList = [];
  List<V2Node> nodeList = [];
  final BaseController home = Get.find();
  TabItem tab;
  int pageNo = 1;
  int totalPage = 5;
  bool isLoadingMore = false;

  TabPageController({required this.tab});

  @override
  void onInit() async {
    super.onInit();
    getData(isRefresh: true);
  }

  getData({bool isRefresh = false}) async {
    print('getList:type:${tab.type},id:${tab.enName}');
    if (isRefresh) {
      loading = true;
      update();
    }
    Result res = await Api.getPostListByTab(tab: tab, pageNo: pageNo);
    if (res.success) {
      if (isRefresh) postList = [];
      needAuth = false;
      postList.addAll(res.data['list'].cast<Post2>());
      nodeList = nodeList.isEmpty ? res.data['nodeList'] : nodeList;
      totalPage = res.data['totalPage'];
      print(nodeList);
    } else {
      needAuth = res.data == Auth.notAllow;
    }
    if (isRefresh) loading = false;
    update();
  }

  onRefresh() async {
    pageNo = 1;
    isLoadingMore = false;
    await getData(isRefresh: true);
  }

  loadMore() async {
    if (isLoadingMore) return;
    if (pageNo >= totalPage) return;
    print('加载更多:${tab.cnName}');
    pageNo++;
    isLoadingMore = true;
    update();
    await getData();
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
    final TabPageController c = Get.find(tag: widget.tab.enName);
    await c.onRefresh();
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
      TabPageController c = Get.find(tag: widget.tab.enName);
      c.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        child: GetBuilder<TabPageController>(
            init: TabPageController(tab: widget.tab),
            tag: widget.tab.enName,
            builder: (_) {
              if (_.loading && _.postList.length == 0) return LoadingListPage();
              if (_.needAuth)
                return NotAllow(cb: () {
                  if (BaseController.to.isLogin) {
                    onRefresh();
                  }
                });
              return ListView.builder(
                physics: new AlwaysScrollableScrollPhysics(),
                controller: ctrl,
                itemCount: _.postList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (_.postList.length - 1 == index) {
                    return Column(children: [
                      PostItem(item: _.postList[index], tab: widget.tab),
                      FooterTips(loading: _.isLoadingMore),
                      if (_.nodeList.isNotEmpty) TabChildNodes(list: _.nodeList)
                    ]);
                  }
                  return PostItem(item: _.postList[index], tab: widget.tab);
                },
              );
            }),
        onRefresh: onRefresh);
  }

  @override
  bool get wantKeepAlive => true;
}
