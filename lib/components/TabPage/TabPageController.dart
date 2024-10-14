import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/utils/api.dart';
import 'package:v2ex/utils/http.dart';

class TabPageController extends GetxController {
  bool loading = true;
  bool needAuth = true;
  List<Post2> postList = [];
  final BaseController home = Get.find();
  TabItem tab;
  String test = '';

  TabPageController({required this.tab});

  @override
  void onInit() async {
    super.onInit();
    getList(tab);
  }

  getList(TabItem tab) async {
    print('getList:type:${tab.type},id:${tab.id}');
    loading = true;
    update();
    Result<List> res = await Api.getPostListByTab<List>(tab: tab);
    if (res.success) {
      postList = postList.addAll(res.data!);
    } else {
      needAuth = res.data == Auth.notAllow;
    }
    loading = false;
    update();
  }
}
