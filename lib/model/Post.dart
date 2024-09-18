// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

// To parse this JSON data, do
//
//     final reply = replyFromJson(jsonString);

Reply replyFromJson(String str) => Reply.fromJson(json.decode(str));

String replyToJson(Reply data) => json.encode(data.toJson());

class Reply {
  int? level;
  int? thankCount;
  int? replyCount;
  bool? isThanked;
  bool? isOp;
  bool? isDup;
  String? id;
  String? replyContent;
  String? replyText;
  String? hideCallUserReplyContent;
  List<String>? replyUsers;
  int? replyFloor;
  String? date;
  String? username;
  String? avatar;
  int? floor;
  List<Reply>? children;
  bool? isUse;

  Reply({
    this.level,
    this.thankCount,
    this.replyCount,
    this.isThanked,
    this.isOp,
    this.isDup,
    this.id,
    this.replyContent,
    this.replyText,
    this.hideCallUserReplyContent,
    this.replyUsers,
    this.replyFloor,
    this.date,
    this.username,
    this.avatar,
    this.floor,
    this.children,
    this.isUse,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    level: json["level"],
    thankCount: json["thankCount"],
    replyCount: json["replyCount"],
    isThanked: json["isThanked"],
    isOp: json["isOp"],
    isDup: json["isDup"],
    id: json["id"],
    replyContent: json["reply_content"],
    replyText: json["reply_text"],
    hideCallUserReplyContent: json["hideCallUserReplyContent"],
    replyUsers: json["replyUsers"] == null ? [] : List<String>.from(json["replyUsers"]!.map((x) => x)),
    replyFloor: json["replyFloor"],
    date: json["date"],
    username: json["username"],
    avatar: json["avatar"],
    floor: json["floor"],
    children: json["children"] == null ? [] : List<Reply>.from(json["children"]!.map((x) => Reply.fromJson(x))),
    isUse: json["isUse"],
  );

  Map<String, dynamic> toJson() => {
    "level": level,
    "thankCount": thankCount,
    "replyCount": replyCount,
    "isThanked": isThanked,
    "isOp": isOp,
    "isDup": isDup,
    "id": id,
    "reply_content": replyContent,
    "reply_text": replyText,
    "hideCallUserReplyContent": hideCallUserReplyContent,
    "replyUsers": replyUsers == null ? [] : List<dynamic>.from(replyUsers!.map((x) => x)),
    "replyFloor": replyFloor,
    "date": date,
    "username": username,
    "avatar": avatar,
    "floor": floor,
    "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
    "isUse": isUse,
  };
}

class Post {
  List<dynamic>? allReplyUsers;
  String? contentRendered;
  String? createDate;
  String? createDateAgo;
  String? lastReplyDate;
  String? lastReplyUsername;
  String? fr;
  List<Reply>? replyList;
  List<Reply>? topReplyList;
  List<Reply>? nestedReplies;
  List<Reply>? nestedRedundReplies;
  String? username;
  String? url;
  String? href;
  Member? member;
  Node? node;
  String? headerTemplate;
  String? title;
  String? id;
  String? type;
  String? once;
  int? replyCount;
  int? clickCount;
  int? thankCount;
  int? collectCount;
  int? lastReadFloor;
  bool? isFavorite;
  bool? isIgnore;
  bool? isThanked;
  bool? isReport;
  bool? inList;

  Post({
    this.allReplyUsers,
    this.contentRendered,
    this.createDate,
    this.createDateAgo,
    this.lastReplyDate,
    this.lastReplyUsername,
    this.fr,
    this.replyList,
    this.topReplyList,
    this.nestedReplies,
    this.nestedRedundReplies,
    this.username,
    this.url,
    this.href,
    this.member,
    this.node,
    this.headerTemplate,
    this.title,
    this.id,
    this.type,
    this.once,
    this.replyCount,
    this.clickCount,
    this.thankCount,
    this.collectCount,
    this.lastReadFloor,
    this.isFavorite,
    this.isIgnore,
    this.isThanked,
    this.isReport,
    this.inList,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        allReplyUsers: json["allReplyUsers"] == null ? [] : List<dynamic>.from(json["allReplyUsers"]!.map((x) => x)),
        contentRendered: json["content_rendered"],
        createDate: json["createDate"],
        createDateAgo: json["createDateAgo"],
        lastReplyDate: json["lastReplyDate"],
        lastReplyUsername: json["lastReplyUsername"],
        fr: json["fr"],
        replyList: json["replyList"] == null ? [] : List<Reply>.from(json["replyList"]!.map((x) => Reply.fromJson(x))),
        topReplyList: json["topReplyList"] == null ? [] : List<Reply>.from(json["topReplyList"]!.map((x) => Reply.fromJson(x))),
        nestedReplies: json["nestedReplies"] == null ? [] : List<Reply>.from(json["nestedReplies"]!.map((x) => Reply.fromJson(x))),
        nestedRedundReplies: json["nestedRedundReplies"] == null ? [] : List<Reply>.from(json["nestedRedundReplies"]!.map((x) => Reply.fromJson(x))),
        username: json["username"],
        url: json["url"],
        href: json["href"],
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
        node: json["node"] == null ? null : Node.fromJson(json["node"]),
        headerTemplate: json["headerTemplate"],
        title: json["title"],
        id: json["id"],
        type: json["type"],
        once: json["once"],
        replyCount: json["replyCount"],
        clickCount: json["clickCount"],
        thankCount: json["thankCount"],
        collectCount: json["collectCount"],
        lastReadFloor: json["lastReadFloor"],
        isFavorite: json["isFavorite"],
        isIgnore: json["isIgnore"],
        isThanked: json["isThanked"],
        isReport: json["isReport"],
        inList: json["inList"],
      );

  Map<String, dynamic> toJson() => {
        "allReplyUsers": allReplyUsers == null ? [] : List<dynamic>.from(allReplyUsers!.map((x) => x)),
        "content_rendered": contentRendered,
        "createDate": createDate,
        "createDateAgo": createDateAgo,
        "lastReplyDate": lastReplyDate,
        "lastReplyUsername": lastReplyUsername,
        "fr": fr,
        "replyList": replyList == null ? [] : List<dynamic>.from(replyList!.map((x) => x.toJson())),
        "topReplyList": topReplyList == null ? [] : List<dynamic>.from(topReplyList!.map((x) => x.toJson())),
        "nestedReplies": nestedReplies == null ? [] : List<dynamic>.from(nestedReplies!.map((x) => x.toJson())),
        "nestedRedundReplies": nestedRedundReplies == null ? [] : List<dynamic>.from(nestedRedundReplies!.map((x) => x.toJson())),
        "username": username,
        "url": url,
        "href": href,
        "member": member?.toJson(),
        "node": node?.toJson(),
        "headerTemplate": headerTemplate,
        "title": title,
        "id": id,
        "type": type,
        "once": once,
        "replyCount": replyCount,
        "clickCount": clickCount,
        "thankCount": thankCount,
        "collectCount": collectCount,
        "lastReadFloor": lastReadFloor,
        "isFavorite": isFavorite,
        "isIgnore": isIgnore,
        "isThanked": isThanked,
        "isReport": isReport,
        "inList": inList,
      };
}

class Member {
  String? avatar;
  String? username;
  String? avatarLarge;

  Member({
    this.avatar,
    this.username,
    this.avatarLarge,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        avatar: json["avatar"],
        username: json["username"],
        avatarLarge: json["avatar_large"],
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "username": username,
        "avatar_large": avatarLarge,
      };
}

class Node {
  String? title;
  String? url;

  Node({
    this.title,
    this.url,
  });

  factory Node.fromJson(Map<String, dynamic> json) => Node(
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
      };
}
