import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

export '';

Color mainColor = const Color(0xff40c7ff);
int mainBgColor = 0xff0F1621;
// Color mainBgColor2 = const Color(0xffe1e1e1);
Color mainBgColor2 = const Color(0xfff1f1f1);
// Color mainBgColor2 = const Color(0xffa9a9a9);
double headerHeight = 40.w;
Color line = const Color(0xfff1f1f1);
TextStyle titleStyle = TextStyle(fontSize: 16.sp, color: Colors.black);
TextStyle descStyle = TextStyle(fontSize: 12.sp, color: Colors.grey);
TextStyle timeStyle = TextStyle(fontSize: 10.sp, color: Colors.grey);

EdgeInsets pagePadding = EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.w);

class Agent {
  String pc = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36';
  String ios = 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1';
  String android = 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36';
}

class Const {
  static Agent agent = new Agent();
  static String v2Hot = 'https://test4-black-eta.vercel.app';
  static Color primaryColor = Color(0xff48a24a);
  // static Color primaryColor = Color(0xff07c160);
}
