import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/number_formater.dart';

/// Widget cho phần mô tả biểu đồ
class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget(
      {Key? key,
      required this.index,
      required this.title,
      required this.totalAmount,
      this.radius = 5.0,
      this.colorIndex = Colors.blue,
      this.indexWidth = 22,
      this.indexHeight = 22,
      this.subTitle,
      this.icon,
      this.hasSuffix = false
      })
      : super(key: key);

  final int index;
  final Color colorIndex;
  final double indexWidth;
  final double indexHeight;
  final String title;
  final String? subTitle;
  final double totalAmount;
  final double radius;
  final String? icon;
  final bool hasSuffix;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon == null
            ? Container(
                width: indexWidth,
                height: indexHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: colorIndex,
                    borderRadius: BorderRadius.all(Radius.circular(radius)),
                    shape: BoxShape.rectangle),
                child: Text(
                  index.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.white),
                ))
            : Container(
                child: Image.asset(
                  icon ?? "",
                  fit: BoxFit.fill,
                  width: 22,
                  height: 22,
                ),
              ),
        AppConstant.spaceHorizontalSmallExtraExtra,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: AppColors.grey700),
            ),
            _SubTitleWidget(subTitle: subTitle),
          ],
        ),
        Expanded(child: SizedBox()),
        totalAmount > 0 ?
        Text(
          totalAmount.toAmountFormat(),
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: AppColors.grey),
        ) : SizedBox(height: 0,),
        SizedBox(width: 3),
        this.hasSuffix ? Icon(Icons.arrow_right, color: AppColors.grey) : SizedBox(height: 0,)
      ],
    );
  }
}

class _SubTitleWidget extends StatelessWidget {
  const _SubTitleWidget({
    Key? key,
    required this.subTitle,
  }) : super(key: key);

  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    if (subTitle?.isNotEmpty == true) {
      return Text(subTitle ?? '',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: AppColors.grey300, fontSize: 10));
    } else {
      return SizedBox.shrink();
    }
  }
}
