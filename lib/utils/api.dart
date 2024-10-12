import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';
import 'package:v2ex/model/Post2.dart';
import 'package:v2ex/model/TabItem.dart';
import 'package:v2ex/utils/request.dart';
import 'package:v2ex/utils/utils.dart';

class Api {
  //获取
  static getPostListByTab({required TabType type, required String id, int pageNo = 0}) async {
    Response response;
    switch (type) {
      case TabType.tab:
        response = await Http().get('/', data: {'tab': id});
        break;
      case TabType.node:
        NodeListModel s = await getNodePageInfo(nodeId: id, pageNo: pageNo);
        return s.topicList;
      // case 'changes':
      //   return await getTopicsRecent('changes', p).then((value) => value);
      // case TabType.node:
      // var r = await getTopicsByNodeId(id, p);
      // res['topicList'] = r.topicList;
      // return res;
      // break;
      default:
        response = await Http().get('/', data: {'tab': 'all'});
        break;
    }

    Document document = parse(response.data);
    List<Element> aRootNode = document.querySelectorAll("div[class='cell item']");

    try {
      // Read().mark(topicList);
    } catch (err) {
      print(err);
    }
    return Utils().parsePagePostList(aRootNode);
  }

  static getNodePageInfo({required String nodeId, int pageNo = 0}) async {
    NodeListModel detailModel = NodeListModel();
    Response response;

    //手机端 收藏人数获取不到
    response = await Http().get('/go/$nodeId', data: {'p': pageNo}, isMobile: false);
    var document = parse(response.data);
    if (response.realUri.toString() == '/') {
      //TODO 无权限
      return detailModel;
    }
    var mainBox = document.body!.children[1].querySelector('#Main');
    var mainHeader = document.querySelector('div.box.box-title.node-header');
    detailModel.nodeCover = mainHeader!.querySelector('img')!.attributes['src']!;
    // 节点名称
    detailModel.nodeName = mainHeader.querySelector('div.node-breadcrumb')!.text.split('›')[1];
    // 主题总数
    detailModel.topicCount = mainHeader.querySelector('strong')!.text;
    // 节点描述
    if (mainHeader.querySelector('div.intro') != null) {
      detailModel.nodeIntro = mainHeader.querySelector('div.intro')!.text;
    }
    // 节点收藏状态
    if (mainHeader.querySelector('div.cell_ops') != null) {
      detailModel.isFavorite = mainHeader.querySelector('div.cell_ops')!.text.contains('取消');
      // 数字
      detailModel.nodeId = mainHeader.querySelector('div.cell_ops > div >a')!.attributes['href']!.split('=')[0].replaceAll(RegExp(r'\D'), '');
    }
    if (mainBox!.querySelector('div.box:not(.box-title)>div.cell:not(.tab-alt-container):not(.item)') != null) {
      var totalpageNode = mainBox.querySelector('div.box:not(.box-title)>div.cell:not(.tab-alt-container)');
      if (totalpageNode!.querySelectorAll('a.page_normal').isNotEmpty) {
        detailModel.totalPage = int.parse(totalpageNode.querySelectorAll('a.page_normal').last.text);
      }
    }

    if (mainBox.querySelector('div.box:not(.box-title)>div.cell.flex-one-row') != null) {
      var favNode = mainBox.querySelector('div.box:not(.box-title)>div.cell.flex-one-row>div');
      detailModel.favoriteCount = int.parse(favNode!.innerHtml.replaceAll(RegExp(r'\D'), ''));
    }

    if (document.querySelector('#TopicsNode') != null) {
      // 主题
      var topicEle = document.querySelector('#TopicsNode')!.querySelectorAll('div.cell');

      detailModel.topicList = Utils().parsePagePostList(topicEle);
    }
    return detailModel;
  }

  getPostDetail(String id) {}

  thank(String id) {}

  reply(String id, String content) {}

  collect(String id, int type) {}
}
