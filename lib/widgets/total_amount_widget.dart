import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/number_formater.dart';

class TotalAmountWidget extends StatelessWidget {
  const TotalAmountWidget({
    Key? key,
    required this.title,
    required this.totalAmount,
  }) : super(key: key);

  final String title;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(color: AppColors.grey),
        ),
        AppConstant.spaceVerticalSmall,
        Text(
          totalAmount.toAmountFormat(),
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(color: AppColors.blue, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
