import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/http.dart';
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

  @override
  void onInit() {
    super.onInit();
    initStorage();
    initData();
  }

  initData() async {
    Response res = await Http().get('/notes', isMobile: true);
    print('initData,isRedirect:${res.isRedirect},statusCode:${res.statusCode},realUri:${res.realUri}');
    if (!res.isRedirect && !(res.data as String).contains('其他登录方式')) {
      Document document = parse(res.data);
      Element? avatarEl = document.querySelector('#menu-entry .avatar');
      if (avatarEl != null) {
        member.username = avatarEl.attributes['alt']!;
        member.avatar = avatarEl.attributes['src']!;
        print('当前用户${member.username}');
        setMember(member);

        Http().get('/?tab=all', isMobile: false).then((res2) {
          Document document2 = parse(res2.data);
          var rightBarNode = document2.querySelector('#Rightbar > div.box');
          List tableList = rightBarNode!.querySelectorAll('table');
          if (tableList.isNotEmpty) {
            var actionNodes = tableList[1]!.querySelectorAll('span.bigger');
            for (var i in actionNodes) {
              member.actionCounts.add(int.parse(i.text ?? 0));
              print('actionCounts:${i.text}');
            }
            if (rightBarNode.querySelector('#money') != null) {
              var imgList = rightBarNode.querySelectorAll('#money > a img');
              imgList.forEach((img) {
                img.attributes['src'] = Const.v2ex + img.attributes['src']!;
              });
              member.balance = rightBarNode.querySelector('#money >a')!.innerHtml;
              print('$member.balance${member.balance}');
            }
            var noticeEl = rightBarNode.querySelectorAll('a.fade');
            if (noticeEl.isNotEmpty) {
              var unRead = noticeEl[0].text.replaceAll(RegExp(r'\D'), '');
              print('$unRead条未读消息');
              member.actionCounts.add(int.parse(unRead));
            }
            setMember(member);
          }
        });
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
    var r3 = _box.read(StoreKeys.tabMap.toString());
    if (r3 != null) {
      print(r3);
      List<TabItem> list = (r3 as List).map((v) => TabItem.fromJson(v)).toList();
      setTabMap(list);
    }else{
      setTabMap(Const.defaultTabList);
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

  setTabMap(val) {
    tabList.assignAll(val);
    _box.write(StoreKeys.tabMap.toString(), tabList);
    update();
  }
}
