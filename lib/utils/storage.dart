import 'dart:convert';
import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/utils/const_val.dart';

class GStorage {
  static final GStorage _storage = GStorage._internal();
  final GetStorage _box = GetStorage();

  GStorage._internal();

  factory GStorage() => _storage;

  // once
  setOnce(int once) => _box.write(StoreKeys.once.toString(), once);

  int getOnce() => _box.read<int>(StoreKeys.once.toString()) ?? 0;

  setStatusBarHeight(num height) => _box.write(StoreKeys.statusBarHeight.toString(), height);

  num getStatusBarHeight() => _box.read<num>(StoreKeys.statusBarHeight.toString()) ?? 0;

  // 主题风格 默认跟随系统
  setSystemType(ThemeType type) => _box.write(StoreKeys.themeType.toString(), type.name.toString());

  clearSystemType() => _box.remove(StoreKeys.themeType.toString());

  ThemeType getSystemType() {
    var value = _box.read(StoreKeys.themeType.toString());
    ThemeType f = ThemeType.system;
    if (value != null) {
      f = ThemeType.values.firstWhere((e) => e.name.toString() == value);
    }
    return f;
  }

  // 节点地图信息
  setNodeGroup(List data) => _box.write(StoreKeys.nodeGroup.toString(), data);

  List getNodeGroup() => _box.read<List>(StoreKeys.nodeGroup.toString()) ?? [];

  // 所有节点信息
  setAllNodes(List data) => _box.write(StoreKeys.allNodes.toString(), data);

  List getAllNodes() => _box.read<List>(StoreKeys.allNodes.toString()) ?? [];

  // 搜索历史
  setSearchList(List data) => _box.write(StoreKeys.searchList.toString(), data);

  List<String> getSearchList() => List<String>.from(_box.read(StoreKeys.searchList.toString()) ?? []);

  // 阅读历史
  setReadList(List data) => _box.write(StoreKeys.readList.toString(), jsonEncode(data));

  List<Map<String, int>> getReadList() {
    var s = _box.read(StoreKeys.readList.toString());
    if (s != null) {
      return List<Map<String, int>>.from(
        jsonDecode(s).map((item) => Map<String, int>.from(item)),
      );
    }
    return [];
  }

  // 消息通知
  setNoticeOn(bool value) => _box.write(StoreKeys.noticeOn.toString(), value);

  bool getNoticeOn() => _box.read<bool>(StoreKeys.noticeOn.toString()) ?? true;

  // 自动更新
  setAutoUpdate(bool value) => _box.write(StoreKeys.autoUpdate.toString(), value);

  bool getAutoUpdate() => _box.read<bool>(StoreKeys.autoUpdate.toString()) ?? true;

  // 自动更新
  setHighlightOp(bool value) => _box.write(StoreKeys.highlightOp.toString(), value);

  bool getHighlightOp() => _box.read<bool>(StoreKeys.highlightOp.toString()) ?? false;

  // iPad横屏拖拽距离
  setDragOffset(double value) => _box.write(StoreKeys.dragOffset.toString(), value);

  double getDragOffset() => _box.read<double>(StoreKeys.dragOffset.toString()) ?? 0.0;

  //签到时间
  setSignDate(String value) => _box.write(StoreKeys.signDate.toString(), value);

  String getSignDate() => _box.read<String>(StoreKeys.signDate.toString()) ?? '';

  //获取当前用户
  setCurrentMember(Member value) => _box.write(StoreKeys.currentMember.toString(), value.toJson());

  Member? getCurrentMember() {
    var s = _box.read(StoreKeys.currentMember.toString());
    if (s != null) {
      return Member.fromJson(s);
    }
    return null;
  }

  //获取配置
  setConfig(Map<String, UserConfig> configMap) {
    final jsonMap = configMap.map((key, value) => MapEntry(key, value.toJson()));
    _box.write(StoreKeys.config.toString(), jsonMap);
  }

  Map<String, UserConfig>? getConfig() {
    final jsonMap = _box.read<Map<String, dynamic>>(StoreKeys.config.toString());
    if (jsonMap != null) {
      return jsonMap.map((key, value) => MapEntry(key, UserConfig.fromJson(value)));
    }
    return null;
  }

  //获取标签
  setTabMap(List<NodeItem> value) {
    _box.write(StoreKeys.tabMap.toString(), jsonEncode(value));
  }

  List<NodeItem> getTabMap() {
    var r3 = _box.read(StoreKeys.tabMap.toString());
    if (r3 != null) {
      r3 = jsonDecode(r3);
      return (r3 as List).map((v) => NodeItem.fromJson(v)).toList();
    }
    return [];
  }
}
