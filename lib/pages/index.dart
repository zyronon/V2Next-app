import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/pages/me.dart';
import 'package:v2ex/utils/ConstVal.dart';

import 'home.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  BaseController c = Get.put(BaseController());
  int _selectedIndex = 0;
  PageController _controller = PageController();
  final List<Widget> _Pages = [
    Home(),
    Text("Page2"),
    Text("Page3"),
    Text("Page4"),
    Me(),
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

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        // backgroundColor: bg,
        // surfaceTintColor: bg,
      ),
      body: DefaultTextStyle(
          style: TextStyle(color: Colors.black, fontSize: 14.sp),
          child: ConstrainedBox(
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
          )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mainBgColor2,
        type: BottomNavigationBarType.fixed,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        // iconSize: 24.sp,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '发帖'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '通知'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '我'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
