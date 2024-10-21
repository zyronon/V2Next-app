import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/BaseAvatar.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/utils/ConstVal.dart';
import 'package:v2ex/utils/api.dart';

class DiscoverController extends GetxController {
  List<Post2> list = [];
  bool loading = false;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    loading = true;
    update();
    list = await Api.getTodayHotPostList();
    loading = false;
    update();
  }
}

class DiscoverPage extends StatefulWidget {
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder(
        init: DiscoverController(),
        builder: (_) {
          return RefreshIndicator(
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    TDSearchBar(
                      placeHolder: '搜索',
                      onTextChanged: (String text) {},
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 14.w, right: 14.w),
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.w),
                            Container(
                              padding: Const.paddingWidget,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: Const.borderRadiusWidget),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        child: Icon(Icons.rss_feed, color: Colors.white, size: 30.w),
                                        padding: EdgeInsets.all(6.w),
                                        decoration: BoxDecoration(color: Color(0xffe27938), borderRadius: BorderRadius.circular(100.r)),
                                      ),
                                      SizedBox(width: 10.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('VXNA', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text(
                                            'V2EX博客聚合器',
                                            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.w),
                            Text('🔥今日热议', style: TextStyle()),
                            SizedBox(height: 10.w),
                            Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: Const.borderRadiusWidget),
                              child: Column(
                                children: [
                                  if (_.list.isEmpty)
                                    ...List.filled(7, false).map((v) => Skeletonizer.zone(
                                          child: Container(
                                            padding: EdgeInsets.only(top: Const.padding, left: Const.padding, right: Const.padding, bottom: Const.padding),
                                            decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(color: Const.line)),
                                            ),
                                            child: Row(children: [Bone.circle(size: 32), SizedBox(width: 10.w), Expanded(child: Bone.multiText())]),
                                          ),
                                        )),
                                  if (_.list.isNotEmpty)
                                    ..._.list.map((v) => InkWell(
                                          child: Container(
                                            padding: EdgeInsets.only(top: Const.padding, left: Const.padding, right: Const.padding, bottom: Const.padding),
                                            decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(color: Const.line)),
                                            ),
                                            child: Row(children: [
                                              BaseAvatar(src: v.member.avatar, diameter: 34.w, radius: 6.r),
                                              SizedBox(width: 10.w),
                                              Expanded(child: Text(v.title)),
                                            ]),
                                          ),
                                          onTap: () => Get.toNamed('/post-detail', arguments: v),
                                        ))
                                ],
                              ),
                            ),
                            SizedBox(height: 100.w),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ),
              onRefresh: _.getData);
        });
  }

  @override
  bool get wantKeepAlive => true;
}
