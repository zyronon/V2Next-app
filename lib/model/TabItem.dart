import 'package:v2ex/model/Post.dart';

class TabItem {
  String title;
  String node;
  String date;
  List<Post> post;

  TabItem({required this.title, required this.node, required this.date, required this.post});
}
