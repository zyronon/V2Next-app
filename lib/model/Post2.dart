class Reply {
  int level = 0;
  int thankCount = 0;
  int replyCount = 0;
  bool isThanked = false;
  bool isOp = false;
  bool isMod = false;
  bool isDup = false;
  bool isUse = false;
  bool isWrong = false;
  String id = '';
  String replyContent = '';
  String replyText = '';
  String hideCallUserReplyContent = '';
  List<String> replyUsers = [];
  int replyFloor = 0;
  String date = '';
  String platform = '';
  String username = '';
  String avatar = '';
  int floor = 0;
  List<Reply> children = [];

  Map<String, dynamic> toJson() => {
        "level": level,
        "thankCount": thankCount,
        "replyCount": replyCount,
        "isThanked": isThanked,
        "isOp": isOp,
        "isMod": isMod,
        "isDup": isDup,
        "isUse": isUse,
        "isWrong": isWrong,
        "id": id,
        "reply_content": replyContent,
        "reply_text": replyText,
        "hideCallUserReplyContent": hideCallUserReplyContent,
        "replyUsers": replyUsers.isEmpty ? [] : List<String>.from(replyUsers.map((x) => x)),
        "replyFloor": replyFloor,
        "date": date,
        "platform": platform,
        "username": username,
        "avatar": avatar,
        "floor": floor,
        "children": children.isEmpty ? [] : List.from(children.map((x) => x.toJson())),
      };

  static Reply fromJson(Map<String, dynamic> json) {
    Reply s = Reply();
    s.level = json["level"];
    s.thankCount = json["thankCount"];
    s.replyCount = json["replyCount"];
    s.isThanked = json["isThanked"];
    s.isOp = json["isOp"];
    s.isMod = json["isMod"];
    s.isDup = json["isDup"];
    s.isUse = json["isUse"];
    s.isWrong = json["isWrong"];
    s.id = json["id"];
    s.replyContent = json["reply_content"];
    s.replyText = json["reply_text"];
    s.hideCallUserReplyContent = json["hideCallUserReplyContent"];
    s.replyUsers = json["replyUsers"] == null ? [] : List<String>.from(json["replyUsers"]!.map((x) => x));
    s.replyFloor = json["replyFloor"];
    s.date = json["date"];
    s.platform = json["platform"];
    s.username = json["username"];
    s.avatar = json["avatar"];
    s.floor = json["floor"];
    s.children = json["children"] == null ? [] : List.from(json["children"]!.map((x) => Reply.fromJson(x)));
    return s;
  }
}

class Post2 {
  List<dynamic> allReplyUsers = [];
  String contentRendered = '';
  String createDate = '';
  String createDateAgo = '';
  String lastReplyDate = '';
  String lastReplyUsername = '';
  String fr = '';
  List<Reply> replyList = [];
  List<Reply> topReplyList = [];
  List<Reply> nestedReplies = [];
  String username = '';
  String url = '';
  String href = '';
  Member member = Member();
  Node node = Node();
  String title = '';
  String id = '';
  String type = '';
  String once = '';
  String headerTemplate = '';
  int replyCount = 0;
  int clickCount = 0;
  int thankCount = 0;
  int collectCount = 0;
  int lastReadFloor = 0;
  int totalPage = 0;
  bool isFavorite = false;
  bool isIgnore = false;
  bool isThanked = false;
  bool isReport = false;
  bool inList = false;
  bool isAppend = false;
  bool isEdit = false;
  bool isMove = false;
}

class Member {
  String avatar = '';
  String username = 'default';
  String avatarLarge = '';

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "username": username,
        "avatar_large": avatarLarge,
      };

  static fromJson(Map<String, dynamic> json) {
    Member s = Member();
    s.avatar = json['avatar'] ?? s.avatar;
    s.username = json['username'] ?? s.username;
    s.avatarLarge = json['avatarLarge'] ?? s.avatarLarge;
    return s;
  }
}

class Node {
  String title = '';
  String url = '';

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
      };
}

class UserConfig {
  bool showTopReply = true;
  double version = 0.1;

  // String tagPrefix = '--mob-tag--';
  String configPrefix = '--mob-config--';
  String configNoteId = '';

  Map<String, dynamic> toJson() => {
        "showTopReply": showTopReply,
        "configPrefix": configPrefix,
        "configNoteId": configNoteId,
        "version": version,
      };

  static fromJson(Map<String, dynamic> json) {
    UserConfig s = UserConfig();
    s.showTopReply = json['showTopReply'] ?? false;
    s.configPrefix = json['configPrefix'] ?? s.configPrefix;
    s.configNoteId = json['configNoteId'] ?? '';
    s.version = json['version'] ?? s.version;
    return s;
  }
}

class NodeListModel {
  String nodeId = ''; // 节点id
  String nodeName = ''; // 节点名称
  String nodeIntro = ''; // 节点描述
  String topicCount = ''; // 主题数量
  bool isFavorite = false; // 是否收藏节点
  int favoriteCount = 0; // 收藏人数
  int totalPage = 1; // 总页数
  String nodeCover = ''; // 封面

  late List<Post2> topicList;
}

class Result {
  bool success;
  var data;
  String? msg;

  Result({required this.success, this.data, this.msg});
}
