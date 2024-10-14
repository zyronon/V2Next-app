import 'package:v2ex/model/Post2.dart';

enum TabType { tab, node, recent, latest }

class TabItem {
  String title = '';
  String id = '';
  TabType type = TabType.tab;
  String date = '';
  List<Post2> postList = [];
  bool needAuth = false;

  TabItem({this.title = '', this.id = '', this.type = TabType.tab});
}
