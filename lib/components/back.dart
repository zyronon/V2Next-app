import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Back extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 24.sp,
          color: Colors.black54,
        ),
      ),
      onTap: Get.back,
    );
  }
}
