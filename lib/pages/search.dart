import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:v2ex/components/back.dart';
import 'package:v2ex/components/base_divider.dart';
import 'package:v2ex/http/api.dart';
import 'package:v2ex/model/model.dart';
import 'package:v2ex/utils/storage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const String googlePrefix = 'https://www.google.com/search?q=site:v2ex.com/t%20 ';
  static const String sov2exPrefix = 'https://www.sov2ex.com/?q=';
  final FocusNode _focusNode = FocusNode();
  late TextEditingController editingController = new TextEditingController();
  late InAppWebViewController webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );

  PullToRefreshController? pullToRefreshController;
  double progress = 1;
  String searchKey = '';
  String inputKey = '';
  List<NodeItem> list = [];
  List<String> historyList = GStorage().getSearchList();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  init() async {
    if (Get.arguments != null) search(val: Get.arguments);
    pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          webViewController.loadUrl(urlRequest: URLRequest(url: await webViewController.getUrl()));
        }
      },
    );
    var allNodes = GStorage().getAllNodes();
    if (allNodes.isEmpty) {
      list = await Api.getAllNode();
    } else {
      list = allNodes.map((e) => NodeItem.fromJson(e)).toList();
    }

    // 监听焦点变化
    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          if (searchKey.isNotEmpty) {
            inputKey = searchKey;
          }
        }
      });
    });
  }

  List<NodeItem> get searchList {
    if (inputKey.isEmpty) return [];
    var s = list.where((v) {
      return v.name.toLowerCase().contains(inputKey.toLowerCase()) || v.title.toString().contains(inputKey);
    }).toList();
    return s.sublist(0, s.length > 6 ? 6 : s.length);
  }

  search({String val = '', String prefix = googlePrefix}) {
    setState(() {
      if (searchKey.isNotEmpty) {
        webViewController.loadUrl(urlRequest: URLRequest(url: WebUri('$prefix${val.toString()}')));
      }
      searchKey = val;
      inputKey = '';
      historyList.add(val);
      historyList = historyList.toSet().toList();
      GStorage().setSearchList(historyList);
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        body: SafeArea(
            child: DefaultTextStyle(
                style: GoogleFonts.notoSansSc(textStyle: TextStyle(color: Colors.black, fontSize: 16.sp, height: 1)),
                child: Column(children: <Widget>[
                  Row(
                    children: [
                      Back(),
                      Expanded(
                          child: TDSearchBar(
                        controller: editingController,
                        focusNode: _focusNode,
                        autoFocus: searchKey.isEmpty,
                        placeHolder: '搜索',
                        padding: EdgeInsets.fromLTRB(0, 8, 16, 8),
                        onTextChanged: (val) {
                          setState(() {
                            inputKey = val;
                          });
                        },
                        onSubmitted: (val) {
                          search(val: val.toString());
                        },
                      ))
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        if (searchKey.isNotEmpty) ...[
                          InAppWebView(
                            initialSettings: settings,
                            pullToRefreshController: pullToRefreshController,
                            onWebViewCreated: (controller) {
                              webViewController = controller;
                              editingController.text = searchKey;
                              webViewController.loadUrl(urlRequest: URLRequest(url: WebUri('$googlePrefix $searchKey')));
                            },
                            onPermissionRequest: (controller, request) async {
                              return PermissionResponse(resources: request.resources, action: PermissionResponseAction.GRANT);
                            },
                            shouldOverrideUrlLoading: (controller, navigationAction) async {
                              var uri = navigationAction.request.url!;
                              print('issssssssssssssssssss：${uri}');
                              if (uri.toString().contains('v2ex.com/t/')) {
                                var match = RegExp(r'(\d+)').allMatches(uri.toString().replaceAll('v2ex.com/t/', ''));
                                var result = match.map((m) => m.group(0)).toList();
                                Get.toNamed('/post_detail', arguments: Post(postId: int.parse(result[0]!)));
                                return NavigationActionPolicy.CANCEL;
                              }
                              return NavigationActionPolicy.ALLOW;
                            },
                            onLoadStop: (controller, url) async {
                              pullToRefreshController?.endRefreshing();
                            },
                            onReceivedError: (controller, request, error) {
                              pullToRefreshController?.endRefreshing();
                            },
                            onProgressChanged: (controller, progress) {
                              if (progress == 100) {
                                pullToRefreshController?.endRefreshing();
                              }
                              setState(() {
                                this.progress = progress / 100;
                              });
                            },
                          ),
                          progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
                        ],
                        if (inputKey.isNotEmpty)
                          Positioned.fill(
                              child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                InkWell(
                                    child: Container(
                                      padding: EdgeInsets.all(12.w),
                                      alignment: Alignment.centerLeft,
                                      child: Text('Google $inputKey'),
                                    ),
                                    onTap: () {
                                      search(val: inputKey.toString());
                                    }),
                                BaseDivider(),
                                // InkWell(
                                //     child: Container(
                                //       padding: EdgeInsets.all(12.w),
                                //       alignment: Alignment.centerLeft,
                                //       child: Text('SoV2EX $inputKey'),
                                //     ),
                                //     onTap: () {
                                //       search(val: inputKey.toString(), prefix: sov2exPrefix);
                                //     }),
                                // BaseDivider(),
                                if (searchList.isNotEmpty) ...[
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    alignment: Alignment.centerLeft,
                                    child: Text('节点'),
                                  ),
                                  Column(
                                    children: searchList.map((v) {
                                      return InkWell(
                                          child: Container(
                                            padding: EdgeInsets.all(12.w),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              v.title + '/' + v.name,
                                              style: TextStyle(color: Colors.black54),
                                            ),
                                          ),
                                          onTap: () {
                                            Get.toNamed('/node_detail', arguments: V2Node.fromJson(v.toJson()));
                                          });
                                    }).toList(),
                                  ),
                                ]
                              ],
                            ),
                          )),
                        if (inputKey.isEmpty && searchKey.isEmpty)
                          Positioned.fill(
                              child: Container(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('搜索记录'),
                                    InkWell(
                                      child: Text('清空', style: TextStyle(color: Colors.grey)),
                                      onTap: () {
                                        historyList = [];
                                        GStorage().setSearchList(historyList);
                                        setState(() {});
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(height: 20.w),
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: historyList
                                        .map((v) => InkWell(
                                            child: TDTag(v, size: TDTagSize.large),
                                            onTap: () {
                                              search(val: v);
                                            }))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      ],
                    ),
                  ),
                ]))));
  }
}
