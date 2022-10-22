import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/common/app_colors.dart';

class TextThemeApp {
  static final textTheme = TextTheme(
      caption: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.normal,
        fontFamily: "Roboto",
      ),
      bodyText1: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.normal, fontFamily: "Roboto"),
      bodyText2: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.w600, fontFamily: "Roboto"),
      subtitle1: TextStyle(
          fontSize: 16.sp, fontWeight: FontWeight.normal, fontFamily: "Roboto"),
      subtitle2: TextStyle(
          fontSize: 16.sp, fontWeight: FontWeight.w600, fontFamily: "Roboto"),
      headline5: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.normal,
          fontFamily: "Roboto"));

  static Widget wdgTitle(String title, {isRequired = true}) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title",
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            isRequired == true ?
            Text(" (*)", style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.normal, fontSize: 13.sp)) :
            SizedBox(height: 0,)
          ],
        )
    );
  }
}
