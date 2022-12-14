import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/pages/account/inventory_item_in_stock/inventory_item_in_stock_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_in_stock/inventory_item_in_stock_page.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/filter_category_item_widget.dart';
import 'package:sale_soft/widgets/filter_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/search_widget.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'inventory_item_controller.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class BackButtonWidget extends GetView<InventoryItemController> {
  const BackButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new_outlined,
        color: Colors.white,
      ),
      onPressed: () {
        Get.back();
        // if (controller.argument != null) {
        //   Get.back<List<InventroyItemModel>>(
        //       result: controller.listSelectedItem);
        // } else {
        //   Get.back();
        // }
      },
    );
  }
}

class InventroryItemPage extends StatelessWidget {
  const InventroryItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InventoryItemController controller = Get.find();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 54,
          elevation: 0,
          leading: BackButtonWidget(),
          backgroundColor: AppColors.blue,
          centerTitle: false,
          title: _TitleAppBarWidget(
            title: "H??ng h??a",
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
              vertical: AppConstant.kSpaceVerticalSmallExtraExtra),
          child: Column(
            children: [
              SearchWidget(
                  hintText: "Nh???p m?? ho???c t??n h??ng h??a",
                  textEditingController: controller.textEditController,
                  onChange: (keyword) async {
                    controller.fetchInventoryItem();
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.qr_code_scanner,
                    ),
                    onPressed: () async {
                      int camera = -1; ///s??? d???ng camera sau
                      String? qrCodeResult;
                      ScanResult codeSanner = await BarcodeScanner.scan(
                        options: ScanOptions(
                            useCamera: camera,
                            strings:
                            const {
                              "cancel": "????ng",
                            }
                        ),
                      );
                      qrCodeResult = codeSanner.rawContent;
                      //qrCodeResult = "KR7000-07";
                      //qrCodeResult = "https://www.diawi.com/";
                      //print("Qr code result: ${hasValidUrl(qrCodeResult)}");

                      ///Ch?? ??: ??o???n code check khi b???n m?? qr ????? Th??m h??ng khi t???o phi???u ?????t h??ng
                      if(controller.argument != null) {
                        controller.textEditController.text = qrCodeResult;
                        controller.fetchInventoryItem();
                        return;
                      }

                      if(qrCodeResult.isNotEmpty) {
                        if(hasValidUrl(qrCodeResult)) {
                          openUrl(qrCodeResult);
                        } else {
                          final InventroyItemModel item = new InventroyItemModel(code: qrCodeResult);
                          Get.toNamed(ERouter.inventoryItemDetailPage.name, arguments: item);
                        }
                      } else {
                        showErrorToast("Kh??ng t??m th???y s???n ph???m.");
                      }
                    },
                  ),
              ),
              AppConstant.spaceVerticalSmallMedium,
              Expanded(
                child: controller.obx((inventoryItems) {
                  return SmartRefresher(
                    controller: controller.refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () => controller.fetchInventoryItem(),
                    onLoading: () =>
                        controller.fetchInventoryItem(isLoadMore: true),
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          final InventroyItemModel item =
                              inventoryItems![index];
                          return _InventoryItemWidget(
                            onPress: () {
                              if(controller.argument != null) {
                                  ///tr?????ng h???p th??m h??ng v??o phi???u giao h??ng - c?? checkbox ch???n, p???i b???m Xem chi ti???t m???i ra chi ti???t h??ng h??a
                                  inventoryItems[index].isSelected = !inventoryItems[index].isSelected;
                                  controller.initSelectedList();
                              } else {
                                ///tr?????ng h???p xem chi ti???t h??ng h??a
                                Get.toNamed(ERouter.inventoryItemDetailPage.name,
                                    arguments: inventoryItems[index]);
                              }
                              
                              ///show popup inventory item
                              /*
                              if (controller.argument != null) {
                                item.isSelected = !item.isSelected;
                                controller.initSelectedList();
                              } else {
                                Dialog dialog = Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.r)), //this right here
                                  child: InventoryItemInStockPage(item),
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: AppConstant
                                          .kSpaceHorizontalSmallExtraExtraExtra),
                                );
                                showDialog(
                                    context: context,
                                    builder: (context) => dialog).then((value) {
                                  Get.delete<InventoryItemInStockController>();
                                });
                              }
                              */
                            },
                            inventroyItem: item,
                            backgroundColor: index % 2 == 0
                                ? AppColors.grey50.withOpacity(0.1)
                                : null,
                          );
                        },
                        itemCount: inventoryItems?.length ?? 0),
                  );
                },
                    onEmpty: EmptyDataWidget(
                      onReloadData: () => controller.fetchInventoryItem(),
                    )),
              ),
              AppConstant.spaceVerticalSmallMedium,

              controller.argument != null && controller.argument!.length > 0 && controller.argument![0].code == AppConstant.kiem_kho ?
              SizedBox(height: 0,) :
              Visibility(
                visible: controller.argument != null,
                child: InkWellWidget(
                  onPress: () {
                    Get.back<List<InventroyItemModel>>(
                        result: controller.listSelectedItem);
                  },
                  child: Container(
                    height: 45.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        shape: BoxShape.rectangle),
                    child: Text(
                      "?????ng ??",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
}

class _InventoryItemWidget extends StatelessWidget {
  const _InventoryItemWidget({
    Key? key,
    this.onPress,
    required this.inventroyItem,
    this.backgroundColor,
  }) : super(key: key);

  final Function()? onPress;
  final InventroyItemModel inventroyItem;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<InventoryItemController>();
    double qty = inventroyItem.quantity!;
    return InkWellWidget(
      onPress: onPress,
      child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          padding: EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                stops: [0.012, 0.012],
                colors: [qty > 0 ? AppColors.green : AppColors.grey300, Color(0xFFfdfdfd)]
            ),
            borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              ///m?? v?? tr???ng th??i h??ng
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  controller.argument != null && controller.argument!.length > 0 && controller.argument![0].code == AppConstant.kiem_kho ?
                      SizedBox(height: 0,) :
                  Visibility(
                    visible: controller.argument != null,
                    child: Row(
                      children: [
                        Icon(
                          !inventroyItem.isSelected
                              ? Icons.check_box_outline_blank
                              : Icons.check_box,
                          color: inventroyItem.isSelected
                              ? AppColors.blue
                              : AppColors.grey,
                        ),
                        AppConstant.spaceHorizontalSmall,
                      ],
                    )
                  ),
                  Text(
                    inventroyItem.code ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, color: qty > 0 ? AppColors.green : AppColors.grey300, size: 13.sp,),
                      SizedBox(width: 3,),
                      Text(
                        '${qty > 0 ? "C??n h??ng" : "H???t h??ng"}',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            fontSize: 13.sp, color: qty > 0 ? AppColors.green : AppColors.grey300, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
              AppConstant.spaceVerticalSmallExtra,
              ///t??n h??ng
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      inventroyItem.name ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          ?.copyWith(fontSize: 14.5.sp, height: 1.3, color: AppColors.grey),
                    ),
                    flex: 8,
                  ),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            (qty).toAmountFormat(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: AppColors.blue, fontSize: 14.5.sp),
                          ),
                          //AppConstant.spaceVerticalSmallMedium,
                          _UnitWidget(inventroyItem: inventroyItem)
                        ],
                      ),
                      flex: 3
                  ),
                ],
              ),
              AppConstant.spaceVerticalSmallExtra,
              ///gi?? s??? gi?? l???
              Row(
                children: [
                  Expanded(
                      child: Row(
                        children: [
                          Text(
                            'Gi?? s???: ',
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                fontSize: 14.5.sp, color: AppColors.grey),
                          ),
                          Text(
                            '${(inventroyItem.Price0 ?? 0).toAmountFormat()}',
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                fontSize: 14.5.sp, color: AppColors.blue),
                          ),
                        ],
                      )
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Gi?? l???: ',
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              fontSize: 14.5.sp, color: AppColors.grey),
                        ),
                        Text(
                          '${(inventroyItem.Price ?? 0).toAmountFormat()}',
                          style: Theme.of(context).textTheme.caption?.copyWith(
                              fontSize: 14.5.sp, color: AppColors.blue),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              AppConstant.spaceVerticalSmall,

              ///Xem chi ti???t  && controller.argument!.length > 0 && controller.argument![0].code != AppConstant.kiem_kho
              (controller.argument != null) ?
              Column(
                children: [
                  AppConstant.spaceVerticalSmall,
                  Divider(
                    thickness: 0.25,
                    color: AppColors.grey50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWellWidget(
                          onPress: () {
                            Get.toNamed(ERouter.inventoryItemDetailPage.name,
                                arguments: inventroyItem);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Xem chi ti???t',
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                    fontSize: 14.5.sp, color: AppColors.blue),
                              ),
                              Icon(Icons.arrow_right, color: AppColors.blue, size: 21.sp,),
                            ],
                          ),
                        ),
                      ),

                      controller.argument != null && controller.argument!.length > 0 && controller.argument![0].code == AppConstant.kiem_kho ?
                        ///ch???n s???n ph???m ????? ki???m kho
                        Expanded(
                        child: Row(
                          children: [
                            Spacer(),
                            InkWellWidget(
                              onPress: () {
                                controller.listSelectedItem = [];
                                controller.listSelectedItem!.add(inventroyItem);
                                Get.back<List<InventroyItemModel>>(
                                    result: controller.listSelectedItem);
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.blue,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    shape: BoxShape.rectangle),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, size: 13.sp, color: Colors.white,),
                                    SizedBox(width: 5),
                                    Text(
                                      "Ki???m kho",
                                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                                    ),
                                  ],
                                )
                              ),
                            ),
                          ],
                        ),
                      )
                          :
                        SizedBox(height: 0,) ///ch???n s???n ph???m t??? th??m phi???u ?????t h??ng
                    ],
                  )
                ],
              )
                  :
              SizedBox(height: 0,)
            ],
          )
      )
    );
  }
}

class _UnitWidget extends StatelessWidget {
  const _UnitWidget({
    Key? key,
    required this.inventroyItem,
  }) : super(key: key);

  final InventroyItemModel inventroyItem;

  @override
  Widget build(BuildContext context) {
    if (inventroyItem.unit?.isNotEmpty == true) {
      return Text(
        inventroyItem.unit ?? '',
        style: Theme.of(context)
            .textTheme
            .caption
            ?.copyWith(fontSize: 13.sp, color: AppColors.grey450),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _TitleAppBarWidget extends StatelessWidget {
  const _TitleAppBarWidget({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final InventoryItemController controller = Get.find();
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headline5
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      Row(
        children: [
          Obx(() {
            return FilterWidget(
              title: 'Ch???n nh??m h??ng',
              value: controller.getCategoryTitle(),
              imageAssetName: AppResource.icInventoryItem,
              maxWidth: 130.w,
              onPress: () {
                showViewDialog(
                    context,
                    FilterCategoryItemWidget(
                      searchListCategory: (String keyword) {
                        return controller.searchCategoryByKey(keyword);
                      },
                      onDone: (item) {
                        Get.back();
                        controller.filterCategoryAction(item);
                        controller.fetchInventoryItem();
                      },
                    ));
              },
            );
          })
        ],
      )
    ]);
  }
}
