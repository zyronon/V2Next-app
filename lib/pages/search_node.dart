import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:v2ex/model/model.dart';
import 'package:v2ex/http/api.dart';

class SearchNodePage extends StatefulWidget {
  const SearchNodePage({Key? key}) : super(key: key);

  @override
  State<SearchNodePage> createState() => _SearchNodePageState();
}

class _SearchNodePageState extends State<SearchNodePage> {
  TextEditingController controller = TextEditingController();
  late FromSource source;
  List<NodeItem> list = [];
  String searchKey = '';
  String postId = '';

  @override
  void initState() {
    super.initState();
    if (Get.arguments.isNotEmpty) {
      source = Get.arguments['source'] != null ? Get.arguments['source'] : '';
      postId = Get.arguments['postId'] != null ? Get.arguments['postId'] : '';
    }
    getData();
  }

  Future getData() async {
    var res = await Api.getAllNodesBySort();
    setState(() {
      list.addAll([
        new NodeItem(title: '最热', name: 'hot', type: TabType.hot),
        new NodeItem(title: '最近', name: 'recent', type: TabType.recent),
        new NodeItem(title: '最新', name: 'new', type: TabType.latest),
        new NodeItem(title: '全部', name: 'all', type: TabType.tab),
      ]);
      list.addAll(res);
    });
  }

  List<NodeItem> get searchList {
    if (searchKey.isEmpty) return list;
    return list.where((v) {
      return v.name.toLowerCase().contains(searchKey.toLowerCase()) || v.title.toString().contains(searchKey);
    }).toList();
  }

  moveTopicNode(node) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('提示'),
            content: Text('确定将主题移动到「${node.title}」节点吗？'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
              TextButton(
                child: const Text('确定'),
                onPressed: () async {
                  Navigator.pop(context);
                  var res = await Api.moveTopicNode(postId, node.name);
                  if (res) {
                    SmartDialog.showToast(
                      '移动成功',
                      displayTime: const Duration(milliseconds: 800),
                    ).then((res) {
                      Get.back(result: {
                        'nodeDetail': {'title': node.title, 'name': node.name}
                      });
                    });
                  } else {
                    SmartDialog.showToast('操作失败');
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(source == FromSource.move
              ? '移动节点'
              : source == FromSource.editTab
                  ? '全部节点'
                  : '选择节点'),
        ),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  leading: null,
                  leadingWidth: 0,
                  expandedHeight: 70,
                  title: TDSearchBar(
                    placeHolder: '请输入节点名',
                    onTextChanged: (String text) {
                      setState(() {
                        searchKey = text;
                      });
                    },
                  ),
                  elevation: 1,
                  pinned: false,
                  floating: true,
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return ListTile(
                      onTap: () {
                        if (source != '' && source == FromSource.move) {
                          // 移动节点
                          moveTopicNode(searchList[index]);
                        } else if (source == FromSource.editTab) {
                          print(searchList[index]);
                          Get.back();
                          Get.back(result: searchList[index]);
                          // Get.back(result: {'node': topicNodesList[index]});
                        } else {
                          // 新建主题
                          Get.back(result: {'node': searchList[index]});
                        }
                      },
                      title: Text(
                        searchList[index].title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(searchList[index].name),
                      enableFeedback: true,
                      trailing: Text(searchList[index].topics == 0 ? '' : '主题数：${searchList[index].topics}'));
                }, childCount: searchList.length)),
              ],
            ),
          ],
        ));
  }
}
