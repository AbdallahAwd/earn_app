import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  static TextStyle normal({Color? color}) => TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 18.sp,
        color: color,
      );
  static TextStyle medium() => TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 24.sp,
      );

  static TextStyle semiBold() => TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 30.sp,
      );

  static TextStyle bold() => TextStyle(
      fontFamily: 'Montserrat', fontSize: 35.sp, fontWeight: FontWeight.bold);
  static TextStyle copyWith({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) =>
      TextStyle(
        fontFamily: 'Montserrat',
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize.sp,
      );
}
