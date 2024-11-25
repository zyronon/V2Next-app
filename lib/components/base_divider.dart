import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:v2next/utils/const_val.dart';

class BaseDivider extends StatelessWidget {
  double height;

  BaseDivider({this.height = 6});

  @override
  Widget build(BuildContext context) {
    return Container(height: height, color: Const.line);
  }
}
