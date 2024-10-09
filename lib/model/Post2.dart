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

  // factory Member.fromJson(Map<String, dynamic> json) {
  //   // var s = this;
  //   // return s;
  // }
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

  Map<String, dynamic> toJson() => {
        "showTopReply": showTopReply,
      };
}
