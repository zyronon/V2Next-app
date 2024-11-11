import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:get/get.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:flutter/services.dart' show rootBundle;

class NodeListPage extends StatefulWidget {
  const NodeListPage({super.key});

  @override
  State<NodeListPage> createState() => _NodeListPageState();
}

class _NodeListPageState extends State<NodeListPage> with TickerProviderStateMixin {
  // List nodesList = GStorage().getNodes().isNotEmpty ? GStorage().getNodes() : [];
  List nodesList = [];

  // List nodesList = [];
  BaseController bc = BaseController.to;
  late final Axis scrollDirection;
  bool _isLoading = false;
  bool _isLoadingFav = false;
  List<Widget> tabs = [];

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Future getData() async {
    //如果没数据，先用默认数据
    if (nodesList.isEmpty) {
      final String response = await rootBundle.loadString('assets/data/node_map.json');
      final data = json.decode(response);
      // setState(() {
      //   nodesList = data;
      //   tabs = nodesList.map((e) {
      //     return ExtendedTab(
      //       size: 75,
      //       iconMargin: const EdgeInsets.only(bottom: 0),
      //       text: e['name'],
      //     );
      //   }).toList();
      // });
    }
    // //显示出来后，再请求最新数据
    // var list = await Api.getNodeMap();
    // if (nodesList[0]['name'] == '已收藏') {
    //   nodesList.removeRange(1, nodesList.length);
    //   nodesList.addAll(list);
    // } else {
    //   nodesList = list;
    // }
    // setState(() {});
    // if (bc.isLogin) {
    //   getFavNodes();
    // }
    // GStorage().setNodes(nodesList);
  }

  Future getFavNodes() async {
    if (nodesList[0]['children'].length == 0) {
      setState(() {
        _isLoadingFav = true;
      });
    }
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
      body: DE,
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
