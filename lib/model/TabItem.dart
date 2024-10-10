import 'package:v2ex/model/Post.dart';

class TabItem {
  String title = '';
  String id = '';
  String type = '';
  String date = '';
  List<Post> post = [];

  TabItem({required this.title, required this.id, required this.type,required this.date, required this.post});
}
