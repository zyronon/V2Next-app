import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:v2ex/utils/ConstVal.dart';

class BaseDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 6.w, color: Const.line);
  }
}
