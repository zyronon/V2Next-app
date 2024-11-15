import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/pages/discover/discover.dart';
import 'package:v2ex/pages/notifications/notifications.dart';
import 'package:v2ex/pages/me.dart';
import 'package:v2ex/utils/const_val.dart';

import 'home/home.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  BaseController c = Get.put(BaseController());
  int _selectedIndex = 0;
  PageController _controller = PageController(initialPage: 0);
  final List<Widget> _Pages = [
    HomePage(),
    DiscoverPage(),
    NotificationsPage(),
    MePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    _controller.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _widget({required int index, required IconData icon, required String text, int? badge}) {
    return Expanded(
        child: InkWell(
            child: Stack(
              children: [
                Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: _selectedIndex == index ? Colors.grey : Colors.black,
                    ),
                    Text(text),
                  ],
                )),
                if (badge != null && badge != 0)
                  Positioned(
                      right: 20.w,
                      top: 5.w,
                      child: Container(
                        // width: 24,
                        padding: EdgeInsets.fromLTRB(5.w, 1.5.w, 5.w, 3.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Text(
                          badge > 99 ? '99' : badge.toString(),
                          style: TextStyle(fontSize: 12.sp, color: Colors.white, height: 1),
                        ),
                      ))
              ],
            ),
            onTap: () {
              _onItemTapped(index);
            }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      body: ConstrainedBox(
        constraints: const BoxConstraints(
            minWidth: double.infinity, //宽度尽可能大
            minHeight: double.infinity),
        child: Container(
          decoration: BoxDecoration(
            color: mainBgColor2,
          ),
          child: PageView(
              controller: _controller,
              //不设置默认可以左右活动，如果不想左右滑动如下设置，可以根据ios或者android来设置
              physics: const NeverScrollableScrollPhysics(),
              children: _Pages),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60.w,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Const.line)),
          boxShadow: [Const.boxShadowTop],
        ),
        child: Container(
          height: double.infinity, // 占满父容器高度
          child: Row(
            children: [
              _widget(index: 0, icon: Icons.home, text: '首页'),
              _widget(index: 1, icon: Icons.business, text: '发现'),
              _widget(index: 2, icon: Icons.notifications, text: '通知', badge: c.member.actionCounts[3]),
              _widget(index: 3, icon: Icons.settings, text: '我'),
            ],
          ),
        ),
      ),
    );
  }
}
