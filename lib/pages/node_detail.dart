import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/base_avatar.dart';
import 'package:v2ex/components/base_button.dart';
import 'package:v2ex/components/footer.dart';
import 'package:v2ex/components/loading_list_page.dart';
import 'package:v2ex/components/no_data.dart';
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
    var res = await Api.getNodePageInfo(name: data.name, pageNo: pageNo);
    if (res != null) {
      if (isRefresh) postList = [];
      if (data.avatar.isEmpty) {
        data = res['model'];
        postList = res['list'];
      } else {
        postList.addAll(res['list']);
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
                            SizedBox(width: 6.w),
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
                            if (BaseController.to.isLogin)
                              InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.all(6.w),
                                    child: Icon(
                                      _.data.isFavorite ? TDIcons.star_filled : TDIcons.star,
                                      size: 24.sp,
                                      color: _.data.isFavorite ? Colors.redAccent : Colors.white,
                                    ),
                                  ),
                                  onTap: _.favNode)
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          color: Theme.of(context).colorScheme.primary,
                          padding: EdgeInsets.all(20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                _.data.header.isNotEmpty ? _.data.header : '还没有节点描述 😊',
                                style: const TextStyle(color: Colors.white),
                              )),
                              SizedBox(width: 10.w),
                              BaseButton(
                                  text: '添加到首页',
                                  onTap: () {
                                    BaseController bc = BaseController.to;
                                    if (bc.tabList.any((val) => val.name == _.data.name)) {
                                      Utils.toast(msg: '已添加到首页');
                                      return;
                                    }
                                    bc.tabList.add(_.data);
                                    bc.setTabMap(bc.tabList);
                                    Utils.toast(msg: '已添加到首页');
                                  }),
                            ],
                          ),
                        ),
                      ),
                      if (_.loading && _.postList.isEmpty) LoadingListPage(type: 1),
                      if (_.needAuth) SliverToBoxAdapter(child: NoData()),
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
