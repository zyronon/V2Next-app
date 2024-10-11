import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/http.dart';
import 'package:v2ex/utils/init.dart';
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
    Response res = await Http().get('/notes');
    print('initData,isRedirect:${res.isRedirect},statusCode:${res.statusCode}');
    if (!res.isRedirect) {
      Document document = parse(res.data);
      Element? avatarEl = document.querySelector('#menu-entry .avatar');
      if (avatarEl != null) {
        member.username = avatarEl.attributes['alt']!;
        member.avatar = avatarEl.attributes['src']!;
        print('当前用户${member.username}');
        setMember(member);
      }
      List<Element> nodeListEl = document.querySelectorAll('#Wrapper .box .cell a');
      if (nodeListEl.isNotEmpty) {
        List<Element> tagItems = nodeListEl.where((v) => v.text.contains(currentConfig.configPrefix)).toList();
        if (tagItems.isNotEmpty) {
          currentConfig.configNoteId = tagItems[0].attributes['href']!.replaceAll('/notes/', '');
          Result res = await DioRequestWeb.getNoteItemContent(currentConfig.configNoteId, currentConfig.configPrefix);
          if (res.success) {
            print('获取配置${res.data.toString()}');
            config[member.username] = UserConfig.fromJson(res.data);
            _box.write(StoreKeys.config.toString(), config);
            update();
          } else {}
        } else {
          print('初始化配置');
          Result r = await DioRequestWeb.createNoteItem(currentConfig.configPrefix);
          if (r.success) {
            currentConfig.configNoteId = r.data;
            await DioRequestWeb.editNoteItem(
              currentConfig.configPrefix + jsonEncode(currentConfig.toJson()),
              currentConfig.configNoteId,
            );
          }
        }
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
