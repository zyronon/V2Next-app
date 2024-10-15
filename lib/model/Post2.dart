import 'dart:developer';

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
  List<dynamic> allReplyUsers;
  String contentRendered;
  String createDate;
  String createDateAgo;
  String lastReplyDate;
  String lastReplyDateAgo;
  String lastReplyUsername;
  String fr;
  List<Reply> replyList;
  List<Reply> topReplyList;
  List<Reply> nestedReplies;
  String username;
  String url;
  String href;
  Member member;
  Node node;
  String title;
  String id;
  String type;
  String once;
  String contentHtml;
  String contentText;
  int replyCount;
  int clickCount;
  int thankCount;
  int collectCount;
  int lastReadFloor;
  int totalPage;
  bool isTop;
  bool isFavorite;
  bool isIgnore;
  bool isThanked;
  bool isReport;
  bool inList;
  bool isAppend;
  bool isEdit;
  bool isMove;

  // 构造函数
  Post2({
    this.allReplyUsers = const [],
    this.contentRendered = '',
    this.createDate = '',
    this.createDateAgo = '',
    this.lastReplyDate = '',
    this.lastReplyDateAgo = '',
    this.lastReplyUsername = '',
    this.fr = '',
    this.replyList = const [],
    this.topReplyList = const [],
    this.nestedReplies = const [],
    this.username = '',
    this.url = '',
    this.href = '',
    Member? member, // 使用可选参数
    Node? node,     // 使用可选参数
    this.title = '',
    this.id = '',
    this.type = '',
    this.once = '',
    this.contentHtml = '',
    this.contentText = '',
    this.replyCount = 0,
    this.clickCount = 0,
    this.thankCount = 0,
    this.collectCount = 0,
    this.lastReadFloor = 0,
    this.totalPage = 0,
    this.isTop = false,
    this.isFavorite = false,
    this.isIgnore = false,
    this.isThanked = false,
    this.isReport = false,
    this.inList = false,
    this.isAppend = false,
    this.isEdit = false,
    this.isMove = false,
  })  : member = member ?? Member(), // 如果传入为 null，则赋默认值
        node = node ?? Node();        // 如果传入为 null，则赋默认值

  // fromJson 方法
  Post2.fromJson(Map<String, dynamic> json)
      : allReplyUsers = json['allReplyUsers'] ?? [],
        contentRendered = json['contentRendered'] ?? '',
        createDate = json['createDate'] ?? '',
        createDateAgo = json['createDateAgo'] ?? '',
        lastReplyDate = json['lastReplyDate'] ?? '',
        lastReplyDateAgo = json['lastReplyDateAgo'] ?? '',
        lastReplyUsername = json['lastReplyUsername'] ?? '',
        fr = json['fr'] ?? '',
        replyList = (json['replyList'] as List?)?.map((item) => Reply.fromJson(item)).toList() ?? [],
        topReplyList = (json['topReplyList'] as List?)?.map((item) => Reply.fromJson(item)).toList() ?? [],
        nestedReplies = (json['nestedReplies'] as List?)?.map((item) => Reply.fromJson(item)).toList() ?? [],
        username = json['username'] ?? '',
        url = json['url'] ?? '',
        href = json['href'] ?? '',
        member = json['member'] != null ? Member.fromJson(json['member']) : Member(),
        node = json['node'] != null ? Node.fromJson(json['node']) : Node(),
        title = json['title'] ?? '',
        id = json['id'].toString() ?? '',
        type = json['type'] ?? '',
        once = json['once'] ?? '',
        contentHtml = json['contentHtml'] ?? '',
        contentText = json['contentText'] ?? '',
        replyCount = json['replyCount'] ?? 0,
        clickCount = json['clickCount'] ?? 0,
        thankCount = json['thankCount'] ?? 0,
        collectCount = json['collectCount'] ?? 0,
        lastReadFloor = json['lastReadFloor'] ?? 0,
        totalPage = json['totalPage'] ?? 0,
        isTop = json['isTop'] ?? false,
        isFavorite = json['isFavorite'] ?? false,
        isIgnore = json['isIgnore'] ?? false,
        isThanked = json['isThanked'] ?? false,
        isReport = json['isReport'] ?? false,
        inList = json['inList'] ?? false,
        isAppend = json['isAppend'] ?? false,
        isEdit = json['isEdit'] ?? false,
        isMove = json['isMove'] ?? false;
}

class Member {
  String avatar;
  String username;
  String avatarLarge;
  String balance;
  List<int> actionCounts;

  // 构造函数，带默认值
  Member({
    this.avatar = '',
    this.username = 'default',
    this.avatarLarge = '',
    this.balance = '',
    this.actionCounts = const [],
  });

  // fromJson 方法
  Member.fromJson(Map<String, dynamic> json)
      : avatar = json['avatar'] ?? '',
        username = json['username'] ?? 'default',
        avatarLarge = json['avatarLarge'] ?? '',
        balance = json['balance'] ?? '',
        actionCounts = (json['actionCounts'] as List?)?.map((item) => item as int).toList() ?? [];

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'username': username,
      'avatarLarge': avatarLarge,
      'balance': balance,
      'actionCounts': actionCounts,
    };
  }
}

class Node {
  String title;
  String url;

  // 构造函数，带默认值
  Node({
    this.title = '',
    this.url = '',
  });

  // fromJson 方法
  Node.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        url = json['url'] ?? '';

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
    };
  }
}

class UserConfig {
  bool showTopReply;
  double version;
  String configPrefix;
  String configNoteId;

  // 构造函数，带默认值
  UserConfig({
    this.showTopReply = true,
    this.version = 0.1,
    this.configPrefix = '--mob-config--',
    this.configNoteId = '',
  });

  // fromJson 方法
  UserConfig.fromJson(Map<String, dynamic> json)
      : showTopReply = json['showTopReply'] ?? true,
        version = json['version']?.toDouble() ?? 0.1,
        // 防止类型不匹配时出错
        configPrefix = json['configPrefix'] ?? '--mob-config--',
        configNoteId = json['configNoteId'] ?? '';

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'showTopReply': showTopReply,
      'version': version,
      'configPrefix': configPrefix,
      'configNoteId': configNoteId,
    };
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
  List<Post2> topicList = [];
}

class Result {
  bool success;
  dynamic data;
  String msg;

  Result({this.success = true, this.data = null, this.msg = ''});
}

enum Auth { normal, notAllow }
