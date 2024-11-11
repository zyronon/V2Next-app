import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/base_avatar.dart';
import 'package:v2ex/components/footer.dart';
import 'package:v2ex/components/loading_list_page.dart';
import 'package:v2ex/components/not_allow.dart';
import 'package:v2ex/components/post_item.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/http/api.dart';

class NodeController extends GetxController {
  int pageNo = 1;
  bool needAuth = false;
  bool loading = false;
  NodeListModel model = NodeListModel();
  bool isLoadingMore = false;
  ScrollController ctrl = ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    ctrl.addListener(scrollListener);
    V2Node node = Get.arguments;
    model.name = node.enName;
    model.title = node.cnName;
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
    NodeListModel? res = await Api.getNodePageInfo(nodeEnName: model.name, pageNo: pageNo);
    if (res != null) {
      if (isRefresh) model.postList = [];
      if (model.avatar.isEmpty && model.topicCount.isEmpty) {
        model = res;
      } else {
        model.postList.addAll(res.postList);
      }
    } else {
      needAuth = true;
    }
    if (isRefresh) loading = false;
    update();
  }

  Future<void> onRefresh() async {
    pageNo = 1;
    isLoadingMore = false;
    await getData(isRefresh: true);
  }

  loadMore() async {
    if (isLoadingMore) return;
    pageNo++;
    isLoadingMore = true;
    update();
    await getData();
    isLoadingMore = false;
    update();
  }
}

class NodePage extends StatelessWidget {
  NodePage();

  // Expanded(
  //     child: ListView.builder(
  //   physics: new AlwaysScrollableScrollPhysics(),
  //   controller: _.ctrl,
  //   itemCount: _.model.topicList.length,
  //   itemBuilder: (BuildContext context, int index) {
  //     if (index == 0) {
  //       return Column(children: [
  //
  //         PostItem(item: _.model.topicList[index], tab: TabItem(type: TabType.node)),
  //       ]);
  //     }
  //     if (_.model.topicList.length - 1 == index) {
  //       return Column(children: [
  //         PostItem(item: _.model.topicList[index], tab: TabItem(type: TabType.node)),
  //         FooterTips(loading: _.isLoadingMore),
  //       ]);
  //     }
  //     return PostItem(item: _.model.topicList[index], tab: TabItem(type: TabType.node));
  //   },
  // ))
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
                        expandedHeight: 280 - MediaQuery.of(context).padding.top,
                        iconTheme: IconThemeData(color: Get.isDarkMode ? Colors.white : Theme.of(context).colorScheme.onPrimary),
                        pinned: true,
                        title: AnimatedOpacity(
                          opacity: 1,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 500),
                          child: Row(
                            children: [
                              BaseAvatar(src: _.model.avatar, diameter: 35, radius: 0),
                              const SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_.model.title,
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Get.isDarkMode ? Colors.white : Theme.of(context).colorScheme.onPrimary)),
                                  Text(
                                    '   ${_.model.topicCount} 主题  ${_.model.favoriteCount} 收藏',
                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Get.isDarkMode ? Colors.white : Theme.of(context).colorScheme.onPrimary),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        bottom: PreferredSize(
                            preferredSize: const Size.fromHeight(25),
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            )),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            children: [
                              _.model.avatar.isNotEmpty
                                  ? Container(
                                      decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(_.model.avatar), fit: BoxFit.fitWidth)),
                                    )
                                  : const Spacer(),
                              Positioned.fill(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), //可以看源码
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 112, left: 24, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        BaseAvatar(src: _.model.avatar, diameter: 62, radius: 0),
                                        const SizedBox(width: 6),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _.model.title,
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '   ${_.model.topicCount} 主题  ${_.model.favoriteCount} 收藏',
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        //TODO
                                        ElevatedButton(onPressed: () {}, child: Text(_.model.isFavorite ? '已收藏' : '收藏'))
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(_.model.nodeIntro != '' ? _.model.nodeIntro : '还没有节点描述 😊', style: const TextStyle(color: Colors.white), maxLines: 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_.loading && _.model.postList.isEmpty) LoadingListPage(type: 1),
                      if (_.needAuth) SliverToBoxAdapter(child: NotAllow()),
                      if (_.model.postList.isNotEmpty)
                        SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            if (_.model.postList.length - 1 == index) {
                              return Column(children: [
                                PostItem(item: _.model.postList[index], tab: TabItem(type: TabType.node)),
                                FooterTips(loading: _.isLoadingMore),
                              ]);
                            }
                            return PostItem(item: _.model.postList[index],  tab: TabItem(type: TabType.node));

                          }, childCount: _.model.postList.length),
                        ),
                    ],
                  ),
                  onRefresh: _.onRefresh));
        });
  }
}
