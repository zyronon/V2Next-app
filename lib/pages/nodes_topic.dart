import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/http/api.dart';

class TopicNodesPage extends StatefulWidget {
  const TopicNodesPage({Key? key}) : super(key: key);

  @override
  State<TopicNodesPage> createState() => _TopicNodesPageState();
}

class _TopicNodesPageState extends State<TopicNodesPage> {
  List topicNodesList = [];
  List tempNodesList = [];
  List searchResList = [];
  TextEditingController controller = TextEditingController();

  // 接收的参数
  late FromSource source;
  String topicId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments.isNotEmpty) {
      source = Get.arguments['source'] != null ? Get.arguments['source']! : '';
      topicId = Get.arguments['topicId'] != null ? Get.arguments['topicId']! : '';
    }
    getTopicNodes();
  }

  Future<List> getTopicNodes() async {
    var res = await Api.getAllNodesT();
    setState(() {
      topicNodesList = res;
      tempNodesList = res;
    });
    return res;
  }

  void search(searchKey) {
    if (searchKey == '') {
      setState(() {
        topicNodesList = tempNodesList;
      });
      return;
    }
    List resultList = [];
    for (var i in topicNodesList) {
      if (i.name.contains(searchKey) || i.title.contains(searchKey)) {
        resultList.add(i);
      }
    }
    setState(() {
      topicNodesList = resultList;
    });
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
                  var res = await Api.moveTopicNode(topicId, node.name);
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
                      search(text);
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
                          moveTopicNode(topicNodesList[index]);
                        } else if (source == FromSource.editTab) {
                          print(topicNodesList[index]);
                          TopicNodeItem s = topicNodesList[index];
                          Get.back();
                          Get.back(result: {'title': s.title, 'name': s.name});
                          // Get.back(result: {'node': topicNodesList[index]});
                        } else {
                          // 新建主题
                          Get.back(result: {'node': topicNodesList[index]});
                        }
                      },
                      title: Text(
                        topicNodesList[index].title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(topicNodesList[index].name),
                      enableFeedback: true,
                      trailing: Text('主题数：${topicNodesList[index].topics}'));
                }, childCount: topicNodesList.length)),
              ],
            ),
          ],
        ));
  }
}
