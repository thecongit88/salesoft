import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/model/inventory_item_model.dart';

///
/// View search
///
class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
    required this.onChange,
    this.textEditingController,
    required this.hintText,
    this.suffixIcon,
    this.boderRightPrefixIcon = true
  }) : super(key: key);

  final Function(String)? onChange;
  final TextEditingController? textEditingController;
  final tickTime = const Duration(milliseconds: 500);
  final String? hintText;
  final Widget? suffixIcon;
  final bool? boderRightPrefixIcon;

  @override
  Widget build(BuildContext context) {
    var timeWaitSearch = 500;
    Timer? timer;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        TextField(
          style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.black),
          controller: textEditingController ?? TextEditingController(),
          onChanged: (text) {
            timeWaitSearch = 500;
            timer?.cancel();
            timer = Timer.periodic(
              tickTime,
                  (Timer timer) {
                if (timeWaitSearch <= 0) {
                  timer.cancel();
                  if (onChange != null) {
                    onChange!(text);
                  }
                } else {
                  timeWaitSearch -= 500;
                }
              },
            );
          },
          decoration: InputDecoration(
              fillColor: AppColors.blue100,
              filled: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              /*contentPadding: EdgeInsets.symmetric(
                horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                vertical: AppConstant.kSpaceVerticalSmallExtraExtraExtra,
              ),*/
              contentPadding: EdgeInsets.only(
                left: 40.w,
                right: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                top: AppConstant.kSpaceVerticalSmallExtraExtraExtra,
                bottom: AppConstant.kSpaceVerticalSmallExtraExtraExtra,
              ),
              hintText: hintText,
              //prefixIcon: prefixIcon,
              suffixIcon: suffixIcon
          ),
        ),
        this.boderRightPrefixIcon == true ?
        Container(
          margin: const EdgeInsets.only(left: 3),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 0.8, color: AppColors.grey50))),
          width: 33,
          child: Icon(Icons.search, color: AppColors.grey300, size: 20.sp,),
        ) :
        Container(
          margin: const EdgeInsets.only(left: 15),
          child: Icon(Icons.search, color: AppColors.grey300, size: 20.sp,),
        )
      ],
    );
  }
}
