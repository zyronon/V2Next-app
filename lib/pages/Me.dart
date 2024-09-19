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

    print(this.widget.post.id);
    print(this.widget.post.title);

    setState(() {
      item = this.widget.post;
    });

    bus.emit('getPost', this.widget.post.id);
    bus.on('postData', (arg) {
      print('on-postData' + arg['title']);
      setState(() {
        item = Post.fromJson(arg);
      });
    });

    // var message = '';
    // var te = json.decode(message);
    // setState(() {
    //   item = Post.fromJson(te);
    //   print(item?.createDateAgo);
    // });
    // print('initState-Me');
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
                    ClipRRect(borderRadius: BorderRadius.circular(4.w), child: Image.network(val?.avatar ?? '', width: 20.w, height: 20.w, fit: BoxFit.cover)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            val?.username ?? '',
                            style: TextStyle(fontSize: 10.sp, height: 1.2, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                (val?.floor ?? '').toString() + '楼',
                                style: TextStyle(fontSize: 8.sp, height: 1.2, color: Colors.grey),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                val?.date ?? '',
                                style: TextStyle(fontSize: 8.sp, height: 1.2, color: Colors.grey),
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
                              size: 15.sp,
                              color: Colors.red,
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 4.w),
                                child: Text(
                                  val?.thankCount.toString() ?? '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 12.sp, color: Colors.red, height: 1.2),
                                ))
                          ],
                        ),
                        onTap: () {
                          thank(index);
                          print('onTap');
                          // val.isThanked = true;
                        },
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Icon(
                        Icons.more_vert,
                        size: 16.sp,
                        color: Colors.grey,
                      ),
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
                top: 0.w,
              ),
              child: HtmlWidget(
                val?.hideCallUserReplyContent ?? '',
                renderMode: RenderMode.column,
                textStyle: TextStyle(fontSize: 12.sp),
              ),
            ),
          ]),
        ),
        if (val?.children?.length != 0)
          Column(
            children: [
              ...val!.children!.map((a) => Padding(
                    padding: EdgeInsets.only(left: 12.w),
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    minWidth: double.infinity, //宽度尽可能大
                    minHeight: double.infinity),
                child: Stack(
                  children: <Widget>[
                    // Positioned(
                    //     top: 0,
                    //     left: 0,
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 600,
                    //     child: WebViewWidget(controller: controller)),
                    Positioned(
                      top: 0,
                      left: 0,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Container(
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            // Positioned(
                            //   bottom: 200,
                            //   right: 100,
                            //   child: ElevatedButton(
                            //     child: Text("normal12"),
                            //     onPressed: () {
                            //       controller.reload();
                            //     },
                            //   ),
                            // ),
                            Positioned(
                              top: 0,
                              left: 0,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
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
                                                    ClipRRect(
                                                        borderRadius: BorderRadius.circular(4.w),
                                                        child: Image.network(item?.member?.avatarLarge ?? '', width: 26.w, height: 26.w, fit: BoxFit.cover)),
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
                                                                style: TextStyle(fontSize: 12.sp, height: 1.2),
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
                                                                style: TextStyle(fontSize: 10.sp, height: 1.2, color: Colors.grey),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 10),
                                                              child: Text(
                                                                (item?.clickCount.toString() ?? '') + '次点击',
                                                                style: TextStyle(fontSize: 10.sp, height: 1.2, color: Colors.grey),
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
                                                Padding(
                                                  padding: EdgeInsets.only(top: 6.w, bottom: 6.w),
                                                  child: Text(
                                                    item?.title ?? '',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                                                  ),
                                                ),
                                                HtmlWidget(
                                                  item?.headerTemplate ?? '',
                                                  renderMode: RenderMode.column,
                                                  textStyle: TextStyle(fontSize: 12.sp),
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
                                                style: TextStyle(fontSize: 10.sp, height: 1.2, color: Colors.grey),
                                              ),
                                              Text(
                                                '楼中楼',
                                                style: TextStyle(fontSize: 10.sp, height: 1.2, color: Colors.grey),
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
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
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
