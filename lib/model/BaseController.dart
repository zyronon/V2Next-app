import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:v2ex/model/Post2.dart';

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
}

class BaseController extends GetxController {
  Member member = new Member();
  Map<String, UserConfig> config = {'default': UserConfig()};
  final GetStorage _box = GetStorage();

  bool get isLogin => member.username != 'default';

  UserConfig get currentConfig => config[member.username]!;

  @override
  void onInit() {
    super.onInit();
    var r = _box.read(StoreKeys.currentMember.toString());
    if (r != null) {
      print('member.username:${r}');
      return;
      // member = r;
    }
    // Map<String, UserConfig>? r2 = _box.read(StoreKeys.config.toString());
    // if (r2 != null) {
    //   config = r2;
    // }
    // print('member.username:${member.username}');
    // update();
  }

  setConfig(UserConfig us) {
    config[member.username] = us;
    _box.write(StoreKeys.config.toString(), config);
    update();
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
}
