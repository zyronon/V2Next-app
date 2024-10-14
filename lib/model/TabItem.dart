import 'package:v2ex/model/Post.dart';

enum TabType { tab, node, recent, latest }

class TabItem {
  String title = '';
  String id = '';
  TabType type = TabType.tab;
  String date = '';
  List<Post> post = [];

  TabItem({required this.title, required this.id, required this.type, required this.date, required this.post});
}
