import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget {
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(elevation: 0, toolbarHeight: 0);
  }
}
