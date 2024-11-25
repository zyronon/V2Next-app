import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:v2next/http/api.dart';
import 'package:v2next/model/base_controller.dart';
import 'package:v2next/model/model.dart';

class MemberController extends GetxController {
  ModelMemberProfile info = ModelMemberProfile();
  BaseController bc = Get.find<BaseController>();
  Map signDetail = {};
  String memberId = '';
  String memberAvatar = '';
  String heroTag = '';
  bool isOwner = false;
  bool loading = false;

  @override
  void onInit() async {
    super.onInit();
    Member b = Get.arguments;
    memberId = b.username;
    memberAvatar = b.avatar;
    getData();
    if (bc.isLogin) {
      if (memberId == bc.member.username) {
        isOwner = true;
      }
    }
  }

  Future getData() async {
    loading = true;
    update();
    var res = await Api.memberInfo(memberId);
    // var res = await Api.queryMemberProfile('shzbkzo');
    loading = false;
    info = res;
    update();
  }

  Future<ModelMemberProfile> queryMemberProfile() async {
    var res = await Api.memberInfo(memberId);
    info = res;
    return res;
  }

  //  签到领取奖励
  void dailyMission() async {
    SmartDialog.showLoading(msg: '领取中...');
    // var res = await Api.dailyMission();
    // SmartDialog.dismiss();
    // SmartDialog.showToast(res);
    // queryDaily();
  }

  // 关注用户
  void onFollowMemeber(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: const Text('提示'),
            // content: Text('确认屏蔽${memberId}吗？'),
            content: Text.rich(TextSpan(children: [
              TextSpan(text: info.isFollow ? '确认不再关注用户 ' : '确认要开始关注用户 '),
              TextSpan(
                text: '@$memberId',
                style: Theme
                    .of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme
                    .of(context)
                    .colorScheme
                    .primary),
              ),
              const TextSpan(text: ' 吗')
            ])),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  onFollowReq();
                },
                child: const Text('确定'),
              ),
            ],
          ),
    );
  }

  Future<bool> onFollowReq() async {
    var followId = '';
    RegExp regExp = RegExp(r'\d{3,}');
    Iterable<Match> matches = regExp.allMatches(info.mbSort);
    for (Match m in matches) {
      followId = m.group(0)!;
    }
    bool followStatus = info.isFollow;
    bool res = await Api.onFollowMember(followId, followStatus);
    if (res) {
      SmartDialog.showToast(followStatus ? '已取消关注' : '关注成功');
      info.isFollow = !followStatus;
      update();
    } else {
      SmartDialog.showToast('操作失败');
    }
    return res;
  }

  // 屏蔽用户
  void onBlockMember(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: const Text('提示'),
            content: Text.rich(TextSpan(children: [
              TextSpan(text: info.isBlock ? '取消屏蔽用户 ' : '确认屏蔽用户 '),
              TextSpan(
                text: '@$memberId',
                style: Theme
                    .of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme
                    .of(context)
                    .colorScheme
                    .primary),
              ),
              const TextSpan(text: ' 吗')
            ])),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  onBlockReq();
                },
                child: Text(info.isBlock ? '取消屏蔽' : '确认屏蔽'),
              ),
            ],
          ),
    );
  }

  Future<bool> onBlockReq() async {
    var blockId = '';
    RegExp regExp = RegExp(r'\d{3,}');
    Iterable<Match> matches = regExp.allMatches(info.mbSort);
    for (Match m in matches) {
      blockId = m.group(0)!;
    }
    bool blockStatus = info.isBlock;
    // bool followStatus = memberProfile.isFollow;
    bool res = await Api.onBlockMember(blockId, blockStatus);
    if (res) {
      SmartDialog.showToast(blockStatus ? '已取消屏蔽' : '屏蔽成功');
      info.isBlock = !blockStatus;
      update();
      // if(!blockStatus && followStatus){
      //   memberProfile.isFollow = false;
      // }
    } else {
      SmartDialog.showToast('操作失败');
    }
    return res;
  }
}
