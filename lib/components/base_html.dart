import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
// import 'package:fwfh_url_launcher/fwfh_url_launcher.dart';
import 'package:get/get.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2next/components/base_button.dart';
import 'package:v2next/components/image_preview.dart';
import 'package:v2next/model/BaseController.dart';
import 'package:v2next/model/model.dart';
import 'package:v2next/utils/utils.dart';

class CommonHtml extends StatelessWidget {
  final String html;
  final bool ellipsis;
  final double? fontSize;

  const CommonHtml({super.key, required this.html, this.ellipsis = false, this.fontSize});

  @override
  Widget build(BuildContext context) {
    BaseController bc = BaseController.to;

    return HtmlWidget(ellipsis ? '<div style="max-lines: 3; text-overflow: ellipsis">${html}</div>' : html,
        renderMode: RenderMode.column,
        textStyle: TextStyle(fontSize: this.fontSize != null ? this.fontSize : bc.fontSize, height: bc.layout.lineHeight),
        factoryBuilder: () => MyHtmlFactory(),
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
        onTapUrl: (url) {
          print('url--------------------${url.toString()}');
          if (url.contains('v2ex.com/t/') || url.contains('/t/')) {
            url = url.replaceAll('v2ex.com/t/', '');
            url = url.replaceAll('/t/', '');
            var match = RegExp(r'(\d+)').allMatches(url);
            var result = match.map((m) => m.group(0)).toList();
            Get.toNamed('/post_detail', arguments: Post(postId: int.parse(result[0]!)), preventDuplicates: false);
            return true;
          }
          Utils.openBrowser(url);
          return true;
        },
        onTapImage: (ImageMetadata imageMetadata) {
          Get.to(ImagePreview(), arguments: {'imgList': imageMetadata.sources.map((v) => v.url).toList(), 'initialPage': 0});
        });
  }
}

class BaseHtml extends StatelessWidget {
  final String html;
  final bool ellipsis;
  final GestureTapCallback? onTap;
  final double? fontSize;

  const BaseHtml({super.key, required this.html, this.onTap, this.ellipsis = false, this.fontSize});

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
                      radius: 10,
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // 按钮右对齐
                          children: [
                            BaseButton(
                              text: '复制',
                              theme: TDButtonTheme.primary,
                              onTap: () {
                                Utils.copy(res);
                                Get.back();
                              },
                            ),
                            SizedBox(width: 8), // 添加按钮之间的间距
                            BaseButton(
                              text: '关闭',
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
                    Utils.toast(msg: '解码失败');
                  }
                })
          ];
          return AdaptiveTextSelectionToolbar.buttonItems(
            buttonItems: buttonItems,
            anchors: selectableRegionState.contextMenuAnchors,
          );
        },
        child: InkWell(
          child: CommonHtml(html: html, ellipsis: ellipsis, fontSize: fontSize),
          onTap: onTap,
        ));
  }
}

class MyHtmlFactory extends WidgetFactory with CachedNetworkImageFactory {}

/// A mixin that can render IMG with `cached_network_image` plugin.
mixin CachedNetworkImageFactory on WidgetFactory {
  /// Uses a custom cache manager.
  BaseCacheManager? get cacheManager => null;

  @override
  Widget? buildImageWidget(BuildMetadata meta, ImageSource src) {
    final url = src.url;
    if (!url.startsWith(RegExp('https?://'))) {
      return super.buildImageWidget(meta, src);
    }

    return CachedNetworkImage(
      cacheManager: cacheManager,
      errorWidget: (context, _, error) => onErrorBuilder(context, meta, error, src) ?? widget0,
      fit: BoxFit.fill,
      imageUrl: url,
      //不需要加载框，难看死了
      // progressIndicatorBuilder: (context, _, progress) {
      //   final t = progress.totalSize;
      //   final v = t != null && t > 0 ? progress.downloaded / t : null;
      //   return onLoadingBuilder(context, meta, v, src) ?? widget0;
      // },
    );
  }
}
