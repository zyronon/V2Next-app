import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/Post.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/http.dart';

class TabPageController extends GetxController {
  bool isLoading = true;
  List<Post2> postList = [];
  final BaseController home = Get.find();
  String node;
  String test = '';

  TabPageController({required this.node});

  @override
  void onInit() async {
    super.onInit();
    getList(node);
  }

  getList(String node) async {
    print('getList:' + node);
    var res = await DioRequestWeb.getTopicsByTabKey('tab', node, 0);
    postList = res['topicList'];
    update();
  }
}
