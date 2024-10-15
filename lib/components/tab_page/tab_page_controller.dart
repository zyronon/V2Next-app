import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/utils/api.dart';
import 'package:v2ex/utils/http.dart';

class TabPageController extends GetxController {
  bool loading = true;
  bool needAuth = false;
  List<Post2> postList = [];
  final BaseController home = Get.find();
  TabItem tab;
  String test = '';
  int pageNo = 1;
  List<String> dateList = [];

  TabPageController({required this.tab});

  @override
  void onInit() async {
    super.onInit();
    getList(tab);
    if (tab.type == TabType.hot) {
      dateList = await Api.getV2HotDateMap();
    }
  }

  getList(TabItem tab) async {
    print('getList:type:${tab.type},id:${tab.id}');
    postList = [];
    loading = true;
    update();
    Result res = await Api.getPostListByTab(tab: tab, pageNo: pageNo, date: dateList[pageNo - 1]);
    if (res.success) {
      needAuth = false;
      postList.addAll(res.data.cast<Post2>());
    } else {
      needAuth = res.data == Auth.notAllow;
    }
    loading = false;
    update();
  }
}
