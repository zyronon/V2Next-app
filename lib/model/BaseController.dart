import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/http.dart';
import 'package:v2ex/utils/init.dart';

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
    initStorage();
    initData();
  }

  initData() async {
    var res = await Request().get('/notes', extra: {'ua': 'mob'});
    print('initData${res.statusCode};${res.isRedirect}');
    if (!res.isRedirect) {
      Document document = parse(res.data);
      Element? avatarEl = document.querySelector('#menu-entry .avatar');
      if (avatarEl != null) {
        member.username = avatarEl.attributes['alt']!;
        member.avatar = avatarEl.attributes['src']!;
        setMember(member);
      }
      var nodeListEl = document.querySelectorAll('#Wrapper .box .cell a');
      if (nodeListEl.isNotEmpty) {
        var tagItems = nodeListEl.where((v) => v.text.contains(currentConfig.configPrefix));
        if (tagItems.isNotEmpty) {

        } else {
        }
        var r = await DioRequestWeb.createNoteItem(currentConfig.configPrefix);

      }
    }
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
    update();
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
