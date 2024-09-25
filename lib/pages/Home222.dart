import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'Page1.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const List<Widget> _widgetOptions = <Widget>[
    Page1(),
    Text("Page2"),
  ];

  int _selectedIndex = 0;
  double stateHeight = 0;

  @override
  void initState() {
    stateHeight = MediaQueryData.fromWindow(window).padding.top;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   elevation: 0,
        //   toolbarHeight: 0,
        //   // backgroundColor: bg,
        //   // surfaceTintColor: bg,
        // ),
      body: DefaultTextStyle(
          style: TextStyle(color: Colors.black, fontSize: 14.sp),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: double.infinity, //宽度尽可能大
                minHeight: double.infinity),
            child: Container(
              // padding: EdgeInsets.only(top: stateHeight),
              decoration: BoxDecoration(
                color: mainBgColor2,
              ),
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mainBgColor2,
        type: BottomNavigationBarType.fixed,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '节点',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '搜索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '通知',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '我的',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: mainColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
