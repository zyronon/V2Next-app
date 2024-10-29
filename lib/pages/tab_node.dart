import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/utils/ConstVal.dart';

class Controller extends GetxController {
  var items = List.generate(10, (index) => "Item $index").obs;
  BaseController bc = BaseController.to;
  var isEdit = false.obs;
  var showSort = false.obs;
  var tabMap = <TabItem>[].obs;

  void reorderItem(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
  }

  @override
  void onInit() {
    super.onInit();
    // tabMap.value = List.from(bc.tabMap);
    tabMap.assignAll(bc.tabList);
  }
}

class TabNodePage extends StatelessWidget {
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

  Widget _buildIconButton({
    VoidCallback? onTap,
    required IconData icon,
    required String text,
    TDButtonTheme theme = TDButtonTheme.primary
  }) {
    return TDButton(
      text: text,
      size: TDButtonSize.small,
      type: TDButtonType.fill,
      shape: TDButtonShape.rectangle,
      theme: theme,
      onTap: onTap,
    );
    return IconButton(
      tooltip: text,
      onPressed: onTap,
      icon: Icon(icon, size: 22.0, color: Const.primaryColor),
      // icon: Icon(!checkStatus ? Icons.done : Icons.done_all, color: Theme.of(context).colorScheme.primary,),
      style: IconButton.styleFrom(padding: const EdgeInsets.all(9), backgroundColor: Colors.white),
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
                        title: '当前Tab',
                        screenAdaptation: false,
                        useDefaultBack: true,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          if (_.isEdit.value) ...[
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TDButton(
                                    text: '恢复默认',
                                    size: TDButtonSize.small,
                                    type: TDButtonType.fill,
                                    shape: TDButtonShape.rectangle,
                                    theme: TDButtonTheme.primary,
                                    onTap: () {
                                      // _.bc.setTabMap(Const.defaultTabList);
                                      _.tabMap.assignAll(Const.defaultTabList);
                                      _.isEdit.value = true;
                                    },
                                  ),
                                  SizedBox(width: 5),
                                  _buildIconButton(
                                      text: '添加',
                                      icon: TDIcons.add,
                                      onTap: () async {
                                        var r = await Get.toNamed('/node_list');
                                        if (r != null) {
                                          _.tabMap.add(TabItem(cnName: r['nodeName'], enName: r['nodeId'], type: TabType.node));
                                          _.isEdit.value = true;
                                        }
                                      }),
                                ],
                              ),
                            ),
                            Expanded(
                                child: ReorderableListView(
                              onReorder: (int oldIndex, int newIndex) {
                                if (newIndex > oldIndex) newIndex -= 1;
                                final item = _.tabMap.removeAt(oldIndex);
                                _.tabMap.insert(newIndex, item);
                                _.isEdit.value = true;
                              },
                              children: [
                                for (final item in _.tabMap)
                                  Container(
                                    key: ValueKey(item),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item.cnName),
                                        Row(
                                          children: [
                                            Icon(Icons.more_vert, color: Colors.grey),
                                            SizedBox(width: 10),
                                            Icon(Icons.close, color: Colors.grey),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            ))
                          ] else
                            Wrap(
                                alignment: WrapAlignment.start,
                                // 主轴对齐方式为靠左
                                crossAxisAlignment: WrapCrossAlignment.start,
                                // 交叉轴对齐方式为靠左
                                spacing: 8,
                                runSpacing: 8,
                                children: _.tabMap
                                    .map(
                                      (i) => TDTag(
                                        i.cnName,
                                        isLight: true,
                                        size: TDTagSize.large,
                                        onCloseTap: () {
                                          _.tabMap.remove(i);
                                          _.isEdit.value = true;
                                        },
                                      ),
                                    )
                                    .toList()),
                          SizedBox(height: 20),
                        ],
                      )),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(width: 5),
                            if (!_.isEdit.value) ...[
                              _buildIconButton(
                                  text: '编辑',
                                  icon: TDIcons.edit,
                                  onTap: () async {
                                    _.isEdit.value = true;
                                  }),
                              SizedBox(width: 5),
                            ],
                            SizedBox(width: 5),
                            if (_.isEdit.value) ...[
                              _buildIconButton(
                                  text: '取消',
                                  icon: TDIcons.refresh,
                                  theme: TDButtonTheme.light,
                                  onTap: () {
                                    _.isEdit.value = false;
                                  }),
                              SizedBox(width: 5),
                              _buildIconButton(
                                  text: '重置',
                                  icon: TDIcons.refresh,
                                  onTap: () {
                                    _.tabMap.assignAll(_.bc.tabList);
                                    _.isEdit.value = false;
                                  }),
                              SizedBox(width: 5),
                              _buildIconButton(
                                  text: '保存',
                                  icon: TDIcons.save,
                                  onTap: () {
                                    _.bc.setTabMap(_.tabMap);
                                    Get.back(result: 'change');
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
