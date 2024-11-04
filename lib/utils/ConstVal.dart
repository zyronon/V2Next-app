import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:v2ex/model/TabItem.dart';

export '';

Color mainColor = const Color(0xff40c7ff);
int mainBgColor = 0xff0F1621;
// Color mainBgColor2 = const Color(0xffe1e1e1);
Color mainBgColor2 = const Color(0xfff1f1f1);
// Color mainBgColor2 = const Color(0xffa9a9a9);
double headerHeight = 40.w;
Color line = const Color(0xfff1f1f1);
TextStyle titleStyle = TextStyle(fontSize: 16.sp, color: Colors.black);
TextStyle descStyle = TextStyle(fontSize: 12.sp, color: Colors.grey);
TextStyle timeStyle = TextStyle(fontSize: 10.sp, color: Colors.grey);

EdgeInsets pagePadding = EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.w);

class Agent {
  String pc = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36';
  String ios = 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1';
  String android = 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36';
  // String android = 'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.114 Mobile Safari/537.36';
}

class Const {
  static Agent agent = new Agent();
  static String v2Hot = 'https://v2hotlist.vercel.app';
  static String v2exHost = 'https://www.v2ex.com';
  static String git = 'https://github.com/zyronon/V2Next';
  static String issues = 'https://github.com/zyronon/V2Next/issues';
  static Color primaryColor = Color(0xff48a24a);
  static Color line = Color(0xfff1f1f1);
  static double padding = 10.w;
  static EdgeInsetsGeometry paddingWidget = EdgeInsets.all(padding);
  static BorderRadiusGeometry borderRadiusWidget = BorderRadius.circular(10.r);
  // 所有节点
  static String allNodes = '/api/nodes/all.json';
  // 所有节点 topic
  static String allNodesT = '/api/nodes/list.json';
  static String groupNodes = '''
          <div class="box">
    <div class="cell"><div class="fr"><a href="/planes">浏览全部节点</a></div><span class="fade"><strong>V2EX</strong> / 节点导航</span></div>
    <div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">分享与探索</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/qna" style="font-size: 14px;">问与答</a>&nbsp; &nbsp; <a href="/go/share" style="font-size: 14px;">分享发现</a>&nbsp; &nbsp; <a href="/go/create" style="font-size: 14px;">分享创造</a>&nbsp; &nbsp; <a href="/go/ideas" style="font-size: 14px;">奇思妙想</a>&nbsp; &nbsp; <a href="/go/in" style="font-size: 14px;">分享邀请码</a>&nbsp; &nbsp; <a href="/go/autistic" style="font-size: 14px;">自言自语</a>&nbsp; &nbsp; <a href="/go/design" style="font-size: 14px;">设计</a>&nbsp; &nbsp; <a href="/go/blog" style="font-size: 14px;">Blog</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">V2EX</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/v2ex" style="font-size: 14px;">V2EX</a>&nbsp; &nbsp; <a href="/go/feedback" style="font-size: 14px;">反馈</a>&nbsp; &nbsp; <a href="/go/guide" style="font-size: 14px;">使用指南</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">Apple</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/apple" style="font-size: 14px;">Apple</a>&nbsp; &nbsp; <a href="/go/macos" style="font-size: 14px;">macOS</a>&nbsp; &nbsp; <a href="/go/iphone" style="font-size: 14px;">iPhone</a>&nbsp; &nbsp; <a href="/go/mbp" style="font-size: 14px;">MacBook Pro</a>&nbsp; &nbsp; <a href="/go/ios" style="font-size: 14px;">iOS</a>&nbsp; &nbsp; <a href="/go/ipad" style="font-size: 14px;">iPad</a>&nbsp; &nbsp; <a href="/go/watch" style="font-size: 14px;"> WATCH</a>&nbsp; &nbsp; <a href="/go/macbook" style="font-size: 14px;">MacBook</a>&nbsp; &nbsp; <a href="/go/accessory" style="font-size: 14px;">配件</a>&nbsp; &nbsp; <a href="/go/mba" style="font-size: 14px;">MacBook Air</a>&nbsp; &nbsp; <a href="/go/macmini" style="font-size: 14px;">Mac mini</a>&nbsp; &nbsp; <a href="/go/imac" style="font-size: 14px;">iMac</a>&nbsp; &nbsp; <a href="/go/xcode" style="font-size: 14px;">Xcode</a>&nbsp; &nbsp; <a href="/go/airpods" style="font-size: 14px;">AirPods</a>&nbsp; &nbsp; <a href="/go/macpro" style="font-size: 14px;">Mac Pro</a>&nbsp; &nbsp; <a href="/go/wwdc" style="font-size: 14px;">WWDC</a>&nbsp; &nbsp; <a href="/go/ipod" style="font-size: 14px;">iPod</a>&nbsp; &nbsp; <a href="/go/macstudio" style="font-size: 14px;">Mac Studio</a>&nbsp; &nbsp; <a href="/go/homekit" style="font-size: 14px;">HomeKit</a>&nbsp; &nbsp; <a href="/go/iwork" style="font-size: 14px;">iWork</a>&nbsp; &nbsp; <a href="/go/mobileme" style="font-size: 14px;">MobileMe</a>&nbsp; &nbsp; <a href="/go/ilife" style="font-size: 14px;">iLife</a>&nbsp; &nbsp; <a href="/go/garageband" style="font-size: 14px;">GarageBand</a>&nbsp; &nbsp; <a href="/go/macos9" style="font-size: 14px;">Mac OS 9</a>&nbsp; &nbsp; <a href="/go/freeform" style="font-size: 14px;">Freeform</a>&nbsp; &nbsp; <a href="/go/macgaming" style="font-size: 14px;">Mac 游戏</a>&nbsp; &nbsp; <a href="/go/imovie" style="font-size: 14px;">iMovie</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">前端开发</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/wechat" style="font-size: 14px;">微信</a>&nbsp; &nbsp; <a href="/go/fe" style="font-size: 14px;">前端开发</a>&nbsp; &nbsp; <a href="/go/chrome" style="font-size: 14px;">Chrome</a>&nbsp; &nbsp; <a href="/go/vue" style="font-size: 14px;">Vue.js</a>&nbsp; &nbsp; <a href="/go/browsers" style="font-size: 14px;">浏览器</a>&nbsp; &nbsp; <a href="/go/react" style="font-size: 14px;">React</a>&nbsp; &nbsp; <a href="/go/css" style="font-size: 14px;">CSS</a>&nbsp; &nbsp; <a href="/go/firefox" style="font-size: 14px;">Firefox</a>&nbsp; &nbsp; <a href="/go/flutter" style="font-size: 14px;">Flutter</a>&nbsp; &nbsp; <a href="/go/edge" style="font-size: 14px;">Edge</a>&nbsp; &nbsp; <a href="/go/angular" style="font-size: 14px;">Angular</a>&nbsp; &nbsp; <a href="/go/electron" style="font-size: 14px;">Electron</a>&nbsp; &nbsp; <a href="/go/webdev" style="font-size: 14px;">Web Dev</a>&nbsp; &nbsp; <a href="/go/nextjs" style="font-size: 14px;">Next.js</a>&nbsp; &nbsp; <a href="/go/vite" style="font-size: 14px;">Vite</a>&nbsp; &nbsp; <a href="/go/ionic" style="font-size: 14px;">Ionic</a>&nbsp; &nbsp; <a href="/go/nuxtjs" style="font-size: 14px;">Nuxt.js</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">编程语言</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/python" style="font-size: 14px;">Python</a>&nbsp; &nbsp; <a href="/go/java" style="font-size: 14px;">Java</a>&nbsp; &nbsp; <a href="/go/php" style="font-size: 14px;">PHP</a>&nbsp; &nbsp; <a href="/go/go" style="font-size: 14px;">Go 编程语言</a>&nbsp; &nbsp; <a href="/go/js" style="font-size: 14px;">JavaScript</a>&nbsp; &nbsp; <a href="/go/nodejs" style="font-size: 14px;">Node.js</a>&nbsp; &nbsp; <a href="/go/cpp" style="font-size: 14px;">C++</a>&nbsp; &nbsp; <a href="/go/swift" style="font-size: 14px;">Swift</a>&nbsp; &nbsp; <a href="/go/rust" style="font-size: 14px;">Rust</a>&nbsp; &nbsp; <a href="/go/html" style="font-size: 14px;">HTML</a>&nbsp; &nbsp; <a href="/go/dotnet" style="font-size: 14px;">.NET</a>&nbsp; &nbsp; <a href="/go/csharp" style="font-size: 14px;">C#</a>&nbsp; &nbsp; <a href="/go/ror" style="font-size: 14px;">Ruby on Rails</a>&nbsp; &nbsp; <a href="/go/typescript" style="font-size: 14px;">TypeScript</a>&nbsp; &nbsp; <a href="/go/ruby" style="font-size: 14px;">Ruby</a>&nbsp; &nbsp; <a href="/go/kotlin" style="font-size: 14px;">Kotlin</a>&nbsp; &nbsp; <a href="/go/lua" style="font-size: 14px;">Lua</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">后端架构</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/cloud" style="font-size: 14px;">云计算</a>&nbsp; &nbsp; <a href="/go/server" style="font-size: 14px;">服务器</a>&nbsp; &nbsp; <a href="/go/dns" style="font-size: 14px;">DNS</a>&nbsp; &nbsp; <a href="/go/mysql" style="font-size: 14px;">MySQL</a>&nbsp; &nbsp; <a href="/go/nginx" style="font-size: 14px;">NGINX</a>&nbsp; &nbsp; <a href="/go/docker" style="font-size: 14px;">Docker</a>&nbsp; &nbsp; <a href="/go/db" style="font-size: 14px;">数据库</a>&nbsp; &nbsp; <a href="/go/k8s" style="font-size: 14px;">Kubernetes</a>&nbsp; &nbsp; <a href="/go/ubuntu" style="font-size: 14px;">Ubuntu</a>&nbsp; &nbsp; <a href="/go/aws" style="font-size: 14px;">Amazon Web Services</a>&nbsp; &nbsp; <a href="/go/django" style="font-size: 14px;">Django</a>&nbsp; &nbsp; <a href="/go/redis" style="font-size: 14px;">Redis</a>&nbsp; &nbsp; <a href="/go/mongodb" style="font-size: 14px;">MongoDB</a>&nbsp; &nbsp; <a href="/go/devops" style="font-size: 14px;">DevOps</a>&nbsp; &nbsp; <a href="/go/cloudflare" style="font-size: 14px;">Cloudflare</a>&nbsp; &nbsp; <a href="/go/elasticsearch" style="font-size: 14px;">Elasticsearch</a>&nbsp; &nbsp; <a href="/go/flask" style="font-size: 14px;">Flask</a>&nbsp; &nbsp; <a href="/go/tornado" style="font-size: 14px;">Tornado</a>&nbsp; &nbsp; <a href="/go/api" style="font-size: 14px;">API</a>&nbsp; &nbsp; <a href="/go/leancloud" style="font-size: 14px;">LeanCloud</a>&nbsp; &nbsp; <a href="/go/timescale" style="font-size: 14px;">Timescale</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">Crypto</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/bitcoin" style="font-size: 14px;">Bitcoin</a>&nbsp; &nbsp; <a href="/go/crypto" style="font-size: 14px;">加密货币</a>&nbsp; &nbsp; <a href="/go/ripple" style="font-size: 14px;">Ripple</a>&nbsp; &nbsp; <a href="/go/ethereum" style="font-size: 14px;">以太坊</a>&nbsp; &nbsp; <a href="/go/solidity" style="font-size: 14px;">Solidity</a>&nbsp; &nbsp; <a href="/go/solana" style="font-size: 14px;">Solana</a>&nbsp; &nbsp; <a href="/go/metamask" style="font-size: 14px;">MetaMask</a>&nbsp; &nbsp; <a href="/go/ton" style="font-size: 14px;">TON</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">机器学习</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/ml" style="font-size: 14px;">机器学习</a>&nbsp; &nbsp; <a href="/go/math" style="font-size: 14px;">数学</a>&nbsp; &nbsp; <a href="/go/tensorflow" style="font-size: 14px;">TensorFlow</a>&nbsp; &nbsp; <a href="/go/nlp" style="font-size: 14px;">自然语言处理</a>&nbsp; &nbsp; <a href="/go/cuda" style="font-size: 14px;">CUDA</a>&nbsp; &nbsp; <a href="/go/torch" style="font-size: 14px;">Torch</a>&nbsp; &nbsp; <a href="/go/keras" style="font-size: 14px;">Keras</a>&nbsp; &nbsp; <a href="/go/coreml" style="font-size: 14px;">Core ML</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">iOS</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/idev" style="font-size: 14px;">iDev</a>&nbsp; &nbsp; <a href="/go/icode" style="font-size: 14px;">iCode</a>&nbsp; &nbsp; <a href="/go/imarketing" style="font-size: 14px;">iMarketing</a>&nbsp; &nbsp; <a href="/go/iad" style="font-size: 14px;">iAd</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">Geek</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/programmer" style="font-size: 14px;">程序员</a>&nbsp; &nbsp; <a href="/go/bb" style="font-size: 14px;">宽带症候群</a>&nbsp; &nbsp; <a href="/go/android" style="font-size: 14px;">Android</a>&nbsp; &nbsp; <a href="/go/linux" style="font-size: 14px;">Linux</a>&nbsp; &nbsp; <a href="/go/outsourcing" style="font-size: 14px;">外包</a>&nbsp; &nbsp; <a href="/go/hardware" style="font-size: 14px;">硬件</a>&nbsp; &nbsp; <a href="/go/windows" style="font-size: 14px;">Windows</a>&nbsp; &nbsp; <a href="/go/openai" style="font-size: 14px;">OpenAI</a>&nbsp; &nbsp; <a href="/go/car" style="font-size: 14px;">汽车</a>&nbsp; &nbsp; <a href="/go/router" style="font-size: 14px;">路由器</a>&nbsp; &nbsp; <a href="/go/webmaster" style="font-size: 14px;">站长</a>&nbsp; &nbsp; <a href="/go/openwrt" style="font-size: 14px;">OpenWrt</a>&nbsp; &nbsp; <a href="/go/programming" style="font-size: 14px;">编程</a>&nbsp; &nbsp; <a href="/go/github" style="font-size: 14px;">GitHub</a>&nbsp; &nbsp; <a href="/go/vscode" style="font-size: 14px;">Visual Studio Code</a>&nbsp; &nbsp; <a href="/go/blockchain" style="font-size: 14px;">区块链</a>&nbsp; &nbsp; <a href="/go/markdown" style="font-size: 14px;">Markdown</a>&nbsp; &nbsp; <a href="/go/designer" style="font-size: 14px;">设计师</a>&nbsp; &nbsp; <a href="/go/kindle" style="font-size: 14px;">Kindle</a>&nbsp; &nbsp; <a href="/go/gamedev" style="font-size: 14px;">游戏开发</a>&nbsp; &nbsp; <a href="/go/pi" style="font-size: 14px;">Raspberry Pi</a>&nbsp; &nbsp; <a href="/go/business" style="font-size: 14px;">商业模式</a>&nbsp; &nbsp; <a href="/go/typography" style="font-size: 14px;">字体排印</a>&nbsp; &nbsp; <a href="/go/vxna" style="font-size: 14px;">VXNA</a>&nbsp; &nbsp; <a href="/go/ifix" style="font-size: 14px;">云修电脑</a>&nbsp; &nbsp; <a href="/go/atom" style="font-size: 14px;">Atom</a>&nbsp; &nbsp; <a href="/go/ev" style="font-size: 14px;">电动汽车</a>&nbsp; &nbsp; <a href="/go/copilot" style="font-size: 14px;">GitHub Copilot</a>&nbsp; &nbsp; <a href="/go/sony" style="font-size: 14px;">SONY</a>&nbsp; &nbsp; <a href="/go/rss" style="font-size: 14px;">RSS</a>&nbsp; &nbsp; <a href="/go/leetcode" style="font-size: 14px;">LeetCode</a>&nbsp; &nbsp; <a href="/go/photoshop" style="font-size: 14px;">Photoshop</a>&nbsp; &nbsp; <a href="/go/amazon" style="font-size: 14px;">Amazon</a>&nbsp; &nbsp; <a href="/go/serverless" style="font-size: 14px;">Serverless</a>&nbsp; &nbsp; <a href="/go/gitlab" style="font-size: 14px;">GitLab</a>&nbsp; &nbsp; <a href="/go/ipfs" style="font-size: 14px;">IPFS</a>&nbsp; &nbsp; <a href="/go/lego" style="font-size: 14px;">LEGO</a>&nbsp; &nbsp; <a href="/go/dji" style="font-size: 14px;">DJI</a>&nbsp; &nbsp; <a href="/go/blender" style="font-size: 14px;">Blender</a>&nbsp; &nbsp; <a href="/go/logseq" style="font-size: 14px;">Logseq</a>&nbsp; &nbsp; <a href="/go/dos" style="font-size: 14px;">DOS</a>&nbsp; &nbsp; <a href="/go/gamedb" style="font-size: 14px;">GameDB</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">游戏</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/games" style="font-size: 14px;">游戏</a>&nbsp; &nbsp; <a href="/go/steam" style="font-size: 14px;">Steam</a>&nbsp; &nbsp; <a href="/go/switch" style="font-size: 14px;">Nintendo Switch</a>&nbsp; &nbsp; <a href="/go/minecraft" style="font-size: 14px;">Minecraft</a>&nbsp; &nbsp; <a href="/go/ps4" style="font-size: 14px;">PlayStation 4</a>&nbsp; &nbsp; <a href="/go/igame" style="font-size: 14px;">iGame</a>&nbsp; &nbsp; <a href="/go/sc2" style="font-size: 14px;">StarCraft 2</a>&nbsp; &nbsp; <a href="/go/bf3" style="font-size: 14px;">Battlefield 3</a>&nbsp; &nbsp; <a href="/go/wow" style="font-size: 14px;">World of Warcraft</a>&nbsp; &nbsp; <a href="/go/retro" style="font-size: 14px;">怀旧游戏</a>&nbsp; &nbsp; <a href="/go/ps5" style="font-size: 14px;">PlayStation 5</a>&nbsp; &nbsp; <a href="/go/eve" style="font-size: 14px;">EVE</a>&nbsp; &nbsp; <a href="/go/pokemon" style="font-size: 14px;">精灵宝可梦</a>&nbsp; &nbsp; <a href="/go/3ds" style="font-size: 14px;">3DS</a>&nbsp; &nbsp; <a href="/go/gt" style="font-size: 14px;">Gran Turismo</a>&nbsp; &nbsp; <a href="/go/bf4" style="font-size: 14px;">Battlefield 4</a>&nbsp; &nbsp; <a href="/go/wiiu" style="font-size: 14px;">Wii U</a>&nbsp; &nbsp; <a href="/go/bfv" style="font-size: 14px;">Battlefield V</a>&nbsp; &nbsp; <a href="/go/handheld" style="font-size: 14px;">掌机</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">生活</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/all4all" style="font-size: 14px;">二手交易</a>&nbsp; &nbsp; <a href="/go/jobs" style="font-size: 14px;">酷工作</a>&nbsp; &nbsp; <a href="/go/career" style="font-size: 14px;">职场话题</a>&nbsp; &nbsp; <a href="/go/cv" style="font-size: 14px;">求职</a>&nbsp; &nbsp; <a href="/go/afterdark" style="font-size: 14px;">天黑以后</a>&nbsp; &nbsp; <a href="/go/free" style="font-size: 14px;">免费赠送</a>&nbsp; &nbsp; <a href="/go/invest" style="font-size: 14px;">投资</a>&nbsp; &nbsp; <a href="/go/music" style="font-size: 14px;">音乐</a>&nbsp; &nbsp; <a href="/go/tuan" style="font-size: 14px;">团购</a>&nbsp; &nbsp; <a href="/go/movie" style="font-size: 14px;">电影</a>&nbsp; &nbsp; <a href="/go/exchange" style="font-size: 14px;">物物交换</a>&nbsp; &nbsp; <a href="/go/travel" style="font-size: 14px;">旅行</a>&nbsp; &nbsp; <a href="/go/tv" style="font-size: 14px;">剧集</a>&nbsp; &nbsp; <a href="/go/creditcard" style="font-size: 14px;">信用卡</a>&nbsp; &nbsp; <a href="/go/taste" style="font-size: 14px;">美酒与美食</a>&nbsp; &nbsp; <a href="/go/reading" style="font-size: 14px;">阅读</a>&nbsp; &nbsp; <a href="/go/photograph" style="font-size: 14px;">摄影</a>&nbsp; &nbsp; <a href="/go/pet" style="font-size: 14px;">宠物</a>&nbsp; &nbsp; <a href="/go/baby" style="font-size: 14px;">Baby</a>&nbsp; &nbsp; <a href="/go/coffee" style="font-size: 14px;">咖啡</a>&nbsp; &nbsp; <a href="/go/soccer" style="font-size: 14px;">绿茵场</a>&nbsp; &nbsp; <a href="/go/bike" style="font-size: 14px;">骑行</a>&nbsp; &nbsp; <a href="/go/diary" style="font-size: 14px;">日记</a>&nbsp; &nbsp; <a href="/go/plant" style="font-size: 14px;">植物</a>&nbsp; &nbsp; <a href="/go/mushroom" style="font-size: 14px;">蘑菇</a>&nbsp; &nbsp; <a href="/go/mileage" style="font-size: 14px;">行程控</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="cell"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">Internet</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/google" style="font-size: 14px;">Google</a>&nbsp; &nbsp; <a href="/go/youtube" style="font-size: 14px;">YouTube</a>&nbsp; &nbsp; <a href="/go/twitter" style="font-size: 14px;">Twitter</a>&nbsp; &nbsp; <a href="/go/bilibili" style="font-size: 14px;">哔哩哔哩</a>&nbsp; &nbsp; <a href="/go/notion" style="font-size: 14px;">Notion</a>&nbsp; &nbsp; <a href="/go/reddit" style="font-size: 14px;">Reddit</a>&nbsp; &nbsp; <a href="/go/discord" style="font-size: 14px;">Discord</a>&nbsp; &nbsp; </td></tr></tbody></table></div><div class="inner"><table cellpadding="0" cellspacing="0" border="0"><tbody><tr><td align="right" width="80"><span class="fade">城市</span></td><td style="line-height: 200%; padding-left: 10px; word-break: keep-all;"><a href="/go/beijing" style="font-size: 14px;">北京</a>&nbsp; &nbsp; <a href="/go/shanghai" style="font-size: 14px;">上海</a>&nbsp; &nbsp; <a href="/go/shenzhen" style="font-size: 14px;">深圳</a>&nbsp; &nbsp; <a href="/go/hangzhou" style="font-size: 14px;">杭州</a>&nbsp; &nbsp; <a href="/go/chengdu" style="font-size: 14px;">成都</a>&nbsp; &nbsp; <a href="/go/guangzhou" style="font-size: 14px;">广州</a>&nbsp; &nbsp; <a href="/go/wuhan" style="font-size: 14px;">武汉</a>&nbsp; &nbsp; <a href="/go/nanjing" style="font-size: 14px;">南京</a>&nbsp; &nbsp; <a href="/go/hongkong" style="font-size: 14px;">香港</a>&nbsp; &nbsp; <a href="/go/xian" style="font-size: 14px;">西安</a>&nbsp; &nbsp; <a href="/go/changsha" style="font-size: 14px;">长沙</a>&nbsp; &nbsp; <a href="/go/chongqing" style="font-size: 14px;">重庆</a>&nbsp; &nbsp; <a href="/go/suzhou" style="font-size: 14px;">苏州</a>&nbsp; &nbsp; <a href="/go/kunming" style="font-size: 14px;">昆明</a>&nbsp; &nbsp; <a href="/go/xiamen" style="font-size: 14px;">厦门</a>&nbsp; &nbsp; <a href="/go/tianjin" style="font-size: 14px;">天津</a>&nbsp; &nbsp; <a href="/go/qingdao" style="font-size: 14px;">青岛</a>&nbsp; &nbsp; <a href="/go/nyc" style="font-size: 14px;">New York</a>&nbsp; &nbsp; <a href="/go/sanfrancisco" style="font-size: 14px;">San Francisco</a>&nbsp; &nbsp; <a href="/go/tokyo" style="font-size: 14px;">东京</a>&nbsp; &nbsp; <a href="/go/singapore" style="font-size: 14px;">Singapore</a>&nbsp; &nbsp; <a href="/go/guiyang" style="font-size: 14px;">贵阳</a>&nbsp; &nbsp; <a href="/go/la" style="font-size: 14px;">Los Angeles</a>&nbsp; &nbsp; </td></tr></tbody></table></div>
</div>
  ''';

  static List<TabItem> defaultTabList = [
    new TabItem(cnName: '最热', enName: 'hot', type: TabType.hot),
    // new TabItem(cnName: '沙盒', enName: 'sandbox', type: TabType.node),
    new TabItem(cnName: '水深火热', enName: 'flamewar', type: TabType.node),
    new TabItem(cnName: '最新', enName: 'new', type: TabType.latest),
    new TabItem(cnName: '全部', enName: 'all', type: TabType.tab),
    new TabItem(cnName: '技术', enName: 'tech', type: TabType.tab),
    new TabItem(cnName: '创意', enName: 'creative', type: TabType.tab),
    new TabItem(cnName: '好玩', enName: 'play', type: TabType.tab),
    new TabItem(cnName: 'Apple', enName: 'apple', type: TabType.tab),
    new TabItem(cnName: '酷工作', enName: 'jobs', type: TabType.tab),
    new TabItem(cnName: '交易', enName: 'deals', type: TabType.tab),
    new TabItem(cnName: '城市', enName: 'city', type: TabType.tab),
    new TabItem(cnName: '问与答', enName: 'qna', type: TabType.tab),
    new TabItem(cnName: 'R2', enName: 'r2', type: TabType.tab),
    new TabItem(cnName: '节点', enName: 'nodes', type: TabType.tab),
    new TabItem(cnName: '关注', enName: 'members', type: TabType.tab),
  ];
// static Color primaryColor = Color(0xff07c160);
}
