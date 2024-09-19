import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:v2ex/bus.dart';
import 'package:v2ex/model/Post.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Me extends StatefulWidget {
  final Post post;

  const Me({super.key, required this.post});

  @override
  State<Me> createState() => MeState();
}

class MeState extends State<Me> {
  late final WebViewController controller;

  double stateHeight = 0;

  Post? item;

  @override
  void initState() {
    stateHeight = MediaQueryData.fromWindow(window).padding.top;
    super.initState();

    // print(this.widget.post.id);
    // print(this.widget.post.title);
    // setState(() {
    //   item = this.widget.post;
    // });
    // bus.emit('getPost', this.widget.post.id);
    // bus.on('postData', (arg) {
    //   print('on-postData' + arg['title']);
    //   setState(() {
    //     item = Post.fromJson(arg);
    //   });
    // });

    var message =
        '{\"type\":\"post\",\"data\":{\"allReplyUsers\":[\"facebook47\",\"flutternewton\",\"tianyi666666\",\"tanranran\"],\"content_rendered\":\"\",\"createDate\":\"2024-09-19 22:02:40 +08:00\",\"createDateAgo\":\"5 小时 6 分钟前\",\"lastReplyDate\":\"\",\"lastReplyUsername\":\"\",\"fr\":\"\",\"replyList\":[{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15281571\",\"reply_content\":\"牛逼，300 多万用户👍👍👍为啥还要打工，我以为只要用户量达到百万就可以财富自由了呢😂😂😂\",\"reply_text\":\"牛逼，300 多万用户👍👍👍为啥还要打工，我以为只要用户量达到百万就可以财富自由了呢😂😂😂\",\"hideCallUserReplyContent\":\"牛逼，300 多万用户👍👍👍为啥还要打工，我以为只要用户量达到百万就可以财富自由了呢😂😂😂\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"5 小时 4 分钟前 via Android\",\"username\":\"facebook47\",\"avatar\":\"https://cdn.v2ex.com/gravatar/97cf391f972aa3798b7b4c47a01c8fca?s=24&d=retro\",\"floor\":1},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":true,\"isDup\":false,\"id\":\"15281579\",\"reply_content\":\"@<a href=\\"/member/facebook47\\">facebook47</a> 并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"reply_text\":\"@facebook47 并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"hideCallUserReplyContent\":\"并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"replyUsers\":[\"facebook47\"],\"replyFloor\":-1,\"date\":\"5 小时 3 分钟前\",\"username\":\"flutternewton\",\"avatar\":\"https://cdn.v2ex.com/gravatar/1b2da7331a3860f34be99a242172fda5?s=24&d=retro\",\"floor\":2},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15281946\",\"reply_content\":\"我用过这个插件，居然碰到了作者\",\"reply_text\":\"我用过这个插件，居然碰到了作者\",\"hideCallUserReplyContent\":\"我用过这个插件，居然碰到了作者\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"3 小时 3 分钟前\",\"username\":\"tianyi666666\",\"avatar\":\"https://cdn.v2ex.com/gravatar/3bcc8d2768fecbd3ad5298c728beabb4?s=24&d=retro\",\"floor\":3},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15282035\",\"reply_content\":\"楼主可以研究下鸿蒙上使用 flutter 。<br><a target=\\"_blank\\" href=\\"https://gitee.com/openharmony-sig/flutter_flutter\\" rel=\\"nofollow noopener\\">https://gitee.com/openharmony-sig/flutter_flutter</a><br><br>研究好了，接下来市面上会有大量 flutter 转鸿蒙的岗位\",\"reply_text\":\"楼主可以研究下鸿蒙上使用 flutter 。https://gitee.com/openharmony-sig/flutter_flutter研究好了，接下来市面上会有大量 flutter 转鸿蒙的岗位\",\"hideCallUserReplyContent\":\"楼主可以研究下鸿蒙上使用 flutter 。<br><a target=\\"_blank\\" href=\\"https://gitee.com/openharmony-sig/flutter_flutter\\" rel=\\"nofollow noopener\\">https://gitee.com/openharmony-sig/flutter_flutter</a><br><br>研究好了，接下来市面上会有大量 flutter 转鸿蒙的岗位\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"2 小时 31 分钟前\",\"username\":\"tanranran\",\"avatar\":\"https://cdn.v2ex.com/avatar/f6e1/4cff/103705_normal.png?m=1686834289\",\"floor\":4}],\"topReplyList\":[],\"nestedReplies\":[{\"level\":0,\"thankCount\":0,\"replyCount\":1,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15281571\",\"reply_content\":\"牛逼，300 多万用户👍👍👍为啥还要打工，我以为只要用户量达到百万就可以财富自由了呢😂😂😂\",\"reply_text\":\"牛逼，300 多万用户👍👍👍为啥还要打工，我以为只要用户量达到百万就可以财富自由了呢😂😂😂\",\"hideCallUserReplyContent\":\"牛逼，300 多万用户👍👍👍为啥还要打工，我以为只要用户量达到百万就可以财富自由了呢😂😂😂\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"5 小时 4 分钟前 via Android\",\"username\":\"facebook47\",\"avatar\":\"https://cdn.v2ex.com/gravatar/97cf391f972aa3798b7b4c47a01c8fca?s=24&d=retro\",\"floor\":1,\"children\":[{\"level\":1,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":true,\"isDup\":false,\"id\":\"15281579\",\"reply_content\":\"@<a href=\\"/member/facebook47\\">facebook47</a> 并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"reply_text\":\"@facebook47 并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"hideCallUserReplyContent\":\"并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"replyUsers\":[\"facebook47\"],\"replyFloor\":-1,\"date\":\"5 小时 3 分钟前\",\"username\":\"flutternewton\",\"avatar\":\"https://cdn.v2ex.com/gravatar/1b2da7331a3860f34be99a242172fda5?s=24&d=retro\",\"floor\":2,\"isUse\":true,\"children\":[]}]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15281946\",\"reply_content\":\"我用过这个插件，居然碰到了作者\",\"reply_text\":\"我用过这个插件，居然碰到了作者\",\"hideCallUserReplyContent\":\"我用过这个插件，居然碰到了作者\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"3 小时 3 分钟前\",\"username\":\"tianyi666666\",\"avatar\":\"https://cdn.v2ex.com/gravatar/3bcc8d2768fecbd3ad5298c728beabb4?s=24&d=retro\",\"floor\":3,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15282035\",\"reply_content\":\"楼主可以研究下鸿蒙上使用 flutter 。<br><a target=\\"_blank\\" href=\\"https://gitee.com/openharmony-sig/flutter_flutter\\" rel=\\"nofollow noopener\\">https://gitee.com/openharmony-sig/flutter_flutter</a><br><br>研究好了，接下来市面上会有大量 flutter 转鸿蒙的岗位\",\"reply_text\":\"楼主可以研究下鸿蒙上使用 flutter 。https://gitee.com/openharmony-sig/flutter_flutter研究好了，接下来市面上会有大量 flutter 转鸿蒙的岗位\",\"hideCallUserReplyContent\":\"楼主可以研究下鸿蒙上使用 flutter 。<br><a target=\\"_blank\\" href=\\"https://gitee.com/openharmony-sig/flutter_flutter\\" rel=\\"nofollow noopener\\">https://gitee.com/openharmony-sig/flutter_flutter</a><br><br>研究好了，接下来市面上会有大量 flutter 转鸿蒙的岗位\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"2 小时 31 分钟前\",\"username\":\"tanranran\",\"avatar\":\"https://cdn.v2ex.com/avatar/f6e1/4cff/103705_normal.png?m=1686834289\",\"floor\":4,\"children\":[]}],\"nestedRedundReplies\":[{\"level\":0,\"thankCount\":0,\"replyCount\":1,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15281571\",\"reply_content\":\"牛逼，300 多万用户👍👍👍为啥还要打工，我以为只要用户量达到百万就可以财富自由了呢😂😂😂\",\"reply_text\":\"牛逼，300 多万用户👍👍👍为啥还要打工，我以为只要用户量达到百万就可以财富自由了呢😂😂😂\",\"hideCallUserReplyContent\":\"牛逼，300 多万用户👍👍👍为啥还要打工，我以为只要用户量达到百万就可以财富自由了呢😂😂😂\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"5 小时 4 分钟前 via Android\",\"username\":\"facebook47\",\"avatar\":\"https://cdn.v2ex.com/gravatar/97cf391f972aa3798b7b4c47a01c8fca?s=24&d=retro\",\"floor\":1,\"children\":[{\"level\":1,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":true,\"isDup\":false,\"id\":\"15281579\",\"reply_content\":\"@<a href=\\"/member/facebook47\\">facebook47</a> 并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"reply_text\":\"@facebook47 并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"hideCallUserReplyContent\":\"并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"replyUsers\":[\"facebook47\"],\"replyFloor\":-1,\"date\":\"5 小时 3 分钟前\",\"username\":\"flutternewton\",\"avatar\":\"https://cdn.v2ex.com/gravatar/1b2da7331a3860f34be99a242172fda5?s=24&d=retro\",\"floor\":2,\"isUse\":true,\"children\":[]}]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":true,\"isDup\":true,\"id\":\"15281579\",\"reply_content\":\"@<a href=\\"/member/facebook47\\">facebook47</a> 并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"reply_text\":\"@facebook47 并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"hideCallUserReplyContent\":\"并不是这样的,因为要考虑到盈利问题,还要就是无法面对焦虑 上班习惯了\",\"replyUsers\":[\"facebook47\"],\"replyFloor\":-1,\"date\":\"5 小时 3 分钟前\",\"username\":\"flutternewton\",\"avatar\":\"https://cdn.v2ex.com/gravatar/1b2da7331a3860f34be99a242172fda5?s=24&d=retro\",\"floor\":2,\"isUse\":true,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15281946\",\"reply_content\":\"我用过这个插件，居然碰到了作者\",\"reply_text\":\"我用过这个插件，居然碰到了作者\",\"hideCallUserReplyContent\":\"我用过这个插件，居然碰到了作者\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"3 小时 3 分钟前\",\"username\":\"tianyi666666\",\"avatar\":\"https://cdn.v2ex.com/gravatar/3bcc8d2768fecbd3ad5298c728beabb4?s=24&d=retro\",\"floor\":3,\"children\":[]},{\"level\":0,\"thankCount\":0,\"replyCount\":0,\"isThanked\":false,\"isOp\":false,\"isDup\":false,\"id\":\"15282035\",\"reply_content\":\"楼主可以研究下鸿蒙上使用 flutter 。<br><a target=\\"_blank\\" href=\\"https://gitee.com/openharmony-sig/flutter_flutter\\" rel=\\"nofollow noopener\\">https://gitee.com/openharmony-sig/flutter_flutter</a><br><br>研究好了，接下来市面上会有大量 flutter 转鸿蒙的岗位\",\"reply_text\":\"楼主可以研究下鸿蒙上使用 flutter 。https://gitee.com/openharmony-sig/flutter_flutter研究好了，接下来市面上会有大量 flutter 转鸿蒙的岗位\",\"hideCallUserReplyContent\":\"楼主可以研究下鸿蒙上使用 flutter 。<br><a target=\\"_blank\\" href=\\"https://gitee.com/openharmony-sig/flutter_flutter\\" rel=\\"nofollow noopener\\">https://gitee.com/openharmony-sig/flutter_flutter</a><br><br>研究好了，接下来市面上会有大量 flutter 转鸿蒙的岗位\",\"replyUsers\":[],\"replyFloor\":-1,\"date\":\"2 小时 31 分钟前\",\"username\":\"tanranran\",\"avatar\":\"https://cdn.v2ex.com/avatar/f6e1/4cff/103705_normal.png?m=1686834289\",\"floor\":4,\"children\":[]}],\"username\":\"\",\"url\":\"\",\"href\":\"\",\"member\":{\"avatar\":\"\",\"username\":\"flutternewton\",\"avatar_large\":\"https://cdn.v2ex.com/gravatar/1b2da7331a3860f34be99a242172fda5?s=36&d=retro\"},\"node\":{\"title\":\"求职\",\"url\":\"https://www.v2ex.com/go/cv\"},\"headerTemplate\":\"<div class=\\"cell\\"><div class=\\"topic_content\\"><div class=\\"markdown_body\\"><p>年龄 28安卓原生出身经验1.flutterjsonbeanfactory 插件作者(500+star 和 30 多万使用量)2.有大量国内外应用商店上架经验3.有个人项目在架项目,注册用户有 300 多万4.有 flutter nullsafety 升级经验,flutter 插件封装经验(saver_gallery 和 tencent_cos 等)5.做过电影,商城,海外贷款,图片编辑工具,语音转码,todo 清单等 app6.有自学的后端经验</p><p>微信：eHV4dXl1MTIzNDU2</p></div></div></div>\",\"title\":\"北京找一份 flutter 工作\",\"id\":\"1074159\",\"type\":\"post\",\"once\":\"38652\",\"replyCount\":4,\"clickCount\":353,\"thankCount\":0,\"collectCount\":1,\"lastReadFloor\":0,\"isFavorite\":false,\"isIgnore\":false,\"isThanked\":false,\"isReport\":false,\"inList\":false}}';

    var te = json.decode(message);
    setState(() {
      item = Post.fromJson(te['data']);
      print(item?.createDateAgo);
    });
    print('initState-Me');
  }

  submit() {
    print("test");
    controller.loadRequest(Uri.parse('https://v2ex.com'));
    // Navigator.pushNamed(context, 'Home');
  }

  Reply? getReplyList(index) {
    return item?.nestedReplies?[index - 1];
  }

  thank(index) {
    print(index);
    var s = item?.nestedReplies?[index - 1];
    if (s != Null) {
      setState(() {
        item?.nestedReplies?[index - 1].isThanked = true;
      });
    }
  }

  var options = ['1', '2', '3'];

  Widget modalItem(String text, IconData icon) {
    return Padding(
        padding: EdgeInsets.only(left: 12.w, top: 16.w, bottom: 16.w),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Text(text),
            )
          ],
        ));
  }

  showModal() {
    showModalBottomSheet<int>(
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return IntrinsicHeight(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            IntrinsicHeight(
              child: Container(
                margin: EdgeInsets.only(bottom: 10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                padding: EdgeInsets.all(14.w),
                width: ScreenUtil().screenWidth * .9,
                child: Text('牛逼，300 多万用户👍👍👍为啥还要打工，我以为只要用户量达到百万就可以财富自由了呢😂😂😂'),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  modalItem('回复', Icons.chat_bubble_outline),
                  modalItem('感谢', Icons.favorite_border),
                  modalItem('上下文', Icons.content_paste_search),
                  modalItem('复制', Icons.content_copy),
                  modalItem('忽略', Icons.block),
                ],
              ),
            ),
          ],
        ));
      },
    );
  }

  Widget getItem(Reply val, int index) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Row(
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(5.w), child: Image.network(val?.avatar ?? '', width: 26.w, height: 26.w, fit: BoxFit.cover)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            val?.username ?? '',
                            style: TextStyle(fontSize: 13.sp, height: 1.2, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                (val?.floor ?? '').toString() + '楼',
                                style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                val?.date ?? '',
                                style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (val?.thankCount != 0)
                      InkWell(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              val?.isThanked == true ? Icons.favorite : Icons.favorite_border,
                              size: 18.sp,
                              color: Colors.red,
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 4.w),
                                child: Text(
                                  val?.thankCount.toString() ?? '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 14.sp, color: Colors.red, height: 1.2),
                                ))
                          ],
                        ),
                        onTap: () {
                          thank(index);
                          print('onTap');
                          // val.isThanked = true;
                        },
                      ),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(left: 4.w),
                        child: Icon(
                          Icons.more_vert,
                          size: 20.sp,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: showModal,
                    )
                  ],
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 4.w,
              ),
              child: HtmlWidget(
                val?.hideCallUserReplyContent ?? '',
                renderMode: RenderMode.column,
                textStyle: TextStyle(fontSize: 14.sp),
              ),
            ),
          ]),
        ),
        if (val?.children?.length != 0)
          Column(
            children: [
              ...val!.children!.map((a) => Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: getItem(a, 1),
                  ))
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      print('me page' + args.toString());
    }
    print('build-Me');

    return WillPopScope(
        child: Scaffold(
          body: DefaultTextStyle(
              style: TextStyle(color: Colors.black, fontSize: 12.sp),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200.w,
                    child: Text(
                      'sdsadfffffffffffffff',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Expanded(
                      child: ListView.separated(
                    // shrinkWrap: true,
                    itemCount: 1 + (item?.nestedReplies?.length ?? 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        if (item?.member?.avatarLarge != null) ...[
                                          ClipRRect(
                                              borderRadius: BorderRadius.circular(4.w),
                                              child: Image.network(item!.member!.avatarLarge!, width: 30.w, height: 30.w, fit: BoxFit.cover)),
                                        ] else ...[
                                          Container(width: 30.w, height: 30.w)
                                        ],
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    item?.member?.username ?? '',
                                                    style: TextStyle(fontSize: 15.sp, height: 1.2),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    item?.createDateAgo ?? '',
                                                    style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    (item?.clickCount.toString() ?? '') + '次点击',
                                                    style: TextStyle(fontSize: 11.sp, height: 1.2, color: Colors.grey),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      verticalDirection: VerticalDirection.down,
                                    ),
                                    //标题
                                    Padding(
                                      padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
                                      child: Text(
                                        item?.title ?? '',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                                      ),
                                    ),
                                    HtmlWidget(
                                      item?.headerTemplate ?? '',
                                      renderMode: RenderMode.column,
                                      textStyle: TextStyle(fontSize: 14.sp),
                                    ),
                                  ],
                                )),
                            Container(
                              width: 100.sw,
                              height: 4.w,
                              color: Colors.black12,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (item?.replyCount ?? '').toString() + '条回复',
                                    style: TextStyle(fontSize: 14.sp, height: 1.2, color: Colors.grey),
                                  ),
                                  Text(
                                    '楼中楼',
                                    style: TextStyle(fontSize: 14.sp, height: 1.2, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }
                      return getItem(getReplyList(index)!, index);
                    },
                    //分割器构造器
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 1,
                        color: Color(0xfff1f1f1),
                      );
                    },
                  )),
                  Container(
                      width: double.infinity,
                      height: 100.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: TextField(
                            autofocus: true,
                            decoration: InputDecoration(labelText: "用户名", hintText: "用户名或邮箱", prefixIcon: Icon(Icons.person)),
                          )),
                          Icon(
                            Icons.more_horiz,
                            size: 20.sp,
                            color: Colors.grey,
                          ),
                        ],
                      )),
                ],
              )),
        ),
        onWillPop: () async {
          print("返回键点击了");
          Navigator.pop(context);
          // var isFinish = await controller.canGoBack().then((value) {
          //   if (value) {
          //     controller.goBack();
          //   }
          //   return !value;
          // });
          // return isFinish;
          return false;
        });
  }
}
