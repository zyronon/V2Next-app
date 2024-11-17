import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/utils/storage.dart';

class NodeGroupPage extends StatefulWidget {
  const NodeGroupPage({super.key});

  @override
  State<NodeGroupPage> createState() => _NodeGroupPageState();
}

class _NodeGroupPageState extends State<NodeGroupPage> with TickerProviderStateMixin {
  List nodesList = GStorage().getNodeGroup().isNotEmpty ? GStorage().getNodeGroup() : [];

  BaseController bc = BaseController.to;
  late final Axis scrollDirection;
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
      nodesList = data;
    }
    if (bc.isLogin) {
      if (nodesList[0]['name'] != '已收藏') {
        nodesList.insert(0, {'name': '已收藏', 'children': []});
      }
    }
    setState(() {});
    //显示出来后，再请求最新数据
    List list = await Api.getNodeMap();
    if (list.isNotEmpty) {
      if (nodesList[0]['name'] == '已收藏') {
        nodesList.removeRange(1, nodesList.length);
        nodesList.addAll(list);
      } else {
        nodesList = list;
      }
      setState(() {});
    }

    if (bc.isLogin) {
      var res = await Api.getFavNodes();
      if (res.isNotEmpty) {
        nodesList[0]['children'] = [];
        for (var i in res) {
          nodesList[0]['children'].add({'name': i.name, 'title': i.title, 'avatar': i.avatar});
        }
      }
      setState(() {});
    }
    GStorage().setNodeGroup(nodesList);
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
        actions: [
          TextButton(
              onPressed: () {
                Get.toNamed('/search_node', arguments: {'source': FromSource.editTab});
              },
              child: const Text('全部节点')),
          const SizedBox(width: 12)
        ],
      ),
      body: nodesList.length == 0
          ? Container()
          : DefaultTabController(
              length: nodesList.length,
              child: Row(
                children: <Widget>[
                  Card(
                    elevation: 2,
                    child: ExtendedTabBar(
                      indicator: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        border: Border(
                            left: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 4.w,
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
                      scrollDirection: Axis.vertical,
                      children: nodesList.map((e) {
                        return e['children'].length == 0
                            ? const Center(
                                child: Center(
                                child: Text('还没有收藏节点'),
                              ))
                            : GridView.count(
                                padding: EdgeInsets.zero,
                                physics: const ScrollPhysics(),
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
              )),
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
              if (Get.arguments == FromSource.editTab) {
                Get.back(result: item);
              } else {
                Get.toNamed('/node_detail', arguments: item);
              }
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
}
