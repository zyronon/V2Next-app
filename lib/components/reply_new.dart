import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:v2ex/components/BaseHtmlWidget.dart';
import 'package:v2ex/components/image_loading.dart';
import 'package:v2ex/components/member_list.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/pages/post_detail.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:get/get.dart';
import 'package:v2ex/components/extended_text/selection_controls.dart';
import 'package:v2ex/components/extended_text/text_span_builder.dart';
import 'package:v2ex/utils/topic.dart';
import 'package:v2ex/utils/string.dart';
import 'package:v2ex/utils/utils.dart';
import 'package:v2ex/model/BaseController.dart';

class ReplyNew extends StatefulWidget {
  final List<Reply>? replyMemberList;
  final String topicId;
  final List<Reply>? replyList;

  const ReplyNew({
    this.replyMemberList,
    required this.topicId,
    this.replyList,
    super.key,
  });

  @override
  State<ReplyNew> createState() => _ReplyNewState();
}

class _ReplyNewState extends State<ReplyNew> with WidgetsBindingObserver {
  PostDetailController pdc = PostDetailController.to();

  final TextEditingController _replyContentController = TextEditingController();
  final MyTextSelectionControls _myExtendedMaterialTextSelectionControls = MyTextSelectionControls();
  final GlobalKey<ExtendedTextFieldState> _key = GlobalKey<ExtendedTextFieldState>();

  final GlobalKey _formKey = GlobalKey<FormState>();

  // late String _replyContent = '';
  final statusBarHeight = GStorage().getStatusBarHeight();
  List atReplyList = []; // @用户列表
  List atMemberList = []; // 选中的用户列表
  final FocusNode replyContentFocusNode = FocusNode();

  // bool _isKeyboardActived = true; // 当前键盘是否是激活状态
  double _keyboardHeight = 0.0; // 键盘高度
  final _debouncer = Debouncer(milliseconds: 100); // 设置延迟时间
  Timer? timer;
  String myUserName = '';
  bool ableClean = false;
  double _emoticonHeight = 0.0;
  String toolbarType = 'input';
  BaseController bc = Get.find<BaseController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 监听输入框聚焦
    // replyContentFocusNode.addListener(_onFocus);
    _replyContentController.addListener(_printLatestValue);
    // 界面观察者 必须
    WidgetsBinding.instance.addObserver(this);
    myUserName = bc.member.username;
  }

  Future<dynamic> onSubmit() async {
    /// ExtendedTextField 不支持validator always true
    if ((_formKey.currentState as FormState).validate()) {
      //验证通过提交数据
      (_formKey.currentState as FormState).save();

      String _replyContent = _replyContentController.text;
      _replyContent = _replyContent.splitMapJoin(RegExp(r"\[k_.*?\]"),
          onMatch: (match) {
            String matched = match[0]!.substring(1, match[0]!.length - 1);
            if (Strings.coolapkEmoticon.keys.contains(matched)) {
              return '${Strings.coolapkEmoticon[matched]!} ';
            }
            return matched;
          },
          onNonMatch: (String str) => str);
      String replyUser = '';
      // 有且只有一个
      if (widget.replyMemberList!.isNotEmpty) {
        for (var i in widget.replyMemberList!) {
          replyUser += '@${i.username} #${i.floor}  ';
        }
      }
      // print(_replyContent);
      // return;
      var res = await TopicWebApi.onSubmitReplyTopic(widget.topicId, replyUser + _replyContent);
      if (res == 'true') {
        if (context.mounted) {
          Navigator.pop(context, {'replyStatus': 'success'});
        }
      } else if (res == 'success') {
        if (context.mounted) {
          Navigator.pop(context, {'replyStatus': 'fail'});
        }
      } else {
        SmartDialog.show(
          useSystem: true,
          animationType: SmartAnimationType.centerFade_otherSlide,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('系统提示'),
              content: Text(res),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('确定'))
              ],
            );
          },
        );
      }
    }
  }

  void onShowMember(context, {type = 'input'}) {
    if (widget.replyList == null) {
      print('reply_new: widget.replyList为null');
      return;
    }
    // Don't use 'BuildContext's across async gaps 防止异步函数丢失上下文，传入context
    List<Reply> atReplyList = List.from(widget.replyList!);
    if (atReplyList.isEmpty) {
      // 主题无回复时，不显示@面板，不失焦
      return;
    }
    // 键盘收起
    replyContentFocusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 300), () {
      for (var i = 0; i < atReplyList.length; i++) {
        atReplyList[i].isChoose = false;
      }
      setState(() {
        atReplyList = atReplyList;
      });
      print(atReplyList.length);
      showModalBottomSheet<Map>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ReplyMemberList(
            replyList: atReplyList,
          );
        },
      ).then((value) {
        if (value != null) {
          if (value.containsKey('checkStatus')) {
            // 全选 去重去本人 不显示楼层
            List<Reply> atMemberList = value['atMemberList'];
            Set<String> set = {}; // 定义一个空集合
            for (var i = 0; i < atMemberList.length; i++) {
              if (atMemberList[i].username != myUserName) {
                set.add(atMemberList[i].username);
              }
            }
            List newAtMemberList = set.toList();
            for (int i = 0; i < newAtMemberList.length; i++) {
              String atUserName = '';
              if (i == 0) {
                atUserName = type == 'input' ? newAtMemberList[i] : '@${newAtMemberList[i]}';
              } else {
                atUserName = '@${newAtMemberList[i]}';
              }
              _replyContentController.text = '${_replyContentController.text}$atUserName ';
            }
          } else {
            // @单用户
            setState(() {
              atMemberList = value['atMemberList'];
              String atUserName = atMemberList[0].username;
              int atFloor = atMemberList[0].floor;
              _replyContentController.text = '${_replyContentController.text} ${type == "input" ? atUserName : "@$atUserName"} #$atFloor ';
            });
          }
        }
        if (value == null) {
          // @多用户 / 没有@用户
          var atMemberList = atReplyList.where((i) => i.isChoose).toList();
          if (atMemberList.isNotEmpty) {
            setState(() {
              atMemberList = atMemberList;
            });
            for (int i = 0; i < atMemberList.length; i++) {
              String atUserName = '';
              int atFloor = atMemberList[i].floor;
              if (i == 0) {
                atUserName = atMemberList[i].username;
              } else {
                atUserName = '@${atMemberList[i].username}';
              }
              _replyContentController.text = '${_replyContentController.text}$atUserName #$atFloor ';
            }
          }
        }
        // 移动光标
        _replyContentController.selection = TextSelection.fromPosition(TextPosition(offset: _replyContentController.text.length));
        // 聚焦
        FocusScope.of(context).requestFocus(replyContentFocusNode);
      });
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 键盘高度
      final viewInsets = EdgeInsets.fromWindowPadding(WidgetsBinding.instance.window.viewInsets, WidgetsBinding.instance.window.devicePixelRatio);
      _debouncer.run(() {
        if (mounted) {
          setState(() {
            _keyboardHeight = _keyboardHeight == 0.0 ? viewInsets.bottom : _keyboardHeight;
            _emoticonHeight = _emoticonHeight == 0.0 ? viewInsets.bottom : _emoticonHeight;
          });
        }
      });
    });
  }

  _onFocus() {
    if (replyContentFocusNode.hasFocus) {
      // 聚焦时候的操作
      // _isKeyboardActived = true;
      toolbarType = 'input';
      return;
    }
    // 失去焦点时候的操作
    // _isKeyboardActived = false;
    setState(() {});
  }

  _printLatestValue() {
    setState(() {
      ableClean = _replyContentController.text != '';
    });
  }

  void insertText(String text) {
    final TextEditingValue value = _replyContentController.value;
    final int start = value.selection.baseOffset;
    int end = value.selection.extentOffset;
    if (value.selection.isValid) {
      String newText = '';
      if (value.selection.isCollapsed) {
        if (end > 0) {
          newText += value.text.substring(0, end);
        }
        newText += text;
        if (value.text.length > end) {
          newText += value.text.substring(end, value.text.length);
        }
      } else {
        newText = value.text.replaceRange(start, end, text);
        end = start;
      }

      _replyContentController.value = value.copyWith(text: newText, selection: value.selection.copyWith(baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      _replyContentController.value = TextEditingValue(text: text, selection: TextSelection.fromPosition(TextPosition(offset: text.length)));
    }

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _key.currentState?.bringIntoView(_replyContentController.selection.base);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // replyContentFocusNode.dispose();
    _replyContentController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      // height: MediaQuery.of(context).size.height - statusBarHeight * 2,
      // padding: const EdgeInsets.only(top: 25, left: 12, right: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 12, right: 12, top: 12),
      child: Column(
        children: [
          if (pdc.reply.id.isNotEmpty) ...[
            Container(
                margin: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('回复：'),
                        Text(pdc.reply.username,style: TextStyle(fontSize: 15)),
                        SizedBox(width: 4),
                        Text('${pdc.reply.floor.toString()}楼',style: TextStyle(fontSize: 12,color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 4),
                    BaseHtmlWidget(
                      ellipsis: true,
                      html: pdc.reply.replyContent,
                    )
                  ],
                )),
          ],
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ExtendedTextField(
                    key: _key,
                    selectionControls: _myExtendedMaterialTextSelectionControls,
                    specialTextSpanBuilder: MySpecialTextSpanBuilder(controller: _replyContentController),
                    controller: _replyContentController,
                    minLines: 2,
                    maxLines: 4,
                    autofocus: true,
                    focusNode: replyContentFocusNode,
                    decoration: const InputDecoration(hintText: "请尽量让自己的回复能够对别人有帮助", border: InputBorder.none),
                    style: TextStyle(fontSize: 14),
                    // validator: (v) {
                    //   return v!.trim().isNotEmpty ? null : "请输入回复内容";
                    // },
                    onChanged: (value) {
                      if (value.endsWith('@')) {
                        print('TextFormField 唤起');
                        onShowMember(context);
                      }
                    },
                    // onSaved: (val) {
                    //   _replyContent = val!;
                    // },
                    // textSelectionGestureDetectorBuilder: ({
                    //   required ExtendedTextSelectionGestureDetectorBuilderDelegate
                    //       delegate,
                    //   required Function showToolbar,
                    //   required Function hideToolbar,
                    //   required Function? onTap,
                    //   required BuildContext context,
                    //   required Function? requestKeyboard,
                    // }) {
                    //   return MyCommonTextSelectionGestureDetectorBuilder(
                    //     delegate: delegate,
                    //     showToolbar: showToolbar,
                    //     hideToolbar: hideToolbar,
                    //     onTap: () {},
                    //     context: context,
                    //     requestKeyboard: requestKeyboard,
                    //   );
                    // },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                          onPressed: () => onShowMember(context, type: 'click'),
                          icon: Icon(
                            Icons.alternate_email_rounded,
                            size: 22,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          highlightColor: Theme.of(context).colorScheme.onInverseSurface,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          )),
                    ),
                    const SizedBox(width: 3),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: IconButton(
                          onPressed: () {
                            toolbarType = 'emoticon';
                            replyContentFocusNode.unfocus();
                          },
                          icon: Icon(
                            Icons.emoji_emotions,
                            size: 22,
                            color: toolbarType == 'emoticon' ? Theme.of(context).colorScheme.onBackground : Theme.of(context).colorScheme.outline,
                          ),
                          highlightColor: Theme.of(context).colorScheme.onInverseSurface,
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              return toolbarType == 'emoticon' ? Theme.of(context).highlightColor : null;
                            }),
                          )),
                    ),
                    const SizedBox(width: 3),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: IconButton(
                        onPressed: () async {
                          var res = await Utils().uploadImage();
                          _replyContentController.text = '${_replyContentController.text}${res['link']}';
                          _replyContentController.selection = TextSelection.fromPosition(TextPosition(offset: _replyContentController.text.length));
                        },
                        icon: Icon(
                          Icons.image,
                          size: 22,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(14.w, 6.w, 14.w, 6.w),
                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6.r)),
                        child: Text(
                          '回复',
                          style: TextStyle(fontSize: 14.sp, color: Colors.white),
                        ),
                      ),
                      onTap: ableClean ? onSubmit : null,
                    )
                    // IconButton(
                    //     onPressed: () {}, icon: const Icon(Icons.clear_all)),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          AnimatedSize(
            curve: Curves.linear,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: double.infinity,
              height: toolbarType == 'input' ? _keyboardHeight : _emoticonHeight,
              padding: const EdgeInsets.only(left: 4, right: 4),
              // decoration: BoxDecoration(border: Border.all()),
              child: GridView.builder(
                padding: EdgeInsets.only(top: 4, bottom: MediaQuery.of(context).padding.bottom),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8, crossAxisSpacing: 4, mainAxisSpacing: 4, childAspectRatio: 1),
                itemCount: Strings.coolapkEmoticon.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      insertText('[${Strings.coolapkEmoticon.keys.toList()[index]}]');
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: ImageLoading(
                        imgUrl: Strings.coolapkEmoticon.values.toList()[index],
                      ),
                    ),
                  );
                  // return CustomLoading();
                },
              ),
            ),
          ),

        ],
      ),
    ));
  }
}

typedef void DebounceCallback();

class Debouncer {
  DebounceCallback? callback;
  final int? milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(DebounceCallback callback) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), () {
      callback();
    });
  }
}
