import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/utils/utils.dart';

class BaseHtmlWidget extends StatelessWidget {
  final String html;
  final bool ellipsis;
  final GestureTapCallback? onTap;

  const BaseHtmlWidget({super.key, required this.html, this.onTap, this.ellipsis = false});

  @override
  Widget build(BuildContext context) {
    var selectedText = '';

    return SelectionArea(
        onSelectionChanged: (SelectedContent? selectContent) => selectedText = selectContent?.plainText ?? "",
        contextMenuBuilder: (BuildContext context, SelectableRegionState selectableRegionState) {
          final List<ContextMenuButtonItem> buttonItems = [
            ContextMenuButtonItem(
                label: '全选',
                onPressed: () {
                  selectableRegionState.selectAll(SelectionChangedCause.toolbar);
                }),
            ContextMenuButtonItem(
                label: '复制',
                onPressed: () {
                  selectableRegionState.copySelection(SelectionChangedCause.toolbar);
                }),
            ContextMenuButtonItem(
                label: 'base64解码',
                onPressed: () {
                  try {
                    var res = Utils.base64Decode2(selectedText);
                    selectableRegionState.hideToolbar();
                    Get.defaultDialog(
                      title: '解码结果',
                      middleText: res,
                      radius:10,
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // 按钮右对齐
                          children: [
                            TDButton(
                              text: '复制',
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                              onTap: () {
                                Utils.copy(res);
                                Get.back();
                              },
                            ),
                            SizedBox(width: 8), // 添加按钮之间的间距
                            TDButton(
                              text: '关闭',
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                              onTap: () {
                                Get.back();
                              },
                            )
                          ],
                        ),
                      ],
                    );
                  } catch (e) {
                    Utils.toast('解码失败');
                  }
                })
          ];
          return AdaptiveTextSelectionToolbar.buttonItems(
            buttonItems: buttonItems,
            anchors: selectableRegionState.contextMenuAnchors,
          );
        },
        child: InkWell(
          child: HtmlWidget(
            ellipsis ? '<div style="max-lines: 3; text-overflow: ellipsis">${html}</div>' : html,
            renderMode: RenderMode.column,
            textStyle: TextStyle(fontSize: 14.sp),
            customStylesBuilder: (element) {
              if (element.classes.contains('subtle')) {
                return {
                  'background-color': '#ecfdf5e6',
                  'border-left': '4px solid #a7f3d0',
                  'padding': '5px',
                };
              }
              if (element.classes.contains('fade')) {
                return {'color': '#6b6b6b'};
              }
              if (element.classes.contains('outdated')) {
                return {
                  'color': 'gray',
                  'font-size': '14px',
                  'background-color': '#f9f9f9',
                  'border-left': '5px solid #f0f0f0',
                  'padding': '10px',
                };
              }
              return null;
            },
          ),
          onTap: onTap,
        ));
  }
}
