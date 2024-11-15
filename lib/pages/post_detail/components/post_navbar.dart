import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/utils/const_val.dart';

import '../controller.dart';

class ResponsiveText extends StatefulWidget {
  final String text;

  const ResponsiveText({required this.text});

  @override
  _ResponsiveTextState createState() => _ResponsiveTextState();
}

class _ResponsiveTextState extends State<ResponsiveText> {
  double fontSize = 16.w;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Future.microtask(() => _updateFontSize(constraints.maxWidth));
        return Text(
          widget.text,
          style: TextStyle(fontSize: fontSize, height: 1),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }

  void _updateFontSize(double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: TextStyle(fontSize: 16.w, height: 1)),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: maxWidth);

    double newFontSize = textPainter.didExceedMaxLines ? 14.w : 16.w;

    // 只有当字体大小需要更新时才调用 setState
    if (fontSize != newFontSize && fontSize == 16.w) {
      setState(() {
        fontSize = newFontSize;
      });
    }
  }
}

class PostNavbar extends StatelessWidget {
  final GestureTapCallback onMenu;
  final String postId;

  PostNavbar({required this.onMenu, required this.postId});

  Widget _buildIcon(IconData icon) {
    return Icon(
      icon,
      size: 24.sp,
      color: Colors.black54,
    );
  }

  Widget _buildClickIcon(IconData icon, [GestureTapCallback? onTap]) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
        child: _buildIcon(icon),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostDetailController>(
        tag: postId,
        builder: (ctrl) {
          return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Const.line)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // 阴影颜色
                    spreadRadius: 1, // 扩散半径
                    blurRadius: 10, // 模糊半径
                    offset: Offset(0, 2), // 阴影偏移量 (x, y)
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildClickIcon(Icons.arrow_back_ios_new, () {
                          Get.back();
                        }),
                        Expanded(
                            child: InkWell(
                          child: AnimatedOpacity(
                            opacity: ctrl.isShowFixedTitle ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: ResponsiveText(text: ctrl.post.title),
                          ),
                          onTap: () {
                            ctrl.scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.ease);
                          },
                        ))
                      ],
                    ),
                  ),
                  _buildClickIcon(Icons.more_vert, onMenu)
                ],
              ));
        });
  }
}
