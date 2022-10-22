import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/model/store.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/search_widget.dart';

///
/// Filter theo Store
///

class FilterBranchWidget extends StatelessWidget {
  const FilterBranchWidget(
      {Key? key, required this.searchListStore, this.onDone})
      : super(key: key);

  final List<StoreModel> Function(String keyword) searchListStore;
  final Function()? onDone;

  @override
  Widget build(BuildContext context) {
    var stores = searchListStore("").obs;
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
                  hintText: 'Nhập tên cửa hàng',
                  onChange: (value) {
                    stores.value = searchListStore(value);
                  },
                ),
                AppConstant.spaceVerticalSmallExtraExtraExtra,
                Text(
                  'Toàn chuỗi',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                      color: AppColors.grey, fontWeight: FontWeight.w500),
                ),
                AppConstant.spaceVerticalSmallMedium,
                Obx(() {
                  return _StoresWidget(stores: stores.value);
                }),
                AppConstant.spaceVerticalSmallExtraExtraExtra,
                SizedBox(
                  height: 40.h,
                  child: TextButton(
                      onPressed: () {
                        if (onDone != null) {
                          print("Done");
                          onDone!();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(AppColors.blue),
                      ),
                      child: Text(
                        'Lọc',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: Colors.white),
                      )),
                ),
                AppConstant.spaceVerticalSmallExtraExtraExtra
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _StoresWidget extends StatelessWidget {
  const _StoresWidget({
    Key? key,
    required this.stores,
  }) : super(key: key);

  final List<StoreModel> stores;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.3.sh,
      child: ListView.separated(
        shrinkWrap: false,
        // physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return BranchWidget(store: stores[index]);
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

class BranchWidget extends StatelessWidget {
  const BranchWidget({
    Key? key,
    required this.store,
  }) : super(key: key);

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    var isSelected = store.isSelected.obs;
    return InkWellWidget(onPress: () {
      store.isSelected = !store.isSelected;
      isSelected.value = store.isSelected;
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  store.name ?? '',
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(color: AppColors.grey),
                ),
                _AddressWidget(store: store),
              ],
            ),
            _StatusWidget(
              store: store,
            )
          ],
        ),
      );
    }));
  }
}

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({
    Key? key,
    required this.store,
  }) : super(key: key);

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    if (store.address?.isNotEmpty == true) {
      return Text(
        store.address ?? '',
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
    required this.store,
  }) : super(key: key);

  final StoreModel store;

  @override
  Widget build(BuildContext context) {
    if (store.isSelected) {
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
          'Doanh thu lọc theo cửa hàng',
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
