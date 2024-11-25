import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:v2next/components/footer.dart';
import 'package:v2next/components/loading_list_page.dart';
import 'package:v2next/components/post_item.dart';
import 'package:v2next/http/api.dart';
import 'package:v2next/model/model.dart';

class MemberPostListPage extends StatefulWidget {
  const MemberPostListPage({Key? key}) : super(key: key);

  @override
  State<MemberPostListPage> createState() => _MemberPostListPageState();
}

class _MemberPostListPageState extends State<MemberPostListPage> {
  List<Post> list = [];
  int currentPage = 0;
  int totalPage = 1;
  int count = 1;
  bool showBackTopBtn = false;
  bool loading = true;
  bool loadingMore = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    loadingMore = true;
    setState(() {});
    Map res = await Api.memberPostList(Get.arguments, currentPage + 1);
    setState(() {
      if (currentPage == 0) {
        list = res['list'];
      } else {
        list.addAll(res['list']);
      }
      loadingMore = false;
      loading = false;
      currentPage += 1;
      totalPage = res['totalPage'];
      count = res['count'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('最近发布', style: TextStyle(fontSize: 16.sp)),
        actions: [if (count > 0) Text('主题总数 ${count}', style: Theme.of(context).textTheme.titleSmall), const SizedBox(width: 12)],
      ),
      body: Stack(
        children: [
          loading
              ? LoadingListPage()
              : EasyRefresh(
                  onLoad: totalPage > 1 && currentPage < totalPage ? getData : null,
                  onRefresh: () {
                    setState(() {
                      currentPage = 0;
                    });
                    getData();
                  },
                  footer: ClassicFooter(
                    hapticFeedback: true,
                    dragText: 'Pull to load',
                    armedText: 'Release ready',
                    readyText: 'Loading...',
                    processingText: '加载中...',
                    succeededIcon: const Icon(Icons.auto_awesome),
                    processedText: '加载完成',
                    textStyle: const TextStyle(fontSize: 14),
                    noMoreText: '加载完成',
                    noMoreIcon: const Icon(Icons.auto_awesome),
                    failedText: '加载失败',
                    messageText: '上次更新 %T',
                    triggerOffset: 100,
                    // position: IndicatorPosition.locator,
                  ),
                  child: ListView.builder(
                    physics: new AlwaysScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (list.length - 1 == index) {
                        return Column(
                          children: [
                            PostItem(item: list[index], tab: NodeItem(type: TabType.profile), space: false),
                            if (!loadingMore) FooterTips(loading: false),
                          ],
                        );
                      }
                      return PostItem(item: list[index], tab: NodeItem(type: TabType.profile), space: false);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
