import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/utils/const_val.dart';

import '../controller.dart';

class PostNavbar extends StatelessWidget {
  final GestureTapCallback onMenu;
  final String id;

  PostNavbar({required this.onMenu,required this.id});

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
        tag: id,
        builder: (ctrl) {
      return Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 4.w, bottom: 4.w),
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
                        child: Text(
                          ctrl.post.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 16.sp),
                        ),
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
