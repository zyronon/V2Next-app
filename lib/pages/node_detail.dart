import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/base_avatar.dart';
import 'package:v2ex/components/footer.dart';
import 'package:v2ex/components/loading_list_page.dart';
import 'package:v2ex/components/not_allow.dart';
import 'package:v2ex/components/post_item.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/model/BaseController.dart';

import 'package:v2ex/model/model.dart';
import 'package:v2ex/utils/utils.dart';

class NodeController extends GetxController {
  int pageNo = 1;
  bool needAuth = false;
  bool loading = false;
  bool isLoadMore = false;
  NodeItem data = NodeItem();
  ScrollController ctrl = ScrollController();
  List<Post> postList = [];

  @override
  void onInit() {
    super.onInit();
    ctrl.addListener(scrollListener);
    V2Node node = Get.arguments;
    data.name = node.name;
    data.title = node.title;
    update();
    getData(isRefresh: true);
  }

  @override
  void onClose() {
    super.onClose();
    ctrl.removeListener(scrollListener);
    ctrl.dispose();
  }

  void scrollListener() {
    if (ctrl.position.pixels == ctrl.position.maxScrollExtent) {
      loadMore();
    }
  }

  getData({bool isRefresh = false}) async {
    if (isRefresh) {
      loading = true;
      update();
    }
    NodeItem? res = await Api.getNodePageInfo(name: data.name, pageNo: pageNo);
    if (res != null) {
      if (isRefresh) postList = [];
      if (data.avatar.isEmpty) {
        data = res;
        postList = res.postList;
      } else {
        postList.addAll(res.postList);
      }
    } else {
      needAuth = true;
    }
    if (isRefresh) loading = false;
    update();
  }

  Future<void> onRefresh() async {
    pageNo = 1;
    isLoadMore = false;
    await getData(isRefresh: true);
  }

  loadMore() async {
    if (isLoadMore) return;
    if (data.totalPage <= pageNo) return;
    isLoadMore = true;
    pageNo++;
    update();
    await getData();
    isLoadMore = false;
    update();
  }

  Future favNode() async {
    SmartDialog.showLoading();
    bool res = await Api.onFavNode(data.id, data.isFavorite);
    SmartDialog.dismiss();
    if (res) {
      Utils.toast(msg: data.isFavorite ? '取消收藏成功' : '收藏成功');
      data.isFavorite = !data.isFavorite;
      update();
    } else {
      Utils.toast(msg: '收藏失败');
    }
  }
}

class NodeDetailPage extends StatelessWidget {
  NodeDetailPage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: NodeController(),
        builder: (_) {
          return Scaffold(
              body: RefreshIndicator(
                  child: CustomScrollView(
                    controller: _.ctrl,
                    slivers: [
                      SliverAppBar(
                        // automaticallyImplyLeading: Breakpoints.mediumAndUp.isActive(context) ? false : true,
                        backgroundColor: Get.isDarkMode ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.primary,
                        iconTheme: IconThemeData(color: Get.isDarkMode ? Colors.white : Theme.of(context).colorScheme.onPrimary),
                        pinned: true,
                        title: Row(
                          children: [
                            BaseAvatar(src: _.data.avatar, diameter: 35, radius: 0),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_.data.title,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Get.isDarkMode ? Colors.white : Theme.of(context).colorScheme.onPrimary)),
                                Text(
                                  '   ${_.data.topics} 主题  ${_.data.stars} 收藏',
                                  style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Get.isDarkMode ? Colors.white : Theme.of(context).colorScheme.onPrimary),
                                )
                              ],
                            ),
                            Spacer(),
                            if (BaseController.to.isLogin) ElevatedButton(onPressed: _.favNode, child: Text(_.data.isFavorite ? '已收藏' : '收藏'))
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          color: Theme.of(context).colorScheme.primary,
                          padding: EdgeInsets.all(20.w),
                          child: Text(
                            _.data.header.isNotEmpty ? _.data.header : '还没有节点描述 😊',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      if (_.loading && _.postList.isEmpty) LoadingListPage(type: 1),
                      if (_.needAuth) SliverToBoxAdapter(child: NotAllow()),
                      if (_.postList.isNotEmpty)
                        SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            if (_.postList.length - 1 == index) {
                              return Column(children: [
                                PostItem(item: _.postList[index], tab: NodeItem(type: TabType.node)),
                                FooterTips(loading: _.isLoadMore),
                              ]);
                            }
                            return PostItem(item: _.postList[index], tab: NodeItem(type: TabType.node));
                          }, childCount: _.postList.length),
                        ),
                    ],
                  ),
                  onRefresh: _.onRefresh));
        });
  }
}
