import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:get/get.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/api.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:flutter/services.dart' show rootBundle;

class NodeListPage extends StatefulWidget {
  const NodeListPage({super.key});

  @override
  State<NodeListPage> createState() => _NodeListPageState();
}

class _NodeListPageState extends State<NodeListPage> with TickerProviderStateMixin {
  List nodesList = GStorage().getNodes().isNotEmpty ? GStorage().getNodes() : [];

  // List nodesList = [];
  BaseController bc = BaseController.to;
  late final Axis scrollDirection;
  late TabController tabController;
  bool _isLoading = false;
  bool _isLoadingFav = false;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Future getData() async {
    //如果没数据，先用默认数据
    if (nodesList.isNotEmpty) {
      final String response = await rootBundle.loadString('assets/data/node_map.json');
      final data = json.decode(response);
      nodesList = data;
      tabController = TabController(length: data.length, vsync: this);
    } else {
      //有就用缓存的
      tabController = TabController(length: nodesList.toList().length, vsync: this);
    }
    setState(() {});

    //显示出来后，再请求最新数据
    nodesList = await Api.getNodeMap();
    tabController = TabController(length: nodesList.toList().length, vsync: this);
    setState(() {
      _isLoading = false;
    });
    if (bc.isLogin) {
      getFavNodes();
    }
    GStorage().setNodes(nodesList);
  }

  Future getFavNodes() async {
    setState(() {
      _isLoadingFav = true;
    });
    var res = await Api.getFavNodes();
    setState(() {
      _isLoadingFav = false;
    });
    var list = [];
    if (res.isNotEmpty) {
      for (var i in res) {
        list.add({'name': i.nodeId, 'title': i.nodeName, 'avatar': i.nodeCover});
      }
    }
    setState(() {
      nodesList[0]['children'] = list;
    });
  }

  allNodes(e) {
    List res = [];
    for (var i = 19; i < e.length; i++) {
      res.add(e[i]);
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 550,
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
          child: GridView.count(
            padding: EdgeInsets.zero,
            // 禁止滚动
            physics: const NeverScrollableClampingScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 6,
            children: nodesChildList(res),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.backgroundColor,
        // title: const Text('节点'),
        actions: [
          TextButton(
              onPressed: () {
                Get.toNamed('/topicNodes', arguments: {'source': FromSource.editTab});
              },
              child: const Text('全部节点')),
          // IconButton(onPressed: () {
          //   getFavNodes();
          // }, icon: const Icon(Icons.refresh_rounded)),
          const SizedBox(width: 12)
        ],
      ),
      body: _isLoading
          ? showLoading()
          : Row(
              children: <Widget>[
                Card(
                  elevation: 2,
                  clipBehavior: Clip.hardEdge,
                  child: ExtendedTabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      border: Border(
                          left: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 4.0,
                        style: BorderStyle.solid,
                      )),
                    ),
                    unselectedLabelColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
                    labelColor: Theme.of(context).colorScheme.primary,
                    scrollDirection: Axis.vertical,
                    labelStyle: Theme.of(context).textTheme.titleSmall,
                    tabs: nodesList.map((e) {
                      return ExtendedTab(
                        size: 75,
                        iconMargin: const EdgeInsets.only(bottom: 0),
                        text: e['name'],
                      );
                    }).toList(),
                  ),
                ),
                // const SizedBox(width: 4),
                Expanded(
                  child: ExtendedTabBarView(
                    cacheExtent: 0,
                    controller: tabController,
                    scrollDirection: Axis.vertical,
                    children: nodesList.map((e) {
                      return e['name'] == '已收藏'
                          ? FavNodes(_isLoadingFav, e)
                          : GridView.count(
                              padding: EdgeInsets.zero,
                              // 禁止滚动
                              physics: e['children'].length < 5 ? const NeverScrollableClampingScrollPhysics() : const ScrollPhysics(),
                              crossAxisCount: Breakpoints.large.isActive(context)
                                  ? 8
                                  : Breakpoints.medium.isActive(context)
                                      ? 6
                                      : 3,
                              mainAxisSpacing: 6,
                              children: [
                                ...nodesChildList(e['children']),
                                if (Breakpoints.small.isActive(context) && e['children'].length > 19)
                                  IconButton(
                                    onPressed: () {
                                      allNodes(e['children']);
                                    },
                                    icon: Icon(Icons.more_horiz, color: Theme.of(context).colorScheme.primary),
                                  ),
                              ],
                            );
                    }).toList(),
                  ),
                )
              ],
            ),
    );
  }

  List<Widget> nodesChildList(children) {
    List<Widget>? list = [];
    int maxCount = Breakpoints.mediumAndUp.isActive(context) ? children.length : 18;
    for (var i = 0; i < children.length; i++) {
      var item = children[i];
      if (i <= maxCount) {
        list.add(
          InkWell(
            onTap: () {
              // Get.toNamed('/go/${item['nodeId']}');
              Get.back(result: item);
            },
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                if (item['avatar'] != null && item['avatar'] != '') ...[
                  CachedNetworkImage(
                    imageUrl: item['avatar'],
                    width: 38,
                    height: 38,
                  )
                ] else ...[
                  Image.asset(
                    'assets/images/logo.png',
                    width: 38,
                    height: 38,
                  )
                ],
                const SizedBox(height: 8),
                Text(item['title'], overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center, maxLines: 1),
              ],
            ),
          ),
        );
      }
    }
    return list;
  }

  Widget showLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            strokeWidth: 3,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget FavNodes(loading, nodes) {
    return loading
        ? showLoading()
        : nodes.isEmpty
            ? const Text('没数据')
            : nodes['children'].length == 0
                ? const Center(
                    child: Center(
                    child: Text('还没有收藏节点'),
                  ))
                : GridView.count(
                    padding: EdgeInsets.zero,
                    // 禁止滚动
                    physics: nodes.length < 5 ? const NeverScrollableClampingScrollPhysics() : const ScrollPhysics(),
                    crossAxisCount: Breakpoints.large.isActive(context)
                        ? 8
                        : Breakpoints.medium.isActive(context)
                            ? 6
                            : 3,
                    mainAxisSpacing: 6,
                    children: [
                      ...nodesChildList(nodes['children']),
                      if (Breakpoints.small.isActive(context) && nodes['children'].length > 19)
                        IconButton(
                            onPressed: () {
                              allNodes(nodes['children']);
                            },
                            icon: Icon(Icons.more_horiz, color: Theme.of(context).colorScheme.primary)),
                    ],
                  );
  }
}
