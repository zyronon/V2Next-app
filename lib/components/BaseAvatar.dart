import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseAvatar extends StatelessWidget {
  final String src;
  final double diameter;
  final double radius;

  const BaseAvatar({super.key, required this.src, required this.diameter, required this.radius});

  @override
  Widget build(BuildContext context) {
    if (src != '') {
      return ClipRRect(borderRadius: BorderRadius.circular(radius), child: Image.network(src, width: diameter, height: diameter, fit: BoxFit.cover));
    } else {
      return Container(width: diameter, height: diameter);
    }
  }
}
