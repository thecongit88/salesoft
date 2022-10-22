import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    Key? key,
    this.textColor,
    this.title,
    this.value,
    this.onPress,
    this.maxWidth,
    required this.imageAssetName,
  }) : super(key: key);

  final String? title;
  final String? value;
  final String imageAssetName;
  final Color? textColor;
  final Function()? onPress;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onPress: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LeadingIconWidget(
            imageAssetName: imageAssetName,
          ),
          AppConstant.spaceHorizontalSmallExtra,
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title ?? '',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: textColor ?? Colors.white, fontSize: 15.sp),
                  ),
                  AppConstant.spaceHorizontalSmall,
                  Image.asset(AppResource.icPolygon)
                ],
              ),
              AppConstant.spaceVerticalVerySmall,
              Container(
                constraints: maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
                child: Text(
                  value ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: textColor ?? Colors.white, fontSize: 12.sp),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _LeadingIconWidget extends StatelessWidget {
  const _LeadingIconWidget({
    Key? key,
    required this.imageAssetName,
  }) : super(key: key);

  final String imageAssetName;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 30.r,
      height: 30.r,
      decoration:
          BoxDecoration(color: AppColors.blue400, shape: BoxShape.circle),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(AppConstant.kSpaceHorizontalSmall),
            child: Image.asset(
              imageAssetName,
              width: 16.r,
              height: 16.r,
              fit: BoxFit.fitWidth,
              color: Colors.white,
            ),
          ),
          Positioned(
              top: 2.w,
              right: 2.h,
              child: Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                    color: AppColors.orange, shape: BoxShape.circle),
              ))
        ],
      ),
    );
  }
}
