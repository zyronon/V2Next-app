import 'package:v2ex/model/Post2.dart';

enum TabType { tab, node, recent, latest, hot, xna }

class TabItem {
  String cnName;
  String enName;
  TabType type;
  String date;
  bool needAuth;

  TabItem({
    this.cnName = '',
    this.enName = '',
    this.type = TabType.tab,
    this.date = '',
    this.needAuth = false,
  });

  // fromJson: 将 JSON 数据转换为 TabItem 对象
  factory TabItem.fromJson(Map<String, dynamic> json) {
    return TabItem(
      cnName: json['cnName'] ?? '',
      enName: json['enName'] ?? '',
      type: TabType.values.firstWhere(
        (e) => e.toString() == 'TabType.${json['type']}',
        orElse: () => TabType.tab,
      ),
      date: json['date'] ?? '',
      needAuth: json['needAuth'] ?? false,
    );
  }

  // toJson: 将 TabItem 对象转换为 JSON 数据
  Map<String, dynamic> toJson() {
    return {
      'cnName': cnName,
      'enName': enName,
      'type': type.toString().split('.').last, // 转为枚举名称字符串
      'date': date,
      'needAuth': needAuth,
    };
  }
}
