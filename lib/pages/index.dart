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

  int _unreadCount = 51; // 未读消息数量

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        // backgroundColor: bg,
        // surfaceTintColor: bg,
      ),
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
      bottomNavigationBar: SizedBox(
        height: 60.w,
        child: Container(
          height: double.infinity, // 占满父容器高度
          child: Row(
            children: [
              Expanded(child: Container(color: Colors.blue)),
              Expanded(child: Container(color: Colors.green)),
            ],
          ),
        ),
      ),

      // bottomNavigationBar: Container(
      //   height: 60.w,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     border: Border(top: BorderSide(color: Const.line)),
      //     boxShadow: [Const.boxShadowTop],
      //   ),
      //   child: SizedBox.expand(
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     children: [
      //       Expanded(
      //           child: Container(
      //             child: Text('data'),
      //           )),
      //       Expanded(
      //           child: Container(
      //             child: Text('data'),
      //           )),
      //       Expanded(
      //           child: Stack(
      //             children: [
      //
      //               Center(
      //                   child: Column(
      //                     children: [Icon(Icons.home), Text('通知')],
      //                   ))
      //             ],
      //           )),
      //       Expanded(
      //           child: Container(
      //             color: Colors.redAccent,
      //             child: Text('data'),
      //           )),
      //     ],
      //   )),
      // )
      // bottomNavigationBar: BrnBottomTabBar(
      //   fixedColor: Colors.blue,
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   badgeColor: Colors.red,
      //   items: <BrnBottomTabBarItem>[
      //     BrnBottomTabBarItem(icon: Icon(Icons.home), title: Text('首页')),
      //     BrnBottomTabBarItem(icon: Icon(Icons.business), title: Text('发现')),
      //     BrnBottomTabBarItem(
      //         icon: Icon(Icons.notifications),
      //         title: Text('通知'),
      //         badge: Container(
      //           // width: 24,
      //           padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
      //           alignment: Alignment.center,
      //           decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(10))),
      //           child: Text(
      //             '9',
      //             style: TextStyle(fontSize: 10, color: Colors.white, height: 1),
      //           ),
      //         )),
      //     BrnBottomTabBarItem(icon: Icon(Icons.settings), title: Text('我的')),
      //   ],
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: mainBgColor2,
      //   type: BottomNavigationBarType.fixed,
      //   // showSelectedLabels: false,
      //   // showUnselectedLabels: false,
      //   // iconSize: 24.sp,
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
      //     BottomNavigationBarItem(icon: Icon(Icons.business), label: '发现'),
      //     // BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '通知'),
      //     BottomNavigationBarItem(
      //       icon: Stack(
      //         clipBehavior: Clip.none, // 允许角标超出 Stack 范围
      //         children: [
      //           Icon(Icons.notifications), // 主图标
      //           if (_unreadCount > 0) // 动态显示徽标
      //             Positioned(
      //               right: -6.w, // 调整徽标位置
      //               top: -3.w,
      //               child: Container(
      //                 padding: EdgeInsets.fromLTRB(4.w, 4.w, 4.w, 4.w),
      //                 decoration: BoxDecoration(
      //                   color: Colors.red,
      //                   shape: BoxShape.circle,
      //                 ),
      //                 child: Text(
      //                   '123$_unreadCount',
      //                   style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold, height: 1),
      //                 ),
      //               ),
      //             )
      //         ],
      //       ),
      //       label: '通知',
      //     ),
      //     BottomNavigationBarItem(icon: Icon(Icons.settings), label: '我的'),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Const.primaryColor,
      //   unselectedItemColor: Colors.black,
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
