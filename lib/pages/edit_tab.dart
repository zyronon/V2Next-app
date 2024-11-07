import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/utils/utils.dart';

class Controller extends GetxController {
  BaseController bc = BaseController.to;
  var isEdit = false.obs;
  var tabList = <TabItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabList.assignAll(bc.tabList);
  }
}

class EditTabPage extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('提示'),
            content: Text('确定放弃修改并返回上一页?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // 选择取消
                child: Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // 选择确认
                child: Text('确认'),
              ),
            ],
          ),
        ) ??
        false; // 如果对话框被关闭，返回 false
  }

  Widget _buildIconButton({VoidCallback? onTap, required String text, TDButtonTheme theme = TDButtonTheme.primary}) {
    return TDButton(
      text: text,
      size: TDButtonSize.small,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: theme,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX(
        init: Controller(),
        builder: (_) {
          return PopScope(
              child: Scaffold(
                  appBar: AppBar(elevation: 0, toolbarHeight: 0),
                  body: Column(
                    children: [
                      TDNavBar(
                        height: 48,
                        title: 'Tab列表',
                        screenAdaptation: false,
                        useDefaultBack: true,
                      ),
                      Expanded(
                          child: _.isEdit.value
                              ? Container(
                                  color: Colors.grey[200],
                                  child: ReorderableListView(
                                    scrollController: scrollController,
                                    header: Container(
                                      alignment: Alignment(-0.95, 0),
                                      height: 45,
                                      child: Text('长按进行拖动排序'),
                                    ),
                                    footer: Container(
                                      height: 145,
                                    ),
                                    onReorder: (int oldIndex, int newIndex) {
                                      if (newIndex > oldIndex) newIndex -= 1;
                                      final item = _.tabList.removeAt(oldIndex);
                                      _.tabList.insert(newIndex, item);
                                      _.isEdit.value = true;
                                    },
                                    children: [
                                      for (final item in _.tabList)
                                        Container(
                                          key: ValueKey(item),
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.only(bottom: 5),
                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(item.cnName),
                                              Row(
                                                children: [
                                                  Icon(TDIcons.move, color: Colors.grey),
                                                  SizedBox(width: 10),
                                                  InkWell(
                                                    child: Icon(Icons.close, color: Colors.grey),
                                                    onTap: () {
                                                      _.tabList.remove(item);
                                                    },
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Wrap(
                                        alignment: WrapAlignment.start,
                                        crossAxisAlignment: WrapCrossAlignment.start,
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: _.tabList.map((i) => TDTag(i.cnName, isLight: true, size: TDTagSize.large)).toList()),
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.priority_high,
                                              size: 16,
                                              color: Colors.grey[400],
                                            ),
                                            SizedBox(width: 5),
                                            Expanded(
                                                child: Text(
                                              '默认Tab为特殊Tab，处理逻辑和自行添加的节点不同，删除后无法再从节点列表添加，误删除请点击"编辑"=>"恢复默认"按钮',
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                            )),
                                          ],
                                        ))
                                  ],
                                )),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (!_.isEdit.value) ...[
                              _buildIconButton(
                                  text: '添加',
                                  onTap: () async {
                                    var r = await Get.toNamed('/node_list');
                                    if (r != null) {
                                      if (_.tabList.any((val) => val.enName == r['nodeId'])) {
                                        Utils.toast(msg: '已存在，请勿重复添加');
                                      } else {
                                        _.isEdit.value = true;
                                        _.tabList.add(TabItem(cnName: r['title'], enName: r['name'], type: TabType.node));
                                        Future.delayed(Duration(milliseconds: 300), () {
                                          scrollController.jumpTo(scrollController.position.maxScrollExtent);
                                        });
                                      }
                                    }
                                  }),
                              SizedBox(width: 5),
                              _buildIconButton(
                                  text: '编辑',
                                  onTap: () async {
                                    _.isEdit.value = true;
                                  }),
                            ],
                            if (_.isEdit.value) ...[
                              _buildIconButton(
                                  text: '取消',
                                  theme: TDButtonTheme.light,
                                  onTap: () {
                                    _.tabList.assignAll(_.bc.tabList);
                                    _.isEdit.value = false;
                                  }),
                              SizedBox(width: 5),
                              TDButton(
                                text: '恢复默认',
                                size: TDButtonSize.small,
                                type: TDButtonType.fill,
                                shape: TDButtonShape.rectangle,
                                theme: TDButtonTheme.primary,
                                onTap: () {
                                  // _.bc.setTabMap(Const.defaultTabList);
                                  _.tabList.assignAll(Const.defaultTabList);
                                },
                              ),
                              SizedBox(width: 5),
                              _buildIconButton(
                                  text: '添加',
                                  onTap: () async {
                                    var r = await Get.toNamed('/node_list');
                                    if (r != null) {
                                      if (_.tabList.any((val) => val.enName == r['nodeId'])) {
                                        Utils.toast(msg: '已存在，请勿重复添加');
                                      } else {
                                        _.tabList.add(TabItem(cnName: r['title'], enName: r['name'], type: TabType.node));
                                        Future.delayed(Duration(milliseconds: 300), () {
                                          scrollController.jumpTo(scrollController.position.maxScrollExtent);
                                        });
                                      }
                                    }
                                  }),
                              SizedBox(width: 5),
                              _buildIconButton(
                                  text: '重置',
                                  onTap: () {
                                    _.tabList.assignAll(_.bc.tabList);
                                  }),
                              SizedBox(width: 5),
                              _buildIconButton(
                                  text: '保存',
                                  onTap: () {
                                    _.bc.setTabMap(_.tabList);
                                    _.isEdit.value = false;
                                  })
                            ]
                          ],
                        ),
                      )
                    ],
                  )),
              canPop: !_.isEdit.value,
              onPopInvokedWithResult: (bool didPop, bool? result) async {
                if (!didPop) {
                  bool shouldLeave = await _showExitConfirmationDialog(context);
                  if (shouldLeave) {
                    Get.back();
                  }
                }
              });
        });
  }
}
