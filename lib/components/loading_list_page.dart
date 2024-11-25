import 'package:flutter/material.dart';
import 'package:v2next/components/loading_item.dart';

import 'base_divider.dart';

class LoadingListPage extends StatelessWidget {
  final int type;

  const LoadingListPage({this.type = 0});

  @override
  Widget build(BuildContext context) {
    if (type == 1) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return LoadingItem();
        }, childCount: 7),
      );
    }
    return ListView.separated(
      physics: new AlwaysScrollableScrollPhysics(),
      itemCount: 7,
      itemBuilder: (BuildContext context, int index) {
        return LoadingItem();
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return BaseDivider();
      },
    );
  }
}
