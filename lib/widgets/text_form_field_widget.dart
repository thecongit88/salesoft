import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/common/text_theme_app.dart';
import 'package:sale_soft/model/inventory_item_model.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    Key? key,
    required this.onChange,
    this.textEditingController,
    this.label,
    this.suffixIcon,
    this.isValidator = true
  }) : super(key: key);

  final Function(String)? onChange;
  final TextEditingController? textEditingController;
  final String? label;
  final Widget? suffixIcon;
  final bool isValidator;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        label != null ? Align(
          alignment: Alignment.centerLeft,
          child: TextThemeApp.wdgTitle("$label", isRequired: isValidator)
        ) : SizedBox(height: 0),
        SizedBox(height: 8),
        TextFormField(
          style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.black, fontSize: 14.sp),
          controller: textEditingController ?? TextEditingController(),
          validator: (value) {
            if (isValidator == true && (value == null || value.isEmpty)) {
              return "Thông tin bắt buộc.";
            }
            return null;
          },
          onChanged: onChange,
          decoration: InputDecoration(
              fillColor: AppColors.blue100,
              filled: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                vertical: AppConstant.kSpaceVerticalSmallExtraExtraExtra,
              ),
              hintText: "Chạm để nhập",
              hintStyle: TextStyle(fontSize: 15.sp),
              //prefixIcon: prefixIcon,
              suffixIcon: suffixIcon
          ),
        )
      ],
    );
  }
}
