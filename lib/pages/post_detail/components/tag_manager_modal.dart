import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class TagManagerModal extends StatefulWidget {
  List<String> tags = [];
  var onSave;

  TagManagerModal({required this.tags, required this.onSave});

  @override
  _TagManagerModalState createState() => _TagManagerModalState();
}

class _TagManagerModalState extends State<TagManagerModal> {
  List<String> editTags = [];
  int index = -1;
  bool isEdit = false;
  TextEditingController ctrl = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    setState(() {
      editTags = List.from(widget.tags);
    });
  }

  void _addTag() {
    if (ctrl.text.isNotEmpty) {
      setState(() {
        if (index == -1) {
          editTags.add(ctrl.text);
        } else {
          editTags[index] = ctrl.text;
        }
        ctrl.text = "";
        index = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题和关闭按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('管理标签', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(icon: Icon(Icons.close), onPressed: () => Get.back()),
              ],
            ),
            SizedBox(height: 6.w),
            // 标签列表和添加按钮
            Wrap(spacing: 8, runSpacing: 8, children: [
              ...editTags.asMap().entries.map((entry) {
                int i = entry.key;
                String tag = entry.value;
                return InkWell(
                  child: TDTag(tag, isOutline: true, size: TDTagSize.large, needCloseIcon: true, onCloseTap: () {
                    setState(() {
                      editTags.removeAt(i); // 从列表中移除标签
                    });
                  }),
                  onTap: () {
                    setState(() {
                      isEdit = true;
                      ctrl.text = editTags[i];
                      index = i;
                    });
                    Future.delayed(Duration(microseconds: 1000),(){
                      FocusScope.of(context).requestFocus(focusNode);
                    });
                  },
                );
              }).toList(),
              InkWell(
                  child: TDTag('+ 添加标签', isOutline: true, size: TDTagSize.large),
                  onTap: () {
                    setState(() {
                      isEdit = true;
                      ctrl.text = '';
                      index = -1;
                    });
                    Future.delayed(Duration(microseconds: 1000),(){
                      FocusScope.of(context).requestFocus(focusNode);
                    });
                  })
            ]),
            // 输入框
            if (isEdit)
              Padding(
                  padding: EdgeInsets.only(top: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            // autofocus: true,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText: (index == -1 ? '新增' : '编辑') + '标签',
                              border: OutlineInputBorder(),
                            ),
                            controller: ctrl,
                          )),
                      SizedBox(width: 10.w),
                      TDButton(
                        text: '确定',
                        theme: TDButtonTheme.primary,
                        // size: TDButtonSize.small,
                        onTap: () {
                          _addTag();
                        },
                      )
                    ],
                  )),
            SizedBox(height: 16),
            // 保存和取消按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TDButton(text: '取消', onTap: Get.back),
                SizedBox(width: 10.w),
                TDButton(
                  text: '保存',
                  theme: TDButtonTheme.primary,
                  onTap: () {
                    widget.onSave(editTags);
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
