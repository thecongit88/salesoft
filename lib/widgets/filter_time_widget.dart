import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/enum/period_time.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterTimeWidget extends StatelessWidget {
  const FilterTimeWidget({
    Key? key,
    required this.values,
    required this.valueSelected,
    this.onPress,
  }) : super(key: key);

  final List<EPeriodTime> values;
  final EPeriodTime valueSelected;
  final Function(EPeriodTime)? onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: [
              AppConstant.spaceHorizontalSmallLarge,
              Text(
                'Doanh thu lọc theo',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: AppColors.grey),
              ),
              Expanded(child: SizedBox()),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.grey,
                  ))
            ],
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _ItemDateDisplayWidget(
                value: values[index],
                onPress: onPress,
                valueSelected: valueSelected,
              );
            },
            itemCount: values.length,
            separatorBuilder: (context, index) {
              return AppConstant.spaceVerticalSmallMedium;
            },
          ),
          AppConstant.spaceVerticalSmallExtraExtraExtra,
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DateInfoWidget(
                  title: 'Từ: ',
                  value: DateTimeHelper.dateToStringFormat(
                          date: valueSelected.timeValue.fromDate) ??
                      '',
                ),
                _DateInfoWidget(
                  title: "Đến: ",
                  value: DateTimeHelper.dateToStringFormat(
                          date: valueSelected.timeValue.toDate) ??
                      '',
                ),
              ],
            ),
          ),
          AppConstant.spaceVerticalSmallExtraExtraExtra
        ],
      ),
    );
  }
}

class _ItemDateDisplayWidget extends StatelessWidget {
  const _ItemDateDisplayWidget({
    Key? key,
    required this.value,
    this.onPress,
    required this.valueSelected,
  }) : super(key: key);

  final EPeriodTime value;
  final EPeriodTime valueSelected;
  final Function(EPeriodTime)? onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceVerticalSmallExtraExtra),
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtra,
          vertical: AppConstant.kSpaceVerticalSmallExtra),
      decoration: BoxDecoration(
          color: value == valueSelected ? AppColors.blue150 : AppColors.blue50,
          border: Border.all(
              width: value == valueSelected ? 1 : 0, color: AppColors.blue200),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          shape: BoxShape.rectangle),
      child: InkWellWidget(
        onPress: () {
          if (onPress != null) {
            onPress!(value);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value.name,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(color: AppColors.grey),
            ),
            _CheckBoxWidget(
              value: value,
              valueSelected: valueSelected,
            )
          ],
        ),
      ),
    );
  }
}

class _CheckBoxWidget extends StatelessWidget {
  const _CheckBoxWidget({
    Key? key,
    required this.value,
    required this.valueSelected,
  }) : super(key: key);

  final EPeriodTime value;
  final EPeriodTime valueSelected;

  @override
  Widget build(BuildContext context) {
    if (value == valueSelected) {
      return Icon(
        Icons.check,
        color: AppColors.blue,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _DateInfoWidget extends StatelessWidget {
  const _DateInfoWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .caption
              ?.copyWith(color: AppColors.grey),
        ),
        AppConstant.spaceHorizontalSmall,
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstant.kSpaceHorizontalSmallExtraExtra,
              vertical: AppConstant.kSpaceVerticalSmallExtra),
          decoration: BoxDecoration(
              color: AppColors.blue50,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              shape: BoxShape.rectangle),
          child: Row(
            children: [
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(color: AppColors.grey),
              ),
              AppConstant.spaceHorizontalSmall,
              Image.asset(AppResource.icCalendar)
            ],
          ),
        )
      ],
    );
  }
}
