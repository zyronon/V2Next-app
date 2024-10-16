import 'package:v2ex/model/Post2.dart';

enum TabType { tab, node, recent, latest, hot, xna }

class TabItem {
  String cnName = '';
  String enName = '';
  TabType type = TabType.tab;
  String date = '';
  List<Post2> postList = [];
  bool needAuth = false;

  TabItem({this.cnName = '', this.enName = '', this.type = TabType.tab});
}
