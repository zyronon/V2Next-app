import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/base_button.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/pages/post_detail/controller.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/utils/utils.dart';

class CallMemberList extends StatefulWidget {
  final String postId;

  const CallMemberList({required this.postId, Key? key}) : super(key: key);

  @override
  State<CallMemberList> createState() => _CallMemberListState();
}

class _CallMemberListState extends State<CallMemberList> with TickerProviderStateMixin {
  late PostDetailController pdc;
  bool isCheckAll = false; // 是否全选
  IconData iconData = Icons.done;
  late List<Reply> list;
  String searchKey = '';

  @override
  void initState() {
    super.initState();
    pdc = PostDetailController.to(widget.postId);
    List<Reply> atReplyList = Utils.clone(pdc.post.replyList);
    for (var i = 0; i < atReplyList.length; i++) {
      atReplyList[i].isChoose = false;
    }
    setState(() {
      var s = Reply();
      s.username = '管理员';
      s.replyText = '一键@所有管理员 @Livid @Kai @Olivia @GordianZ @sparanoid @drymonfidelia';
      list = atReplyList;
      list.insert(0, s);
    });
  }

  List<Reply> get searchList {
    if (searchKey.isEmpty) return list;
    return list.where((v) {
      return v.username.toLowerCase().contains(searchKey.toLowerCase()) || v.floor.toString().contains(searchKey);
    }).toList();
  }

  void _checkAll() {
    setState(() {
      searchList.forEach((v) {
        v.isChoose = !isCheckAll;
      });
      iconData = !isCheckAll ? Icons.done : Icons.done_all;
      isCheckAll = !isCheckAll;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // clipBehavior: Clip.hardEdge,
      height: MediaQuery.of(context).size.height - 115.h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: Const.cardRadius),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.w, bottom: 0.w),
            child: sheetHead(),
          ),
          TDSearchBar(
            placeHolder: '输入楼层号或用户名',
            needCancel: true,
            onTextChanged: (String text) {
              searchKey = text;
              setState(() {});
            },
          ),
          Expanded(
              child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: searchList.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == searchList.length) {
                return SizedBox(height: MediaQuery.of(context).padding.bottom);
              } else {
                return memberItem(searchList[index]);
              }
            },
          )),
          Container(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.w, bottom: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Const.line)),
              boxShadow: [Const.boxShadowTop],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BaseButton(
                  text: '确定',
                  theme: TDButtonTheme.primary,
                  onTap: () {
                    List atList = list.where((v) => v.isChoose).toSet().toList();
                    Navigator.pop(context, {'atList': atList});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget sheetHead() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 16.sp),
            children: [
              const TextSpan(text: '选择要'),
              const TextSpan(text: '@', style: TextStyle(fontWeight: FontWeight.w900)),
              const TextSpan(text: '的用户'),
            ],
          ),
        ),
        InkWell(
          onTap: _checkAll,
          child: Icon(
            !isCheckAll ? Icons.done : Icons.done_all,
            size: 28.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget memberItem(Reply replyItem) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 15.w, right: 5.w),
        margin: EdgeInsets.only(bottom: 10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(text: '${replyItem.username} ', style: TextStyle(fontSize: 16.sp)),
                  if (replyItem.floor != -1) TextSpan(text: ' ${replyItem.floor}楼', style: TextStyle(color: Colors.grey, fontSize: 11.sp))
                ])),
                Text(replyItem.replyText, maxLines: 2, style: TextStyle(color: Colors.grey, fontSize: 12.sp))
              ],
            )),
            Transform.scale(
              scale: 0.8,
              child: Checkbox(
                value: replyItem.isChoose,
                onChanged: (bool? checkValue) {
                  setState(() {
                    replyItem.isChoose = checkValue!;
                  });
                },
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pop(context, {
          'atList': [replyItem]
        });
      },
    );
  }
}
