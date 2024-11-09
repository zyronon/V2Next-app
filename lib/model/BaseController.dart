import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/http/login_api.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/http/request.dart';

import 'database.dart';

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
  final database = AppDatabase();
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
  void onInit() async {
    super.onInit();
    initStorage();
  }

  initData() async {
    LoginApi.getUserInfo(uc: currentConfig).then((res) {
      if (res.success) {
        if (res.data != '2fa') {
          setUserinfo(res.data);
        }
      } else {
        setUserinfo({'member': Member(), 'uc': config['default']});
      }
    });
  }

  Future initStorage() async {
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
          config[key] = value is Map ? UserConfig.fromJson(value as dynamic) : value;
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
    initData();
  }

  setUserinfo(Map val) {
    member = val['member'];
    if (config[member.username] == null) {
      config[member.username] = new UserConfig();
    }
    _box.write(StoreKeys.currentMember.toString(), member.toJson());

    UserConfig uc = val['uc'];
    config[member.username] = uc;
    update();
    saveConfig();
  }

  setMember(Member val) {
    member = val;
    if (config[member.username] == null) {
      config[member.username] = new UserConfig();
    }
    _box.write(StoreKeys.currentMember.toString(), member.toJson());
    _box.write(StoreKeys.config.toString(), config);
    update();
  }

  saveConfig() {
    _box.write(StoreKeys.config.toString(), config);
    if (isLogin) {
      Api.editNoteItem(Const.configPrefix + jsonEncode(currentConfig.toJson()), currentConfig.configNoteId);
    }
  }

  setTabMap(val) {
    tabList.assignAll(val);
    _box.write(StoreKeys.tabMap.toString(), jsonEncode(tabList));
    update();
  }

  List getTags(String username) {
    List? r = member.tagMap[username];
    if (r == null) return [];
    return r;
  }

  setTags(String username, List<String> val) {
    member.tagMap[username] = val;
    update();
    Api.editNoteItem(Const.tagPrefix + jsonEncode(member.tagMap), currentConfig.tagNoteId);
  }
}
