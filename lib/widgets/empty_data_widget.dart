import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';

class EmptyDataWidget extends StatelessWidget {
  final Function()? onReloadData;
  final String? msg;

  const EmptyDataWidget({Key? key, this.onReloadData, this.msg = 'Không có dữ liệu'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$msg",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: AppColors.grey300),
          ),
          AppConstant.spaceVerticalSmall,
          InkWellWidget(
            onPress: onReloadData,
            padding: EdgeInsets.all(4),
            borderRadius: 4,
            child: Text(
              'Thử lại',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: AppColors.blue),
            ),
          )
        ],
      ),
    );
  }
}
