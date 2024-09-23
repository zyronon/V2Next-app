import 'package:v2ex/model/Post.dart';

class TabItem {
  String name;
  String key;
  String date;
  List<Post> post;

  TabItem({required this.name, required this.key, required this.date, required this.post});
}
