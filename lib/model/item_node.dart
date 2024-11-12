import 'package:v2ex/model/model.dart';

enum TabType { tab, node, recent, latest, hot, xna }

class NodeItem {
  int id = 0;
  int stars = 0; //收藏数
  int topics = 0; // 主题数
  int totalPage = 1; // 总页数
  String url = '';
  String name = ''; // 节点名
  String title = ''; // 展示使用
  String header = ''; // 节点
  String footer = '';
  bool isFavorite = false; // 是否收藏节点
  String avatar = '';
  String avatarMini = '';
  String avatarLarge = '';
  String avatarNormal = '';
  String parentNodeName = ''; // 父节点名
  String titleAlternative = ''; // 好像没什么用
  List<Post> postList = [];
  TabType type = TabType.tab;

  NodeItem({
    this.id = 0,
    this.stars = 0,
    this.topics = 0,
    this.totalPage = 1,
    this.url = '',
    this.name = '',
    this.title = '',
    this.header = '',
    this.footer = '',
    this.isFavorite = false,
    this.avatar = '',
    this.avatarMini = '',
    this.avatarLarge = '',
    this.avatarNormal = '',
    this.parentNodeName = '',
    this.titleAlternative = '',
    this.postList = const [],
    TabType? type,
  }) : this.type = type ?? TabType.tab;

  NodeItem.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    stars = json['stars'] ?? 0;
    topics = json['topics'] ?? 0;
    url = json['url'] ?? '';
    name = json['name'] ?? '';
    title = json['title'] ?? '';
    header = json['header'] ?? '';
    footer = json['footer'] ?? '';
    isFavorite = json['isFavorite'] ?? false;
    avatar = json['avatar'] ?? '';
    avatarMini = json['avatar_mini'] ?? '';
    avatarLarge = json['avatar_large'] ?? '';
    avatarNormal = json['avatar_normal'] ?? '';
    parentNodeName = json['parent_node_name'] ?? '';
    titleAlternative = json['title_alternative'] ?? '';
    type = TabType.values.firstWhere(
      (e) => e.toString() == 'TabType.${json['type'] ?? ''}',
      orElse: () => TabType.tab,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stars'] = stars;
    data['topics'] = topics;
    data['url'] = url;
    data['name'] = name;
    data['title'] = title;
    data['header'] = header;
    data['footer'] = footer;
    data['isFavorite'] = isFavorite;
    data['avatar'] = avatar;
    data['avatar_mini'] = avatarMini;
    data['avatar_large'] = avatarLarge;
    data['avatar_normal'] = avatarNormal;
    data['parent_node_name'] = parentNodeName;
    data['title_alternative'] = titleAlternative;
    data['type'] = type.toString();
    return data;
  }
}
