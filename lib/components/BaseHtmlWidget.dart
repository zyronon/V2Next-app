import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class BaseHtmlWidget extends StatelessWidget {
  final String html;

  const BaseHtmlWidget({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
        child: HtmlWidget(
      html,
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
    ));
  }
}
