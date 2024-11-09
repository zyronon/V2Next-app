import 'dart:async';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/base_avatar.dart';
import 'package:v2ex/components/base_html.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/model/BaseController.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/pages/login/login.dart';
import 'package:v2ex/pages/post_detail/components/call_member_list.dart';
import 'package:v2ex/utils/const_val.dart';
import 'package:v2ex/utils/storage.dart';
import 'package:v2ex/utils/utils.dart';

import '../controller.dart';
import 'extended_text/emoji_text.dart';
import 'extended_text/text_span_builder.dart';

enum Status { input, emoji, call, image }

class EditorController extends GetxController {
  Status status = Status.input;
  var text = ''.obs;
  var _keyboardHeight = 0.0.obs;
  var atReplyList = [].obs;
  var uploading = false.obs;

  bool get disabled => text.value == '';

  setStatus(Status val) {
    status = val;
    update();
  }
}

class Editor extends StatefulWidget {
  final String postId;

  const Editor({
    required this.postId,
    super.key,
  });

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> with WidgetsBindingObserver {
  EditorController ec = Get.put(EditorController());
  BaseController bc = Get.find<BaseController>();
  late PostDetailController pdc;

  final TextEditingController editorController = TextEditingController();
  final GlobalKey<ExtendedTextFieldState> _key = GlobalKey<ExtendedTextFieldState>();

  final GlobalKey _formKey = GlobalKey<FormState>();

  final statusBarHeight = GStorage().getStatusBarHeight();
  List atReplyList = []; // @用户列表
  List atMemberList = []; // 选中的用户列表
  final FocusNode focusNode = FocusNode();

  final _debouncer = Debouncer(milliseconds: 100); // 设置延迟时间
  Timer? timer;

  @override
  void initState() {
    super.initState();
    pdc = PostDetailController.to(widget.postId);
    // 监听输入框聚焦
    focusNode.addListener(() {
      print(focusNode.hasFocus);
      if (focusNode.hasFocus) {
        ec.setStatus(Status.input);
      }
    });
    editorController.addListener(() {
      ec.text.value = editorController.text;
    });
    if (pdc.reply.id.isNotEmpty) {
      editorController.text = '@${pdc.reply.username} #${pdc.reply.floor} ';
    }
    // 界面观察者 必须
    WidgetsBinding.instance.addObserver(this);
  }

  Future<dynamic> onSubmit() async {
    /// ExtendedTextField 不支持validator always true
    if ((_formKey.currentState as FormState).validate()) {
      //验证通过提交数据
      (_formKey.currentState as FormState).save();

      String replyContent = editorController.text;
      String submit_content = replyContent.splitMapJoin(RegExp(r"\[.*?\]"),
          onMatch: (match) {
            if (EmojiUtil.instance.lowEmojiMap.containsKey(match[0])) {
              return '${EmojiUtil.instance.lowEmojiMap[match[0]]!} ';
            }
            return match[0]!;
          },
          onNonMatch: (String str) => str);

      //转换上传的图片
      String show_content = replyContent.splitMapJoin(RegExp(r"https?:\/\/(i\.)?imgur\.com\/((?!http).)+\.(gif|png|jpg|jpeg|GIF|PNG|JPG|JPEG)"),
          onMatch: (match) {
            return '<img src="${match[0]!}" style="max-width: 100%">';
          },
          onNonMatch: (String str) => str);

      //转换表情
      show_content = show_content.splitMapJoin(RegExp(r"\[.*?\]"),
          onMatch: (match) {
            if (EmojiUtil.instance.lowEmojiMap.containsKey(match[0])) {
              var val = EmojiUtil.instance.lowEmojiMap[match[0]];
              return '<img src="${val}" style="max-width: 100%">';
            }
            return match[0]!;
          },
          onNonMatch: (String str) => str);

      //转换表情
      show_content = show_content.splitMapJoin(RegExp(r"@([\w]+?[\s])"),
          onMatch: (match) {
            var val = match[0]!.replaceAll('@', '').trim();
            return '@<a href="/member/${val}">${val}</a> ';
          },
          onNonMatch: (String str) => str);

      show_content = show_content.replaceAll('\n', '<br/>');

      print('submit_content：${submit_content}');
      print("show_content：${show_content}");
      var res = await Api.onSubmitReplyTopic(id: widget.postId, val: submit_content);
      if (res.success) {
        //TODO 需要预处理
        var item = new Reply();
        item.replyContent = show_content;
        item.replyText = show_content;
        item.hideCallUserReplyContent = show_content;
        item.username = bc.member.username;
        item.avatar = bc.member.avatar;
        item.date = '刚刚';
        item.floor = pdc.post.replyCount + 1;
        item.isOp = bc.member.username == pdc.post.username;
        var parsedContent = Utils.parseReplyContent(item.replyContent);
        item.replyUsers = parsedContent['users'];
        item.replyFloor = parsedContent['floor'];
        if (item.replyUsers.length == 1) {
          item.hideCallUserReplyContent = item.replyContent.replaceAll(RegExp(r'@<a href="/member/[\s\S]+?</a>(\s#[\d]+)?\s(<br>)?'), '');
        }
        pdc.post.replyList.add(item);
        pdc.rebuildList();
        Get.back();
      } else {
        Utils.toast(msg: res.msg);
      }
    }
  }

  void onShowMember(context, {type = 'input'}) {
    ec.setStatus(Status.call);
    focusNode.unfocus();
    Future.delayed(const Duration(milliseconds: 300), () {
      showMaterialModalBottomSheet<Map>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return CallMemberList(postId: widget.postId);
        },
      ).then((value) {
        if (value != null) {
          List<Reply> atList = value['atList'];
          for (int i = 0; i < atList.length; i++) {
            var v = atList[i];
            if(v.username == '管理员'){
              v.username = 'Livid @Kai @Olivia @GordianZ @sparanoid @drymonfidelia';
            }
            String floor = v.floor==-1?'':' #${v.floor}';
            String str = '';
            if (i == 0) {
              str = '${type == 'input' ? '' : ' @'}${v.username}${floor}';
            } else {
              str = ' @${v.username}${floor}';
            }
            editorController.text = '${editorController.text}$str ';
          }
        }
        // 移动光标
        editorController.selection = TextSelection.fromPosition(TextPosition(offset: editorController.text.length));
        setState(() {});
        // 聚焦
        FocusScope.of(context).requestFocus(focusNode);
      });
    });
  }

  void insertText(String text) {
    print('inserText${text}');
    final TextEditingValue value = editorController.value;
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

      editorController.value = value.copyWith(text: newText, selection: value.selection.copyWith(baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      editorController.value = TextEditingValue(text: text, selection: TextSelection.fromPosition(TextPosition(offset: text.length)));
    }

    setState(() {});

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _key.currentState?.bringIntoView(editorController.selection.base);
    });
  }

  Widget _buildEmojiTitle(String title) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(bottom: 10.w, top: 10.w),
        child: Text(title),
      ),
    );
  }

  Widget _buildEmojiList(List val) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8, crossAxisSpacing: 4, mainAxisSpacing: 4, childAspectRatio: 1),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              val[index] is Map ? insertText('[${val[index]['name']}]') : insertText(val[index]);
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: val[index] is Map ? Image.asset('assets/emoji/${val[index]['name']!}.png', width: 25.w, height: 25.w) : Text(val[index], style: TextStyle(fontSize: 22.sp)),
            ),
          );
        },
        childCount: val.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetX<EditorController>(builder: (_) {
      return SingleChildScrollView(
          child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: Const.cardRadius),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, left: 12, right: 12, top: 18),
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
                          BaseAvatar(src: pdc.reply.avatar, diameter: 24, radius: 5),
                          SizedBox(width: 4),
                          Text(pdc.reply.username, style: TextStyle(fontSize: 15)),
                          SizedBox(width: 4),
                          Text('${pdc.reply.floor.toString()}楼', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 4),
                      BaseHtml(
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
                      specialTextSpanBuilder: MySpecialTextSpanBuilder(controller: editorController),
                      controller: editorController,
                      minLines: 2,
                      maxLines: 5,
                      autofocus: true,
                      focusNode: focusNode,
                      decoration: const InputDecoration(hintText: "请尽量让自己的回复能够对别人有帮助", border: InputBorder.none),
                      style: TextStyle(fontSize: 14),
                      onChanged: (value) {
                        if (value.endsWith('@')) {
                          print('TextFormField 唤起');
                          onShowMember(context);
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (ec.uploading.value) ...[
                            TDLoading(
                              size: TDLoadingSize.small,
                              icon: TDLoadingIcon.circle,
                              iconColor: TDTheme.of(context).grayColor8,
                            ),
                            SizedBox(width: 10.w),
                            Text('上传中...')
                          ]
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (ec.status == Status.emoji) {
                                ec.setStatus(Status.input);
                                focusNode.requestFocus();
                              } else {
                                ec.setStatus(Status.emoji);
                                focusNode.unfocus();
                              }
                            },
                            child: Icon(
                              ec.status == Status.emoji ? Icons.keyboard : Icons.mood,
                              size: 22,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () => onShowMember(context, type: 'click'),
                            child: Icon(
                              Icons.alternate_email_rounded,
                              size: 22,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () async {
                              ec.setStatus(Status.image);
                              ec.uploading.value = true;
                              Result? res = await Utils().uploadImage();
                              ec.uploading.value = false;
                              if (res != null) {
                                if (res.success) {
                                  editorController.text = '${editorController.text} ${res.data['link']} ';
                                  editorController.selection = TextSelection.fromPosition(TextPosition(offset: editorController.text.length));
                                  setState(() {});
                                } else {
                                  Utils.toast(msg: '上传失败');
                                }
                              }
                            },
                            child: Icon(
                              Icons.crop_original,
                              size: 22,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 15),
                          if (!bc.isLogin) ...[
                            TDButton(
                              text: '登录后回复',
                              size: TDButtonSize.small,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                              onTap: () async {
                                await Get.to(LoginPage());
                                pdc.update();
                                bc.update();
                                ec.update();
                                await Api.pullOnce();
                              },
                            )
                          ] else ...[
                            TDButton(
                              text: '回复',
                              size: TDButtonSize.small,
                              type: TDButtonType.fill,
                              shape: TDButtonShape.rectangle,
                              theme: TDButtonTheme.primary,
                              disabled: ec.disabled,
                              onTap: onSubmit,
                            ),
                          ]
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            AnimatedSize(
              curve: Curves.linear,
              duration: const Duration(milliseconds: 100),
              child: Container(
                width: double.infinity,
                height: ec.status == Status.emoji ? ec._keyboardHeight.value : 0,
                padding: const EdgeInsets.only(left: 4, right: 4),
                // decoration: BoxDecoration(border: Border.all()),
                child: CustomScrollView(
                  slivers: [
                    _buildEmojiTitle('经典表情'),
                    _buildEmojiList(Const.classicsEmoticons),
                    _buildEmojiTitle(Const.emojiEmoticons[0]['title']),
                    _buildEmojiList(Const.emojiEmoticons[0]['list']),
                    _buildEmojiTitle(Const.emojiEmoticons[1]['title']),
                    _buildEmojiList(Const.emojiEmoticons[1]['list']),
                    _buildEmojiTitle(Const.emojiEmoticons[2]['title']),
                    _buildEmojiList(Const.emojiEmoticons[2]['list']),
                    _buildEmojiTitle(Const.emojiEmoticons[3]['title']),
                    _buildEmojiList(Const.emojiEmoticons[3]['list']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
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
          if (ec._keyboardHeight.value == 0.0) {
            ec._keyboardHeight.value = viewInsets.bottom;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    editorController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
