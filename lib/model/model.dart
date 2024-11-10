import 'dart:developer';

enum ReplyListType {
  Hot, //高赞回复
  Normal, //正常回复
}

class Reply {
  int level = 0;
  int thankCount = 0;
  int replyCount = 0;
  bool isThanked = false;
  bool isOp = false;
  bool isMod = false;
  bool isUse = false;
  bool isChoose = false;
  bool isWrong = false;
  int replyId = 0;
  String replyContent = '';
  String replyText = '';
  String hideCallUserReplyContent = '';
  List<String> replyUsers = [];
  int replyFloor = 0;
  String date = '';
  String platform = '';
  String username = '';
  String avatar = '';
  int floor = -1;
  List<Reply> children = [];

  Map<String, dynamic> toJson() => {
        "level": level,
        "thankCount": thankCount,
        "replyCount": replyCount,
        "isThanked": isThanked,
        "isOp": isOp,
        "isMod": isMod,
        "isUse": isUse,
        "isChoose": isChoose,
        "isWrong": isWrong,
        "replyId": replyId,
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
    s.isUse = json["isUse"];
    s.isWrong = json["isWrong"];
    s.isChoose = json["isChoose"];
    s.replyId = json["replyId"];
    s.replyContent = json["replyContent"] ?? '';
    s.replyText = json["replyText"] ?? '';
    s.hideCallUserReplyContent = json["hideCallUserReplyContent"] ?? '';
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

  @override
  bool operator ==(Object other) => other is Reply && other.username == username;

  @override
  int get hashCode => username.hashCode;
}

class Post {
  List<dynamic> allReplyUsers;
  String contentRendered;
  String contentText;
  String createDate;
  String createDateAgo;
  String lastReplyDate;
  String lastReplyDateAgo;
  String lastReplyUsername;
  List<Reply> replyList;
  List<Reply> hotReplyList;
  List<Reply> newReplyList;
  List<Reply> topReplyList;
  List<Reply> nestedReplies;

  Member member;
  V2Node node;
  String title;
  int postId;
  int replyCount;
  int clickCount;
  int thankCount;
  int collectCount;
  bool isTop;
  bool isFavorite;
  bool isIgnore;
  bool isThanked;
  bool isReport;
  bool isAppend;
  bool isEdit;
  bool isMove;

  // 构造函数
  Post({
    this.allReplyUsers = const [],
    this.createDate = '',
    this.createDateAgo = '',
    this.lastReplyDate = '',
    this.lastReplyDateAgo = '',
    this.lastReplyUsername = '',
    this.replyList = const [],
    this.hotReplyList = const [],
    this.newReplyList = const [],
    this.topReplyList = const [],
    this.nestedReplies = const [],
    Member? member, // 使用可选参数
    V2Node? node, // 使用可选参数
    this.title = '',
    this.postId = 0,
    this.contentRendered = '',
    this.contentText = '',
    this.replyCount = 0,
    this.clickCount = 0,
    this.thankCount = 0,
    this.collectCount = 0,
    this.isTop = false,
    this.isFavorite = false,
    this.isIgnore = false,
    this.isThanked = false,
    this.isReport = false,
    this.isAppend = false,
    this.isEdit = false,
    this.isMove = false,
  })  : member = member ?? Member(),
        // 如果传入为 null，则赋默认值
        node = node ?? V2Node();

  Post.fromJson(Map<String, dynamic> json)
      : allReplyUsers = json['allReplyUsers'] ?? [],
        contentRendered = json['contentRendered'] ?? '',
        createDate = json['createDate'] ?? '',
        createDateAgo = json['createDateAgo'] ?? '',
        lastReplyDate = json['lastReplyDate'] ?? '',
        lastReplyDateAgo = json['lastReplyDateAgo'] ?? '',
        lastReplyUsername = json['lastReplyUsername'] ?? '',
        replyList = (json['replyList'] as List?)?.map((item) => Reply.fromJson(item)).toList() ?? [],
        topReplyList = [],
        hotReplyList = [],
        newReplyList = [],
        nestedReplies = [],
        member = json['member'] != null ? Member.fromJson(json['member']) : Member(),
        node = json['node'] != null ? V2Node.fromJson(json['node']) : V2Node(),
        title = json['title'] ?? '',
        postId = json['postId'] ?? '',
        contentText = json['contentText'] ?? '',
        replyCount = json['replyCount'] ?? 0,
        clickCount = json['clickCount'] ?? 0,
        thankCount = json['thankCount'] ?? 0,
        collectCount = json['collectCount'] ?? 0,
        isTop = json['isTop'] ?? false,
        isFavorite = json['isFavorite'] ?? false,
        isIgnore = json['isIgnore'] ?? false,
        isThanked = json['isThanked'] ?? false,
        isReport = json['isReport'] ?? false,
        isAppend = json['isAppend'] ?? false,
        isEdit = json['isEdit'] ?? false,
        isMove = json['isMove'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'allReplyUsers': allReplyUsers,
      'contentRendered': contentRendered,
      'contentText': contentText,
      'createDate': createDate,
      'createDateAgo': createDateAgo,
      'lastReplyDate': lastReplyDate,
      'lastReplyDateAgo': lastReplyDateAgo,
      'lastReplyUsername': lastReplyUsername,
      'replyList': replyList.map((item) => item.toJson()).toList(),
      'topReplyList': [],
      'hotReplyList': [],
      'newReplyList': [],
      'nestedReplies': [],
      'member': member.toJson(),
      'node': node.toJson(),
      'title': title,
      'postId': postId,
      'replyCount': replyCount,
      'clickCount': clickCount,
      'thankCount': thankCount,
      'collectCount': collectCount,
      'isTop': isTop,
      'isFavorite': isFavorite,
      'isIgnore': isIgnore,
      'isThanked': isThanked,
      'isReport': isReport,
      'isAppend': isAppend,
      'isEdit': isEdit,
      'isMove': isMove,
    };
  }
}

class Member {
  String avatar;
  String username;
  String avatarLarge;
  String balance;
  bool needAuth2fa;
  Map tagMap;

  //依次是节点、主题、特别关注
  List<int> actionCounts;

  // 构造函数，带默认值
  Member({
    this.avatar = '',
    this.username = 'default',
    this.avatarLarge = '',
    this.balance = '',
    this.actionCounts = const [0, 0, 0],
    this.needAuth2fa = false,
    Map? tagMap,
  }) : tagMap = tagMap ?? {};

  // fromJson 方法
  Member.fromJson(Map<String, dynamic> json)
      : avatar = json['avatar'] ?? '',
        username = json['username'] ?? 'default',
        avatarLarge = json['avatarLarge'] ?? '',
        balance = json['balance'] ?? '',
        needAuth2fa = json['needAuth2fa'] ?? false,
        tagMap = json['tagMap'] ?? {},
        actionCounts = (json['actionCounts'] as List?)?.map((item) => item as int).toList() ?? [0, 0, 0];

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'username': username,
      'avatarLarge': avatarLarge,
      'balance': balance,
      'actionCounts': actionCounts,
      'needAuth2fa': needAuth2fa,
      'tagMap': tagMap,
    };
  }
}

class V2Node {
  String cnName;
  String enName;

  // 构造函数，带默认值
  V2Node({
    this.cnName = '',
    this.enName = '',
  });

  // fromJson 方法
  V2Node.fromJson(Map<String, dynamic> json)
      : cnName = json['title'] ?? '',
        enName = json['url'] ?? '';

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'title': cnName,
      'url': enName,
    };
  }
}

class Layout {
  double fontSize;
  double lineHeight;

  // double paragraphHeight;

  Layout({
    this.fontSize = 16,
    this.lineHeight = 1.4,
    // this.paragraphHeight = 1.1,
  });

  // fromJson 方法
  Layout.fromJson(Map<String, dynamic> json)
      : fontSize = json['fontSize']?.toDouble() ?? 16,
        lineHeight = json['lineHeight'].toDouble() ?? 1.4;

  // paragraphHeight = json['paragraphHeight'].toDouble() ?? 1.1;

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'lineHeight': lineHeight,
      // 'paragraphHeight': paragraphHeight,
    };
  }
}

enum CommentDisplayType {
  Nest, //楼中楼（隐藏第一个@用户，双击内容可显示原文）
  NestAndCall, //楼中楼（@）
  Hot, //感谢，最热
  Origin, //V2原版
  Op, //只看楼主
  New, //最新
}

class UserConfig {
  bool showTopReply;
  bool openTag;
  bool replaceImgur;
  bool ignoreThankConfirm;
  double version;
  String configNoteId;
  String tagNoteId;
  Layout layout;
  CommentDisplayType commentDisplayType;

  // 构造函数，带默认值
  UserConfig({
    this.showTopReply = true,
    this.openTag = true,
    this.replaceImgur = false,
    this.ignoreThankConfirm = false,
    this.version = 0.1,
    this.configNoteId = '',
    this.tagNoteId = '',
    Layout? layout,
    CommentDisplayType? commentDisplayType,
  })  : layout = layout ?? Layout(),
        commentDisplayType = commentDisplayType ?? CommentDisplayType.Nest;

  // fromJson 方法
  UserConfig.fromJson(Map<String, dynamic> json)
      : showTopReply = json['showTopReply'] ?? true,
        openTag = json['openTag'] ?? true,
        replaceImgur = json['replaceImgur'] ?? false,
        ignoreThankConfirm = json['ignoreThankConfirm'] ?? false,
        version = json['version']?.toDouble() ?? 0.1,
        // 防止类型不匹配时出错
        layout = json['layout'] != null ? Layout.fromJson(json['layout']) : Layout(),
        configNoteId = json['configNoteId'] ?? '',
        tagNoteId = json['tagNoteId'] ?? '',
        commentDisplayType = CommentDisplayType.values.firstWhere(
          (e) => e.toString() == 'CommentDisplayType.${json['commentDisplayType'] ?? ''}',
          orElse: () => CommentDisplayType.Nest,
        );

  // toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'showTopReply': showTopReply,
      'openTag': openTag,
      'replaceImgur': replaceImgur,
      'ignoreThankConfirm': ignoreThankConfirm,
      'version': version,
      'configNoteId': configNoteId,
      'tagNoteId': tagNoteId,
      'layout': layout.toJson(),
      'commentDisplayType': commentDisplayType.toString(),
    };
  }
}

class NodeListModel {
  String nodeId = ''; // 节点id
  String nodeEnName = ''; // 节点url
  String nodeCnName = ''; // 节点名称
  String nodeIntro = ''; // 节点描述
  String topicCount = ''; // 主题数量
  bool isFavorite = false; // 是否收藏节点
  int favoriteCount = 0; // 收藏人数
  int totalPage = 1; // 总页数
  String nodeCover = ''; // 封面
  List<Post> topicList = [];
}

class Result {
  bool success;
  dynamic data;
  String msg;

  Result({this.success = true, this.data = null, this.msg = ''});
}

enum Auth { normal, notAllow }

enum FromSource { search, editTab, move }

enum NoticeType { reply, thanksTopic, thanksReply, favTopic } // 消息类型

class MemberNoticeModel {
  int totalPage = 1; // 总页数
  int totalCount = 0; // 总条目
  List<MemberNoticeItem> noticeList = []; // 消息列表
  bool isEmpty = false; // 无内容
}

class MemberNoticeItem {
  String memberId = ''; // 回复用户id
  String memberAvatar = ''; // 回复用户头像
  String replyContent = ''; // 回复内容
  var replyContentHtml;
  List<String> replyMemberId = []; // 被回复id
  String replyTime = ''; // 回复时间
  String topicTitle = ''; // 主题标题
  var topicTitleHtml; // 主题标题
  int topicId = 0; // 主题id
  String delIdOne = ''; // 删除id
  String delIdTwo = ''; // 删除id
  NoticeType noticeType = NoticeType.reply; // 消息类型 可枚举
  String topicHref = ''; // 主题href  /t/923791#reply101
}

class NodeFavModel {
  String nodeCover = ''; // 节点图标
  String nodeName = ''; // 节点 名称
  String nodeId = ''; // 节点id
  String topicCount = ''; // 节点主题数量
}

class TopicNodeItem {
  int? topics = 0;
  List? aliases = [];
  String? name = "";
  String? title = "";

  TopicNodeItem({
    this.topics,
    this.aliases,
    this.name,
    this.title,
  });

  TopicNodeItem.fromJson(Map<String, dynamic> json) {
    topics = json['topics'];
    aliases = json['aliases'];
    name = json['name'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['topics'] = topics;
    data['aliases'] = aliases;
    data['name'] = name;
    data['title'] = title;

    return data;
  }
}
