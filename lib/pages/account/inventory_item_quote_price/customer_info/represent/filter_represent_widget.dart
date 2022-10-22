import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/model/represent_model.dart';
import 'package:sale_soft/model/warehouse.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/customer_info/price_info_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/customer_info/represent/represent_controller.dart';
import 'package:sale_soft/widgets/search_widget.dart';
import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../widgets/inkwell_widget.dart';

class FilterRepresentWidget extends StatefulWidget {
  final String customerCode;
  final Function(RepresentModel)? onDone;

  FilterRepresentWidget(
      {Key? key, required this.customerCode, this.onDone})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FilterRepresentWidgetState();
  }
}

class _FilterRepresentWidgetState extends State<FilterRepresentWidget>
    with AutomaticKeepAliveClientMixin<FilterRepresentWidget> {
  final controller = Get.put(RepresentController());

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller.customerCode = widget.customerCode;
    controller.getNguoiDaiDien(""); //get tất cả người đại diện
  }

  @override
  Widget build(BuildContext context) {
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
                  hintText: 'Nhập email hoặc số điện thoại',
                  onChange: (value) {
                    controller.searchRepresentByEmailOrPhone(value);
                    controller.update();
                  },
                ),
                AppConstant.spaceVerticalSmallMedium,
                controller.obx((listAllReprent) {
                  return _WarehouseWidget(
                    stores: listAllReprent ?? [],
                    onDone: widget.onDone,
                  );
                }),
                AppConstant.spaceVerticalSmallExtraExtraExtra,
              ],
            )
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

  final List<RepresentModel> stores;
  final Function(RepresentModel)? onDone;

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
            height: AppConstant.kSpaceVerticalSmallExtraExtraExtra,
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

  final RepresentModel warehouse;
  final Function(RepresentModel)? onDone;

  @override
  Widget build(BuildContext context) {
    var isSelected = warehouse.isSelected.obs;
    String dear = warehouse.Dear?.isNotEmpty == true ? "[${warehouse.Dear}] " : "";
    String tel = warehouse.Phone?.isNotEmpty == true && warehouse.Phone != "0"
        && int.tryParse(warehouse.Phone.toString()) != 0
        && int.tryParse(warehouse.Phone.toString()) != null
        ? "${warehouse.Phone} " : "";
    return InkWellWidget(onPress: () {
      warehouse.isSelected = !warehouse.isSelected;
      isSelected.value = warehouse.isSelected;
      if (onDone != null) {
        onDone!(warehouse);
      }
    }, child: Container(
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
                Row(
                  children: [
                    Text('$dear${warehouse.Name}',
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(color: AppColors.grey),
                    ),
                    Spacer(),
                    tel != "" ? 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: AppColors.grey300, size: 15.sp,),
                        SizedBox(width: 3),
                        Text('$tel',
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              ?.copyWith(color: AppColors.grey),
                        ),
                      ],
                    )
                    : SizedBox(height: 0,)
                  ],
                ),
                AppConstant.spaceVerticalSmallExtra,
                _WarehouseCodeWidget(warehouse: warehouse),
              ],
            ),
          )
        ],
      ),
    )
    );
  }
}

class _WarehouseCodeWidget extends StatelessWidget {
  const _WarehouseCodeWidget({
    Key? key,
    required this.warehouse,
  }) : super(key: key);

  final RepresentModel warehouse;

  @override
  Widget build(BuildContext context) {
    if (warehouse.Code?.isNotEmpty == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.email, color: AppColors.grey300, size: 15.sp,),
          SizedBox(width: 3),
          Text(
            warehouse.Email ?? '-',
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(fontSize: 12.sp, color: AppColors.grey300),
          )
        ],
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
          'Chọn người đại diện',
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
