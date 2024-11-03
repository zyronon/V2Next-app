import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:v2ex/model/TabItem.dart';

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
  // String android = 'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.114 Mobile Safari/537.36';
}

class Const {
  static Agent agent = new Agent();
  static String v2Hot = 'https://v2hotlist.vercel.app';
  static String v2exHost = 'https://www.v2ex.com';
  static String git = 'https://github.com/zyronon/V2Next';
  static String issues = 'https://github.com/zyronon/V2Next/issues';
  static Color primaryColor = Color(0xff48a24a);
  static Color line = Color(0xfff1f1f1);
  static double padding = 10.w;
  static EdgeInsetsGeometry paddingWidget = EdgeInsets.all(padding);
  static BorderRadiusGeometry borderRadiusWidget = BorderRadius.circular(10.r);
  // 所有节点
  static String allNodes = '/api/nodes/all.json';
  // 所有节点 topic
  static String allNodesT = '/api/nodes/list.json';

  static List<TabItem> defaultTabList = [
    new TabItem(cnName: '最热', enName: 'hot', type: TabType.hot),
    // new TabItem(cnName: '沙盒', enName: 'sandbox', type: TabType.node),
    new TabItem(cnName: '水深火热', enName: 'flamewar', type: TabType.node),
    new TabItem(cnName: '最新', enName: 'new', type: TabType.latest),
    new TabItem(cnName: '全部', enName: 'all', type: TabType.tab),
    new TabItem(cnName: '技术', enName: 'tech', type: TabType.tab),
    new TabItem(cnName: '创意', enName: 'creative', type: TabType.tab),
    new TabItem(cnName: '好玩', enName: 'play', type: TabType.tab),
    new TabItem(cnName: 'Apple', enName: 'apple', type: TabType.tab),
    new TabItem(cnName: '酷工作', enName: 'jobs', type: TabType.tab),
    new TabItem(cnName: '交易', enName: 'deals', type: TabType.tab),
    new TabItem(cnName: '城市', enName: 'city', type: TabType.tab),
    new TabItem(cnName: '问与答', enName: 'qna', type: TabType.tab),
    new TabItem(cnName: 'R2', enName: 'r2', type: TabType.tab),
    new TabItem(cnName: '节点', enName: 'nodes', type: TabType.tab),
    new TabItem(cnName: '关注', enName: 'members', type: TabType.tab),
  ];
// static Color primaryColor = Color(0xff07c160);
}
