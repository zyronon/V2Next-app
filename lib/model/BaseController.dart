import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/http/login_api.dart';

import 'package:v2ex/model/model.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/utils/event_bus.dart';
import 'package:v2ex/utils/storage.dart';

import 'database.dart';

class BaseController extends GetxController {
  final database = AppDatabase();
  List<NodeItem> tabList = <NodeItem>[].obs;
  Member member = new Member();
  Map<String, UserConfig> config = {'default': UserConfig()};
  Timer? _timer;
  List<Map<String, int>> readList = [];

  static BaseController get to => Get.find<BaseController>();

  bool get isLogin => member.username != 'default';

  UserConfig get currentConfig => config[member.username]!;

  Layout get layout => currentConfig.layout;

  double get fontSize => currentConfig.layout.fontSize;

  @override
  void onInit() async {
    super.onInit();
    initStorage();
    database.deleteOldRecords();
    Future.delayed(Duration(seconds: 1), () {
      initData();
    });
    EventBus().on('setUnread', (_) {
      member.actionCounts[3] = _;
      setMember(member);
      update();
    });

    EventBus().on('startTask', (_) {
      startTask();
    });
  }

  @override
  void onClose() {
    super.onClose();
    if (_timer != null) {
      _timer!.cancel();
    }
    EventBus().off('setUnread');
    EventBus().off('startTask');
  }

  startTask() {
    print('startTask');
    Future.delayed(Duration(seconds: 5), () {
      LoginApi.sign();
    });

    print('开始定时查询');
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 180), (timer) {
      Api.fetchUnRead().then((r) {
        if (r == -1) _timer!.cancel();
      });
    });
  }

  initData() async {
    LoginApi.getUserInfo(uc: currentConfig).then((res) {
      if (res.success) {
        if (res.data != '2fa') {
          setUserinfo(res.data);
          startTask();
        }
      } else {
        setUserinfo({'member': Member(), 'uc': config['default']});
      }
    });
  }

  Future initStorage() async {
    readList = GStorage().getReadList();
    // print('readList===>${readList.toString()}');

    var r = GStorage().getCurrentMember();
    if (r != null) {
      member = r;
    }

    var r2 = GStorage().getConfig();
    if (r2 != null) {
      config = r2;
    }

    var list = GStorage().getTabMap();
    if (list.isEmpty) {
      setHomeTabList(Const.defaultTabList);
    } else {
      setHomeTabList(list);
    }
    update();
  }

  setUserinfo(Map val) {
    member = val['member'];
    if (config[member.username] == null) {
      config[member.username] = new UserConfig();
    }
    GStorage().setCurrentMember(member);
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
    GStorage().setCurrentMember(member);
    GStorage().setConfig(config);
    update();
  }

  saveConfig() {
    update();
    GStorage().setConfig(config);
    if (isLogin) {
      Api.editNoteItem(Const.configPrefix + jsonEncode(currentConfig.toJson()), currentConfig.configNoteId);
    }
  }

  setHomeTabList(val) {
    tabList.assignAll([...val]);
    GStorage().setTabMap(tabList);
    update();
  }

  addRead(Map<String, int> val) {
    readList.add(val);
    update();
    GStorage().setReadList(readList);
  }

  isRead(int id, int count) {
    return readList.any((map) {
      return map.entries.any((entry) => entry.key == id.toString() && entry.value == count);
    });
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
