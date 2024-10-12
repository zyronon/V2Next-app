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
  bool isLoading = true;
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
    postList = await Api.getPostListByTab(type: tab.type, id: tab.id);
    update();
  }
}
