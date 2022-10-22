import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/model/inventory_item_category_model.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/search_widget.dart';

///
/// Filter theo Category InventoryItem
///

class FilterCategoryItemWidget extends StatelessWidget {
  const FilterCategoryItemWidget(
      {Key? key, required this.searchListCategory, this.onDone})
      : super(key: key);

  final List<InventoryItemCategoryModel> Function(String keyword)
      searchListCategory;
  final Function(InventoryItemCategoryModel)? onDone;

  @override
  Widget build(BuildContext context) {
    var categories = searchListCategory("").obs;
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
                  hintText: 'Nhập tên nhóm',
                  onChange: (value) {
                    categories.value = searchListCategory(value);
                  },
                ),
                AppConstant.spaceVerticalSmallExtraExtraExtra,
                Row(
                  children: [
                    Text(
                      'Chọn nhóm hàng',
                      style: Theme.of(context).textTheme.caption?.copyWith(
                          color: AppColors.grey, fontWeight: FontWeight.w500),
                    ),
                    Spacer(),
                    ///bổ sung nút chọn tất cả để lọc hàng hóa theo danh mục
                    InkWellWidget(
                      child: Row(
                        children: [
                          Icon(Icons.done_all, color: AppColors.blue, size: 17.sp,),
                          SizedBox(width: 4,),
                          Text("Tất cả", style: Theme.of(context).textTheme.caption?.copyWith(
                              color: AppColors.blue, fontWeight: FontWeight.w500),),
                        ],
                      ),
                      onPress: () {
                        categories.value = <InventoryItemCategoryModel>[].obs;
                        categories.value.add(InventoryItemCategoryModel(code: "all"));
                        if (onDone != null) {
                          onDone!(categories.value.first);
                        }
                      },
                    ),
                  ],
                ),
                AppConstant.spaceVerticalSmallMedium,
                Obx(() {
                  return _CategoryWidget(
                    stores: categories.value,
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

class _CategoryWidget extends StatelessWidget {
  const _CategoryWidget({
    Key? key,
    required this.stores,
    this.onDone,
  }) : super(key: key);

  final List<InventoryItemCategoryModel> stores;
  final Function(InventoryItemCategoryModel)? onDone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.3.sh,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return CategoryItemWidget(
            category: stores[index],
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

class CategoryItemWidget extends StatelessWidget {
  const CategoryItemWidget({
    Key? key,
    required this.category,
    this.onDone,
  }) : super(key: key);

  final InventoryItemCategoryModel category;
  final Function(InventoryItemCategoryModel)? onDone;

  @override
  Widget build(BuildContext context) {
    var isSelected = category.isSelected.obs;
    return InkWellWidget(onPress: () {
      category.isSelected = !category.isSelected;
      isSelected.value = category.isSelected;
      if (onDone != null) {
        onDone!(category);
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
                  _CategoryCodeWidget(category: category),
                  Text(
                    category.name ?? '',
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
              category: category,
            )
          ],
        ),
      );
    }));
  }
}

class _CategoryCodeWidget extends StatelessWidget {
  const _CategoryCodeWidget({
    Key? key,
    required this.category,
  }) : super(key: key);

  final InventoryItemCategoryModel category;

  @override
  Widget build(BuildContext context) {
    if (category.code?.isNotEmpty == true) {
      return Text(
        category.code ?? '',
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
    required this.category,
  }) : super(key: key);

  final InventoryItemCategoryModel category;

  @override
  Widget build(BuildContext context) {
    if (category.isSelected) {
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
          'Chọn nhóm hàng hóa',
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
