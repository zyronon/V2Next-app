import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:v2next/model/model.dart';

export '';

enum ThemeType { light, dark, system } // 主题切换

class Agent {
  String pc = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36';
  String ios = 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1';
  String android = 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36';
// String android = 'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.114 Mobile Safari/537.36';
}

class Const {
  static Agent agent = new Agent();
  static String v2Hot = 'https://v2hotlist.vercel.app';
  static String home = 'https://v2ex-script.vercel.app/';
  static String v2exHost = 'https://www.v2ex.com';
  static String git = 'https://github.com/zyronon/V2Next';
  static String gitName = 'zyronon/V2Next';
  static String issues = 'https://github.com/zyronon/V2Next/issues';
  static String imgurProxy = 'https://img.noobzone.ru/getimg.php?url=';

  /// 提交tag时 记得更改
  static String currentVersion = 'v1.0.2';

  static String configPrefix = '--mob-config--';
  static String tagPrefix = '--用户标签--';

  static Color primaryColor = Color(0xff48a24a);
  static Color bg = Colors.grey.withOpacity(0.2);
  static Color line = Color(0xfff1f1f1);
  static Color line2 = Color(0xffe1e1e1);
  static Widget lineWidget = Divider(color: Const.line, height: 1);
  static double padding = 10.w;
  static PreferredSizeWidget baseAppbar = AppBar(elevation: 0, toolbarHeight: 0);
  static EdgeInsetsGeometry paddingWidget = EdgeInsets.all(padding);
  static BorderRadiusGeometry borderRadiusWidget = BorderRadius.circular(10.r);
  static BorderRadiusGeometry cardRadius = BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r));
  static BoxShadow boxShadowTop = BoxShadow(
    color: Colors.grey.withOpacity(0.1), // 阴影颜色
    spreadRadius: 1, // 扩散半径
    blurRadius: 10, // 模糊半径
    offset: Offset(0, -2), // 阴影偏移量 (x, y)
  );
  static BoxShadow boxShadowBottom = BoxShadow(
    color: Colors.grey.withOpacity(0.1), // 阴影颜色
    spreadRadius: 1, // 扩散半径
    blurRadius: 10, // 模糊半径
    offset: Offset(0, 2), // 阴影偏移量 (x, y)
  );

  // 所有节点
  static String allNodes = '/api/nodes/all.json';
  static String allNodes1 = 'v22043nextSIGN!';

  // 所有节点 ,可排序
  static String allNodesBySort = '/api/nodes/list.json';

  static List<NodeItem> defaultTabList = [
    new NodeItem(title: '最热', name: 'hot', type: TabType.hot),
    new NodeItem(title: '最近', name: 'recent', type: TabType.recent),
    new NodeItem(title: '最新', name: 'new', type: TabType.latest),
    new NodeItem(title: '全部', name: 'all', type: TabType.tab),
    // new NodeItem(title: '沙盒', name: 'sandbox', type: TabType.node),
    // new NodeItem(title: '水深火热', name: 'flamewar', type: TabType.node),
    new NodeItem(title: '技术', name: 'tech', type: TabType.tab),
    new NodeItem(title: '创意', name: 'creative', type: TabType.tab),
    new NodeItem(title: '好玩', name: 'play', type: TabType.tab),
    new NodeItem(title: 'Apple', name: 'apple', type: TabType.tab),
    new NodeItem(title: '酷工作', name: 'jobs', type: TabType.tab),
    new NodeItem(title: '交易', name: 'deals', type: TabType.tab),
    new NodeItem(title: '城市', name: 'city', type: TabType.tab),
    new NodeItem(title: '问与答', name: 'qna', type: TabType.tab),
    new NodeItem(title: 'R2', name: 'r2', type: TabType.tab),
    new NodeItem(title: '节点', name: 'nodes', type: TabType.tab),
    new NodeItem(title: '关注', name: 'members', type: TabType.tab),
  ];

// static Color primaryColor = Color(0xff07c160);

  /** 表情数据 */
  static List<Map<String, String>> classicsEmoticons = [
    {"name": '狗头', "low": 'https://i.imgur.com/io2SM1h.png', "high": 'https://i.imgur.com/0icl60r.png'},
    {"name": 'doge', "low": 'https://i.imgur.com/duWRpIu.png', "high": 'https://i.imgur.com/HyphI6d.png'},
    {"name": '受虐滑稽', "low": 'https://i.imgur.com/Iy0taMy.png', "high": 'https://i.imgur.com/PS1pxd9.png'},
    {"name": '马', "low": 'https://i.imgur.com/8EKZv7I.png', "high": 'https://i.imgur.com/ANFUX52.png'},
    {"name": '二哈', "low": 'https://i.imgur.com/XKj1Tkx.png', "high": 'https://i.imgur.com/dOeP4XD.png'},
    {"name": '舔屏', "low": 'https://i.imgur.com/Cvl7dyN.png', "high": 'https://i.imgur.com/LmETy9N.png'},
    {"name": '辣眼睛', "low": 'https://i.imgur.com/cPNPYD5.png', "high": 'https://i.imgur.com/3fSUmi8.png'},
    {"name": '吃瓜', "low": 'https://i.imgur.com/ee8Lq7H.png', "high": 'https://i.imgur.com/0L26og9.png'},
    {"name": '不高兴', "low": 'https://i.imgur.com/huX6coX.png', "high": 'https://i.imgur.com/N7JEuvc.png'},
    // {
    //   "name": '呵呵',
    //   "low": 'https://i.imgur.com/RvoLAbX.png',
    //   "high": 'https://i.imgur.com/xSzIqrK.png'
    // },
    {"name": '真棒', "low": 'https://i.imgur.com/xr1UOz1.png', "high": 'https://i.imgur.com/w8YEw9Q.png'},
    {"name": '鄙视', "low": 'https://i.imgur.com/u6jlqVq.png', "high": 'https://i.imgur.com/8JFNANq.png'},
    {"name": '疑问', "low": 'https://i.imgur.com/F29pmQ6.png', "high": 'https://i.imgur.com/EbbTQAR.png'},
    {"name": '吐舌', "low": 'https://i.imgur.com/InmIzl9.png', "high": 'https://i.imgur.com/Ovj56Cd.png'},
    // {
    //   "name": '嘲笑',
    //   "low": 'https://i.imgur.com/BaWcsMR.png',
    //   "high": 'https://i.imgur.com/0OGfJw4.png'
    // },
    // {
    //   "name": '滑稽',
    //   "low": 'https://i.imgur.com/lmbN0yI.png',
    //   "high": 'https://i.imgur.com/Pc0wH85.png'
    // },
    {"name": '笑眼', "low": 'https://i.imgur.com/ZveiiGy.png', "high": 'https://i.imgur.com/PI1CfEr.png'},
    // {
    //   "name": '狂汗',
    //   "low": 'https://i.imgur.com/veWihk6.png',
    //   "high": 'https://i.imgur.com/3LtHdQv.png'
    // },
    {"name": '大哭', "low": 'https://i.imgur.com/hu4oR6C.png', "high": 'https://i.imgur.com/b4X9XLE.png'},
    {"name": '喷', "low": 'https://i.imgur.com/bkw3VRr.png', "high": 'https://i.imgur.com/wnZL13L.png'},
    {"name": '苦笑', "low": 'https://i.imgur.com/VUWFktU.png', "high": 'https://i.imgur.com/NAfspZ1.png'},
    {"name": '喝酒', "low": 'https://i.imgur.com/2ZZSapE.png', "high": 'https://i.imgur.com/rVbSVak.png'},

    {"name": '捂脸', "low": 'https://i.imgur.com/krir4IG.png', "high": 'https://i.imgur.com/qqBqgVm.png'},
    // {
    //   "name": '呕',
    //   "low": 'https://i.imgur.com/6CUiUxv.png',
    //   "high": 'https://i.imgur.com/kgdxRsG.png'
    // },
    {"name": '阴险', "low": 'https://i.imgur.com/MA8YqTP.png', "high": 'https://i.imgur.com/e94jbaT.png'},
    {"name": '怒', "low": 'https://i.imgur.com/n4kWfGB.png', "high": 'https://i.imgur.com/iMXxNxh.png'},
    // {
    //   "name": '衰',
    //   "low": 'https://i.imgur.com/voHFDyQ.png',
    //   "high": 'https://i.imgur.com/XffE6gu.png'
    // },
    // {
    //   "name": '合十',
    //   "low": 'https://i.imgur.com/I8x3ang.png',
    //   "high": 'https://i.imgur.com/T4rJVee.png'
    // },
    // {
    //   "name": '赞',
    //   "low": 'https://i.imgur.com/lG44yUl.png',
    //   "high": 'https://i.imgur.com/AoF5PLp.png'
    // },
    // {
    //   "name": '踩',
    //   "low": 'https://i.imgur.com/cJp0uKZ.png',
    //   "high": 'https://i.imgur.com/1XYGfXj.png'
    // },
    // {
    //   "name": '爱心',
    //   "low": 'https://i.imgur.com/sLENaF5.png',
    //   "high": 'https://i.imgur.com/dND56oX.png'
    // },
    //
    // {
    //   "name": '心碎',
    //   "low": 'https://i.imgur.com/AZxJzve.png',
    //   "high": 'https://i.imgur.com/RiUsPci.png'
    // },
  ];

  /** emoji表情数据 */
  static List emojiEmoticons = [
    {
      "title": '常用',
      "list": [
        '😅',
        '😭',
        '😂',
        '🥰',
        '😰',
        '🤡',
        '👀',
        '🐴',
        '🐶',
        '❓',
        '❤️',
        '💔',
        '⭐',
        '🔥',
        '💩',
        '🔞',
        '⚠️',
        '🎁',
        '🎉',
      ]
    },
    {
      "title": '小黄脸',
      "list": [
        '😀',
        '😁',
        '😂',
        '🤣',
        '😅',
        '😊',
        '😋',
        '😘',
        '🥰',
        '😗',
        '🤩',
        '🤔',
        '🤨',
        '😐',
        '😑',
        '🙄',
        '😏',
        '😪',
        '😫',
        '🥱',
        '😜',
        '😒',
        '😔',
        '😨',
        '😰',
        '😱',
        '🥵',
        '😡',
        '🥳',
        '🥺',
        '🤭',
        '🧐',
        '😎',
        '🤓',
        '😭',
        '🤑',
        '🤮',
      ],
    },
    {
      "title": '手势',
      "list": [
        '🤏',
        '👉',
        '✌️',
        '👌',
        '👍',
        '👎',
        '🤝',
        '🙏',
        '👏',
      ],
    },
    {
      "title": '其他',
      "list": [
        '🔞',
        '👻',
        '🤡',
        '🐔',
        '👀',
        '💩',
        '🐴',
        '🦄',
        '🐧',
        '🐶',
      ],
    },
  ];
}
