import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2next/components/base_avatar.dart';
import 'package:v2next/components/base_button.dart';
import 'package:v2next/components/base_html.dart';
import 'package:v2next/model/base_controller.dart';
import 'package:v2next/model/model.dart';
import 'package:v2next/pages/post_detail/controller.dart';
import 'package:v2next/utils/const_val.dart';

class PostShare extends StatelessWidget {
  String postId;
  Reply? reply;
  ScreenshotController screenshotController = ScreenshotController();

  PostShare({required this.postId, this.reply});

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print('授权状态：$info');
  }

  Widget getShare({bool isShare = false}) {
    PostDetailController ctrl = Get.find(tag: postId);
    BaseController bc = BaseController.to;

    return Builder(builder: (context) {
      return Container(
        width: 1.sw,
        decoration: BoxDecoration(color: Colors.white, borderRadius: Const.borderRadiusWidget, border: Border.all(color: isShare ? Colors.transparent : Const.line2)),
        margin: EdgeInsets.all(isShare ? 0 : 4.w),
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.w, top: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reply == null) ...[
              Text(
                ctrl.post.title,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: bc.layout.fontSize * 1.2, height: bc.layout.lineHeight, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      BaseAvatar(src: ctrl.post.member.avatarLarge, diameter: bc.fontSize * 1.6, radius: bc.fontSize * 0.25),
                      SizedBox(width: 5.w),
                      Text(
                        ctrl.post.member.username == 'default' ? '' : ctrl.post.member.username,
                        style: TextStyle(fontSize: bc.fontSize * 0.8, height: 1.2, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ],
                  ),
                  //时间、点击量
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(DateTime.parse(ctrl.post.createDate)),
                      style: TextStyle(fontSize: bc.fontSize * 0.7, height: 1.2, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.w),
              Const.lineWidget,
              SizedBox(height: 10.w),
              ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: .3.sh,
                  ),
                  child: CommonHtml(html: ctrl.post.contentRendered)),
            ] else ...[
              Text('V2EX回复', style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold)),
              SizedBox(height: 20.w),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: Const.borderRadiusWidget,
                ),
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BaseAvatar(src: reply!.avatar, diameter: bc.fontSize * 1.6, radius: bc.fontSize * 0.25),
                        SizedBox(width: 5.w),
                        Text(
                          reply!.username == 'default' ? '' : ctrl.post.member.username,
                          style: TextStyle(fontSize: bc.fontSize, height: 1.2, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.w),
                    ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: 100.w,
                        ),
                        child: CommonHtml(html: reply!.replyContent)),
                    SizedBox(height: 40.w),
                    Text(
                      '——— ' + ctrl.post.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: bc.layout.fontSize * 0.9, height: bc.layout.lineHeight),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.w),
            ],
            SizedBox(height: 20.w),
            Center(
                child: Text(
              '本内容由 “V2Next” App分享生成，并不代表同意其观点或证实其描述',
              style: TextStyle(color: Colors.grey, fontSize: 10.sp),
            )),
            SizedBox(height: 10.w),
            Const.lineWidget,
            SizedBox(height: 10.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: .4.sw,
                    child: Center(
                      child: Image.asset('assets/images/v2ex@2x.png', height: 30.w),
                    )),
                SizedBox(
                  width: .45.sw,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('扫码阅读此帖子完整内容'),
                      ),
                      QrImageView(
                        data: Const.v2exHost + '/t/${ctrl.post.postId.toString()}',
                        version: QrVersions.auto,
                        size: 70.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 115.h,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: Const.cardRadius),
        child: Column(
          children: [
            SizedBox(
              height: 40.w,
              child: Center(child: Text('图片预览', style: TextStyle(fontSize: 16.sp))),
            ),
            Expanded(
              child: SingleChildScrollView(child: getShare()),
            ),
            SizedBox(height: 20.w),
            BaseButton(
              width: .8.sw,
              text: '下一步',
              theme: TDButtonTheme.primary,
              onTap: () {
                SmartDialog.showLoading();
                _requestPermission();
                double pixelRatio = MediaQuery.of(context).devicePixelRatio;
                screenshotController
                    .captureFromLongWidget(
                        InheritedTheme.captureAll(
                          context,
                          Material(
                            color: Colors.transparent,
                            child: getShare(isShare: true),
                          ),
                        ),
                        delay: Duration(milliseconds: 300),
                        context: context,
                        pixelRatio: pixelRatio,
                        constraints: BoxConstraints(
                          maxWidth: 1.sw,
                        ))
                    .then((Uint8List capturedImage) async {
                  Get.back();
                  final directory = await getApplicationDocumentsDirectory();
                  final imagePath = await File('${directory.path}/image.png').create();
                  await imagePath.writeAsBytes(capturedImage);
                  SmartDialog.dismiss();
                  await Share.shareXFiles([XFile(imagePath.path)]);
                });
              },
            ),
            SizedBox(height: 20.w),
          ],
        ),
      ),
    );
  }
}
