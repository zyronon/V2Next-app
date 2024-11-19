import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2next/model/BaseController.dart';

class UserTags extends StatelessWidget {
  String username;

  UserTags({required this.username});

  @override
  Widget build(BuildContext context) {
    BaseController bc = BaseController.to;
    List list = bc.getTags(username);
    if (list.length != 0) {
      return Padding(
        padding: EdgeInsets.only(top: 8.w),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 8,
          runSpacing: 8,
          children: list.map((v) => TDTag(v, isOutline: true)).toList(),
        ),
      );
    }
    return Container();
  }
}
