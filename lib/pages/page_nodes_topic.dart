import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/api.dart';

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
                        'nodeDetail': {'nodeName': node.title, 'nodeId': node.name}
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
                  title: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.only(top: 10, right: 5, left: 5, bottom: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        padding: const EdgeInsets.only(top: 0, right: 0, left: 20, bottom: 0),
                        child: Center(
                          child: TextField(
                            controller: controller,
                            autofocus: false,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '搜索节点',
                              suffixIcon: controller.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Theme.of(context).colorScheme.outline,
                                      ),
                                      onPressed: () {
                                        controller.clear();
                                        setState(() {
                                          topicNodesList = tempNodesList;
                                        });
                                      })
                                  : null,
                            ),
                            onChanged: (String value) {
                              search(value);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  elevation: 1,
                  pinned: false,
                  floating: true,
                  // flexibleSpace: FlexibleSpaceBar(
                  //   background: Column(
                  //     children: [
                  //       const SizedBox(height: kToolbarHeight),
                  //       Container(
                  //         width: double.infinity,
                  //         padding: const EdgeInsets.only(
                  //             top: 0, right: 12, left: 12, bottom: 0),
                  //         child: ClipRRect(
                  //           borderRadius: BorderRadius.circular(50),
                  //           child: Container(
                  //             width: double.infinity,
                  //             height: 50,
                  //             color: Theme.of(context).colorScheme.onInverseSurface,
                  //             padding: const EdgeInsets.only(
                  //                 top: 0, right: 0, left: 20, bottom: 0),
                  //             child: Center(
                  //               child: TextField(
                  //                 controller: controller,
                  //                 autofocus: true,
                  //                 textInputAction: TextInputAction.search,
                  //                 decoration: InputDecoration(
                  //                   border: InputBorder.none,
                  //                   hintText: '搜索节点',
                  //                   suffixIcon: controller.text.isNotEmpty
                  //                       ? IconButton(
                  //                           icon: Icon(
                  //                             Icons.clear,
                  //                             color: Theme.of(context)
                  //                                 .colorScheme
                  //                                 .outline,
                  //                           ),
                  //                           onPressed: () {
                  //                             controller.clear();
                  //                             setState(() {
                  //                               topicNodesList = tempNodesList;
                  //                             });
                  //                           })
                  //                       : null,
                  //                 ),
                  //                 onChanged: (String value) {
                  //                   search(value);
                  //                 },
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                          Get.back(result: {'nodeName': s.title, 'nodeId': s.name});
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
