import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/model/plan.dart';
import 'package:sale_soft/model/warehouse.dart';
import 'package:sale_soft/widgets/search_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'inkwell_widget.dart';

class FilterPlansWidget extends StatelessWidget {
  const FilterPlansWidget(
      {Key? key, required this.searchListPlans, this.onDone})
      : super(key: key);

  final List<PlanModel> Function(String keyword) searchListPlans;
  final Function(PlanModel)? onDone;

  @override
  Widget build(BuildContext context) {
    var plans = searchListPlans("").obs;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _TitleWidget(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SearchWidget(
                  hintText: 'Nhập mã hoặc tên kế hoạch',
                  onChange: (value) {
                    plans.value = searchListPlans(value);
                  },
                ),
                AppConstant.spaceVerticalSmallMedium,
                Obx(() {
                  return _WarehouseWidget(
                    stores: plans.value,
                    onDone: onDone,
                  );
                }),
                AppConstant.spaceVerticalSmallExtraExtraExtra,
                // SizedBox(
                //   height: 40.h,
                //   child: TextButton(
                //       onPressed: () {
                //         if (onDone != null) {
                //           print("Done");
                //           onDone!();
                //         }
                //       },
                //       style: ButtonStyle(
                //         backgroundColor:
                //             MaterialStateProperty.all<Color>(AppColors.blue),
                //       ),
                //       child: Text(
                //         'Lọc',
                //         style: Theme.of(context)
                //             .textTheme
                //             .bodyText2
                //             ?.copyWith(color: Colors.white),
                //       )),
                // ),
                // AppConstant.spaceVerticalSmallExtraExtraExtra
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _WarehouseWidget extends StatelessWidget {
  const _WarehouseWidget({
    Key? key,
    required this.stores,
    this.onDone,
  }) : super(key: key);

  final List<PlanModel> stores;
  final Function(PlanModel)? onDone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.3.sh,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return WarehouseItemWidget(
            warehouse: stores[index],
            onDone: onDone,
          );
        },
        itemCount: stores.length,
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            height: AppConstant.kSpaceVerticalSmallExtra,
          );
        },
      ),
    );
  }
}

class WarehouseItemWidget extends StatelessWidget {
  const WarehouseItemWidget({
    Key? key,
    required this.warehouse,
    this.onDone,
  }) : super(key: key);

  final PlanModel warehouse;
  final Function(PlanModel)? onDone;

  @override
  Widget build(BuildContext context) {
    var isSelected = warehouse.isSelected.obs;
    return InkWellWidget(onPress: () {
      warehouse.isSelected = !warehouse.isSelected;
      isSelected.value = warehouse.isSelected;
      if (onDone != null) {
        onDone!(warehouse);
      }
    }, child: Obx(() {
      return Container(
        constraints: BoxConstraints(minHeight: 30.h),
        padding: EdgeInsets.all(AppConstant.kSpaceHorizontalSmall),
        decoration: BoxDecoration(
            color: isSelected.value ? AppColors.blue150 : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            shape: BoxShape.rectangle),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _WarehouseCodeWidget(warehouse: warehouse),
                  Text(
                    warehouse.Ten ?? '',
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(color: AppColors.grey),
                  ),
                ],
              ),
            ),
            _StatusWidget(
              warehouse: warehouse,
            )
          ],
        ),
      );
    }));
  }
}

class _WarehouseCodeWidget extends StatelessWidget {
  const _WarehouseCodeWidget({
    Key? key,
    required this.warehouse,
  }) : super(key: key);

  final PlanModel warehouse;

  @override
  Widget build(BuildContext context) {
    if (warehouse.Ma?.isNotEmpty == true) {
      return Text(
        warehouse.Ma ?? '',
        style: Theme.of(context)
            .textTheme
            .caption
            ?.copyWith(fontSize: 10.sp, color: AppColors.grey300),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _StatusWidget extends StatelessWidget {
  const _StatusWidget({
    Key? key,
    required this.warehouse,
  }) : super(key: key);

  final PlanModel warehouse;

  @override
  Widget build(BuildContext context) {
    if (warehouse.isSelected) {
      return Icon(
        Icons.check,
        color: AppColors.blue,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppConstant.spaceHorizontalSmallLarge,
        Text(
          'Chọn kế hoạch',
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
    );
  }
}
