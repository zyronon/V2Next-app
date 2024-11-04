import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/pages/login/login_api.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/api.dart';
import 'package:v2ex/utils/request.dart';

enum StoreKeys {
  token,
  userInfo,
  loginStatus,
  once,
  replyContent,
  replyItem,
  statusBarHeight,
  themeType,
  signStatus,
  nodes,
  linkOpenInApp,
  expendAppBar,
  noticeOn,
  autoSign,
  eightQuery,
  globalFs,
  htmlFs,
  replyFs,
  tabs,
  autoUpdate,
  highlightOp,
  tempFs,
  sideslip,
  dragOffset,
  displayModeType,
  config,
  currentMember,
  tabMap
}

class BaseController extends GetxController {
  List<TabItem> tabList = <TabItem>[].obs;
  Member member = new Member();
  Map<String, UserConfig> config = {'default': UserConfig()};
  final GetStorage _box = GetStorage();

  static BaseController get to => Get.find<BaseController>();

  bool get isLogin => member.username != 'default';

  UserConfig get currentConfig => config[member.username]!;

  Layout get layout => currentConfig.layout;

  double get fontSize => currentConfig.layout.fontSize;

  @override
  void onInit() {
    super.onInit();
    initStorage();
    initData();
  }

  initData() async {
    LoginApi.getUserInfo().then((res) {
      if (res.success) {
        if (res.data != '2fa') {
          setUserinfo(res.data);
        }
      }
    });
  }

  initStorage() {
    var r = _box.read(StoreKeys.currentMember.toString());
    if (r != null) {
      member = Member.fromJson(r);
    }
    var r2 = _box.read(StoreKeys.config.toString());
    if (r2 != null) {
      r2.forEach((key, value) {
        if (config[key] == null) {
          config[key] = new UserConfig();
        } else {
          config[key] = UserConfig.fromJson(value);
        }
      });
    }
    var r3 = _box.read(StoreKeys.tabMap.toString());
    if (r3 != null) {
      print(r3);
      r3 = jsonDecode(r3);
      List<TabItem> list = (r3 as List).map((v) => TabItem.fromJson(v)).toList();
      setTabMap(list);
    } else {
      setTabMap(Const.defaultTabList);
    }
    update();
  }

  setUserinfo(Map val) {
    member = val['member'];
    if (config[member.username] == null) {
      config[member.username] = new UserConfig();
    }
    _box.write(StoreKeys.currentMember.toString(), member);

    UserConfig uc = val['uc'];
    config[member.username] = uc;
    _box.write(StoreKeys.config.toString(), config);
    update();
    Api.editNoteItem(uc.configPrefix + jsonEncode(uc.toJson()), uc.configNoteId);
  }

  setMember(Member val) {
    member = val;
    if (config[member.username] == null) {
      config[member.username] = new UserConfig();
    }
    _box.write(StoreKeys.currentMember.toString(), member);
    _box.write(StoreKeys.config.toString(), config);
    update();
  }

  setTabMap(val) {
    tabList.assignAll(val);
    _box.write(StoreKeys.tabMap.toString(), jsonEncode(tabList));
    update();
  }
}
