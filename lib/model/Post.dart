// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  List<dynamic> allReplyUsers;
  String contentRendered;
  String createDate;
  String createDateAgo;
  String lastReplyDate;
  String lastReplyUsername;
  String fr;
  List<dynamic> replyList;
  List<dynamic> topReplyList;
  List<NestedReply> nestedReplies;
  List<dynamic> nestedRedundReplies;
  String username;
  String url;
  String href;
  Member member;
  Node node;
  String headerTemplate;
  String title;
  String id;
  String type;
  String once;
  int replyCount;
  int clickCount;
  int thankCount;
  int collectCount;
  int lastReadFloor;
  bool isFavorite;
  bool isIgnore;
  bool isThanked;
  bool isReport;
  bool inList;

  Post({
    required this.allReplyUsers,
    required this.contentRendered,
    required this.createDate,
    required this.createDateAgo,
    required this.lastReplyDate,
    required this.lastReplyUsername,
    required this.fr,
    required this.replyList,
    required this.topReplyList,
    required this.nestedReplies,
    required this.nestedRedundReplies,
    required this.username,
    required this.url,
    required this.href,
    required this.member,
    required this.node,
    required this.headerTemplate,
    required this.title,
    required this.id,
    required this.type,
    required this.once,
    required this.replyCount,
    required this.clickCount,
    required this.thankCount,
    required this.collectCount,
    required this.lastReadFloor,
    required this.isFavorite,
    required this.isIgnore,
    required this.isThanked,
    required this.isReport,
    required this.inList,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    allReplyUsers: List<dynamic>.from(json["allReplyUsers"].map((x) => x)),
    contentRendered: json["content_rendered"],
    createDate: json["createDate"],
    createDateAgo: json["createDateAgo"],
    lastReplyDate: json["lastReplyDate"],
    lastReplyUsername: json["lastReplyUsername"],
    fr: json["fr"],
    replyList: List<dynamic>.from(json["replyList"].map((x) => x)),
    topReplyList: List<dynamic>.from(json["topReplyList"].map((x) => x)),
    nestedReplies: List<NestedReply>.from(json["nestedReplies"].map((x) => NestedReply.fromJson(x))),
    nestedRedundReplies: List<dynamic>.from(json["nestedRedundReplies"].map((x) => x)),
    username: json["username"],
    url: json["url"],
    href: json["href"],
    member: Member.fromJson(json["member"]),
    node: Node.fromJson(json["node"]),
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
    "allReplyUsers": List<dynamic>.from(allReplyUsers.map((x) => x)),
    "content_rendered": contentRendered,
    "createDate": createDate,
    "createDateAgo": createDateAgo,
    "lastReplyDate": lastReplyDate,
    "lastReplyUsername": lastReplyUsername,
    "fr": fr,
    "replyList": List<dynamic>.from(replyList.map((x) => x)),
    "topReplyList": List<dynamic>.from(topReplyList.map((x) => x)),
    "nestedReplies": List<dynamic>.from(nestedReplies.map((x) => x.toJson())),
    "nestedRedundReplies": List<dynamic>.from(nestedRedundReplies.map((x) => x)),
    "username": username,
    "url": url,
    "href": href,
    "member": member.toJson(),
    "node": node.toJson(),
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
  String avatar;
  Username username;
  String avatarLarge;

  Member({
    required this.avatar,
    required this.username,
    required this.avatarLarge,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    avatar: json["avatar"],
    username: usernameValues.map[json["username"]]!,
    avatarLarge: json["avatar_large"],
  );

  Map<String, dynamic> toJson() => {
    "avatar": avatar,
    "username": usernameValues.reverse[username],
    "avatar_large": avatarLarge,
  };
}

enum Username {
  EARSUM,
  KILLGFAT,
  WHAT_THE_BRIDGE_SAY
}

final usernameValues = EnumValues({
  "Earsum": Username.EARSUM,
  "killgfat": Username.KILLGFAT,
  "WhatTheBridgeSay": Username.WHAT_THE_BRIDGE_SAY
});

class NestedReply {
  int level;
  int thankCount;
  int replyCount;
  bool isThanked;
  bool isOp;
  bool isDup;
  String id;
  String replyContent;
  String replyText;
  String hideCallUserReplyContent;
  List<dynamic> replyUsers;
  int replyFloor;
  String date;
  String username;
  String avatar;
  int floor;
  List<Child> children;

  NestedReply({
    required this.level,
    required this.thankCount,
    required this.replyCount,
    required this.isThanked,
    required this.isOp,
    required this.isDup,
    required this.id,
    required this.replyContent,
    required this.replyText,
    required this.hideCallUserReplyContent,
    required this.replyUsers,
    required this.replyFloor,
    required this.date,
    required this.username,
    required this.avatar,
    required this.floor,
    required this.children,
  });

  factory NestedReply.fromJson(Map<String, dynamic> json) => NestedReply(
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
    replyUsers: List<dynamic>.from(json["replyUsers"].map((x) => x)),
    replyFloor: json["replyFloor"],
    date: json["date"],
    username: json["username"],
    avatar: json["avatar"],
    floor: json["floor"],
    children: List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
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
    "replyUsers": List<dynamic>.from(replyUsers.map((x) => x)),
    "replyFloor": replyFloor,
    "date": date,
    "username": username,
    "avatar": avatar,
    "floor": floor,
    "children": List<dynamic>.from(children.map((x) => x.toJson())),
  };
}

class Child {
  int level;
  int thankCount;
  int replyCount;
  bool isThanked;
  bool isOp;
  bool isDup;
  String id;
  String replyContent;
  String replyText;
  String hideCallUserReplyContent;
  List<String> replyUsers;
  int replyFloor;
  String date;
  Username username;
  String avatar;
  int floor;
  bool? isWrong;
  bool isUse;
  List<Child> children;

  Child({
    required this.level,
    required this.thankCount,
    required this.replyCount,
    required this.isThanked,
    required this.isOp,
    required this.isDup,
    required this.id,
    required this.replyContent,
    required this.replyText,
    required this.hideCallUserReplyContent,
    required this.replyUsers,
    required this.replyFloor,
    required this.date,
    required this.username,
    required this.avatar,
    required this.floor,
    this.isWrong,
    required this.isUse,
    required this.children,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
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
    replyUsers: List<String>.from(json["replyUsers"].map((x) => x)),
    replyFloor: json["replyFloor"],
    date: json["date"],
    username: usernameValues.map[json["username"]]!,
    avatar: json["avatar"],
    floor: json["floor"],
    isWrong: json["isWrong"],
    isUse: json["isUse"],
    children: List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
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
    "replyUsers": List<dynamic>.from(replyUsers.map((x) => x)),
    "replyFloor": replyFloor,
    "date": date,
    "username": usernameValues.reverse[username],
    "avatar": avatar,
    "floor": floor,
    "isWrong": isWrong,
    "isUse": isUse,
    "children": List<dynamic>.from(children.map((x) => x.toJson())),
  };
}

class Node {
  String title;
  String url;

  Node({
    required this.title,
    required this.url,
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
