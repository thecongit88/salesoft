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
import 'package:sale_soft/model/inventory_product_model.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/choose_items/inventory_item_quote_price_controller.dart';
import 'package:sale_soft/pages/account/inventory_item_quote_price/customer_info/price_list_info_page.dart';
import 'package:sale_soft/pages/account/search_customer/customer_page.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/filter_category_item_widget.dart';
import 'package:sale_soft/widgets/filter_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/input_kiem_kho_with_plan_dialog.dart';
import 'package:sale_soft/widgets/search_widget.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class InventroryItemQuotePricePage extends StatelessWidget {
  const InventroryItemQuotePricePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InventoryItemQuotePriceController controller = Get.find();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 54,
          elevation: 0,
          leading: BackButtonWidget(),
          backgroundColor: AppColors.blue,
          centerTitle: false,
          title: _TitleAppBarWidget(
            title: "Báo giá",
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(
              left: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
              right: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
              top: AppConstant.kSpaceVerticalSmallExtraExtra,
              bottom: 0
          ),
          child: Column(
            children: [
              SearchWidget(
                  hintText: "Nhập mã hoặc tên hàng hóa",
                  textEditingController: controller.textEditController,
                  onChange: (keyword) async {
                    controller.fetchInventoryItem();
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.qr_code_scanner,
                    ),
                    onPressed: () async {
                      int camera = -1; ///sử dụng camera sau
                      String? qrCodeResult;
                      ScanResult codeSanner = await BarcodeScanner.scan(
                        options: ScanOptions(
                            useCamera: camera,
                            strings:
                            const {
                              "cancel": "Đóng",
                            }
                        ),
                      );
                      qrCodeResult = codeSanner.rawContent;
                      //qrCodeResult = "KR7000-07";
                      //qrCodeResult = "https://www.diawi.com/";
                      //print("Qr code result: ${hasValidUrl(qrCodeResult)}");

                      ///Chú ý: Đoạn code check khi bắn mã qr để Thêm hàng khi tạo phiếu đặt hàng
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
                        showErrorToast("Không tìm thấy sản phẩm.");
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
                            inventroyItem: item,
                            /*backgroundColor: index % 2 == 0
                                ? AppColors.grey50.withOpacity(0.1)
                                : null,*/
                          );
                        },
                        itemCount: inventoryItems?.length ?? 0
                    ),
                  );
                },
                  onEmpty: EmptyDataWidget(
                    onReloadData: () => controller.fetchInventoryItem(),
                  )
                ),
              ),
            ],
          ),
        ),
        //bottomNavigationBar: wdgCartSummary(context),
        bottomNavigationBar: SummaryCartWidget(),
    );
  }

/*  showCartItems(BuildContext context) {
    final InventoryItemQuotePriceController controller = Get.find();
    List<InventroyItemModel> list = controller.quotesCart;
    int n = list.length;
    print("cart quote item: $n");
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                wdgCartSummary(context, disableViewCartList: true),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      child: controller.obx((state) {
                        return
                          controller.totalQty <= 0 ?
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text("Không có sản phẩm nào trong giỏ.",
                                  style: TextStyle(color: AppColors.grey300)
                              ),
                            )
                          )
                            :
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final InventroyItemModel item = list[index];
                              return _InventoryItemCartWidget(
                                inventroyItem: item,
                                backgroundColor: index % 2 == 0
                                    ? AppColors.grey50.withOpacity(0.1)
                                    : null,
                              );
                            },
                            itemCount: n
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  wdgCartSummary(BuildContext context, {disableViewCartList = false}) {
    final InventoryItemQuotePriceController controller = Get.find();
    return Container(
      color: AppColors.blue50,
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtra,
          vertical: AppConstant.kSpaceVerticalSmall
      ),
      child: InkWellWidget(
        child: controller.obx((state) {
          return Row(
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      CupertinoIcons.archivebox,
                      color: AppColors.blue,
                      size: 40,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2, left: 28),
                    child: IntrinsicWidth(
                      stepHeight: 3,
                      stepWidth: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(width: 3, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          shape: BoxShape.rectangle,
                          color: AppColors.blue,
                        ),
                        child: Center(
                            child: Text("${controller.totalQty >= 100 ? "99+" : controller.totalQty}",
                              maxLines: 1,
                              style: Theme.of(context).textTheme.caption?.copyWith(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Text('${controller.totalAmount.toAmountFormat()} đ',
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp),
                  )
              ),
              SizedBox(
                height: 35,
                child: TextButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Gửi báo giá',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp
                        ),
                      ),
                      AppConstant.spaceHorizontalSmall,
                      Icon(Icons.send, size: 15.sp, color: Colors.white,)
                    ],
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: controller.totalQty > 0 ? AppColors.blue : AppColors.grey300,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () async {
                    if(controller.totalQty <= 0) return;
                    var result = await Get.toNamed(ERouter.priceInfoPage.name);
                    if(result != null) {
                      final controllerCart = Get.find<InventoryItemQuotePriceController>();
                      List<InventroyItemModel> listItemsInCart = controllerCart.quotesCart;
                      controller.calcTotalInCart(listItemsInCart);
                      controllerCart.fetchInventoryItem();
                    }
                  },
                ),
              ),
            ],
          );
          },
          onLoading: SizedBox(height: 0,)
        ),
        onPress: () {
          if(disableViewCartList == true) return;
          showCartItems(context);
        },
      )
    );
  }*/

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
    var controller = Get.find<InventoryItemQuotePriceController>();
    double qty = inventroyItem.quantity!;
    List<InventroyItemModel> listItemsInCart = controller.quotesCart;
    if(listItemsInCart.length > 0) {
      List<InventroyItemModel> findItems = listItemsInCart.where((element) => inventroyItem.code == element.code).toList();
      inventroyItem.soluongBaoGia = findItems.length > 0 ? findItems[0].soluongBaoGia : 0;
    }


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
              ///mã và trạng thái hàng
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        '${qty > 0 ? "Còn hàng" : "Hết hàng"}',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                            fontSize: 13.sp, color: qty > 0 ? AppColors.green : AppColors.grey300, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
              AppConstant.spaceVerticalSmallExtra,
              ///tên hàng
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
              AppConstant.spaceVerticalSmallMedium,
              ///giá sỉ giá lẻ
              Row(
                children: [
                  Expanded(
                      child: Row(
                        children: [
                          Text(
                            'Giá sỉ: ',
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
                          'Giá lẻ: ',
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
              ///số lượng tồn
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
                      onPress: () async {
                        var result = await Get.toNamed(ERouter.inventoryItemDetailQuotePricePage.name,
                            arguments: inventroyItem
                        );

                        /*if(result != null && (result == "true" || result == true)) {
                          final controllerCart = Get.find<InventoryItemQuotePriceController>();
                          List<InventroyItemModel> listItemsInCart = controllerCart.quotesCart;
                          controller.calcTotalInCart(listItemsInCart);
                          controllerCart.fetchInventoryItem();
                        }*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Xem chi tiết',
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                fontSize: 14.5.sp, color: AppColors.blue),
                          ),
                          Icon(Icons.arrow_right, color: AppColors.blue, size: 21.sp,),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        inventroyItem.soluongBaoGia <= 0 ? SizedBox(height: 0,) : Row(
                          children: [
                            InkWellWidget(
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  CupertinoIcons.minus_circled,
                                  size: 28,
                                  color: AppColors.orItemDetailProduct,
                                ),
                              ),
                              onPress: () {
                                if(inventroyItem.soluongBaoGia <= 0) inventroyItem.soluongBaoGia = 0;
                                else inventroyItem.soluongBaoGia--;
                                controller.calcQuoteCart4Item(inventroyItem);
                              },
                            ),
                            InkWellWidget(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                constraints: BoxConstraints(minHeight: 36, minWidth: 36),
                                decoration: BoxDecoration(
                                    color: AppColors.blue100,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.white, width: 1.8)),
                                child: Center(
                                  child: Text("${inventroyItem.soluongBaoGia}",
                                    style: Theme.of(context).textTheme.bodyText1?.copyWith(),
                                  ),
                                ),
                              ),
                              onPress: () {
                                InventoryProductModel currentItem = new InventoryProductModel(
                                    ten: inventroyItem.name,
                                    ma: inventroyItem.code,
                                    unit: inventroyItem.unit,
                                    quantity: inventroyItem.quantity!
                                );

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return InputKiemKhoWithPlanDialog(
                                          inventroyItemPlan: currentItem,
                                          value: inventroyItem.soluongBaoGia.toDouble(),
                                          type: InputNumberTypeKiemKho.QUANTITY,
                                          title: "Số lượng:",
                                          callback: (newQuantity) {
                                            inventroyItem.soluongBaoGia = newQuantity.toInt();
                                            controller.calcQuoteCart4Item(inventroyItem);
                                          });
                                    }
                                );
                              },
                            )
                          ],
                        ),
                        InkWellWidget(
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              CupertinoIcons.add_circled_solid,
                              size: 28,
                              color: AppColors.blue,
                            ),
                          ),
                          onPress: () {
                            inventroyItem.soluongBaoGia++;
                            controller.calcQuoteCart4Item(inventroyItem);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              )
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
    final InventoryItemQuotePriceController controller = Get.find();
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
              title: 'Chọn nhóm hàng',
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

class _InventoryItemCartWidget extends StatelessWidget {
  const _InventoryItemCartWidget({
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
    final controller = Get.find<InventoryItemQuotePriceController>();
    return inventroyItem.soluongBaoGia <= 0
        ?
    SizedBox(height: 0,)
        :
    InkWellWidget(
        onPress: onPress,
        child: Container(
            margin: const EdgeInsets.only(top: 0, bottom: 8),
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
            color: backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  inventroyItem.code ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppConstant.spaceVerticalSmallExtra,
                          Text(
                            inventroyItem.name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(fontSize: 14.sp, height: 1.3, color: AppColors.grey),
                          ),
                          AppConstant.spaceVerticalSmallMedium,
                          Row(
                            children: [
                              Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        'Giá sỉ: ',
                                        style: Theme.of(context).textTheme.caption?.copyWith(
                                            fontSize: 13.sp, color: AppColors.grey),
                                      ),
                                      Text(
                                        '${(inventroyItem.Price0 ?? 0).toAmountFormat()}',
                                        style: Theme.of(context).textTheme.caption?.copyWith(
                                            fontSize: 13.sp, color: AppColors.blue),
                                      ),
                                    ],
                                  )
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      'Giá lẻ: ',
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                          fontSize: 13.sp, color: AppColors.grey),
                                    ),
                                    Text(
                                      '${(inventroyItem.Price ?? 0).toAmountFormat()}',
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                          fontSize: 13.sp, color: AppColors.blue),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      flex: 7,
                    ),
                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                InkWellWidget(
                                  child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      CupertinoIcons.minus_circled,
                                      size: 28,
                                      color: AppColors.orItemDetailProduct,
                                    ),
                                  ),
                                  onPress: () {
                                    if(inventroyItem.soluongBaoGia <= 0) inventroyItem.soluongBaoGia = 0;
                                    else inventroyItem.soluongBaoGia--;
                                    controller.calcQuoteCart4Item(inventroyItem);
                                  },
                                ),
                                InkWellWidget(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                    constraints: BoxConstraints(minHeight: 36, minWidth: 36),
                                    decoration: BoxDecoration(
                                        color: AppColors.blue100,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.white, width: 1.8)),
                                    child: Center(
                                      child: Text("${inventroyItem.soluongBaoGia}",
                                        style: Theme.of(context).textTheme.bodyText1?.copyWith(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            InkWellWidget(
                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  CupertinoIcons.add_circled_solid,
                                  size: 28,
                                  color: AppColors.blue,
                                ),
                              ),
                              onPress: () {
                                inventroyItem.soluongBaoGia++;
                                controller.calcQuoteCart4Item(inventroyItem);
                              },
                            ),
                          ],
                        ),
                        flex: 3
                    ),
                  ],
                ),
              ],
            )
        )
    );
  }
}

class SummaryCartWidget extends StatelessWidget {
  const SummaryCartWidget({Key? key, this.disableViewCartList}) : super(key: key);

  final bool? disableViewCartList;

  @override
  Widget build(BuildContext context) {
    final InventoryItemQuotePriceController controller = Get.find();
    return Container(
        color: AppColors.blue50,
        padding: EdgeInsets.symmetric(
            horizontal: AppConstant.kSpaceHorizontalSmallExtra,
            vertical: AppConstant.kSpaceVerticalSmall
        ),
        child: InkWellWidget(
          child: controller.obx((state) {
            return Row(
              children: [
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(
                        CupertinoIcons.archivebox,
                        color: AppColors.blue,
                        size: 40,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2, left: 28),
                      child: IntrinsicWidth(
                        stepHeight: 3,
                        stepWidth: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            shape: BoxShape.rectangle,
                            color: AppColors.blue,
                          ),
                          child: Center(
                              child: Text("${controller.totalQty >= 100 ? "99+" : controller.totalQty}",
                                maxLines: 1,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: Text('${controller.totalAmount.toAmountFormat()} đ',
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp),
                    )
                ),
                SizedBox(
                  height: 35,
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Gửi báo giá',
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp
                          ),
                        ),
                        AppConstant.spaceHorizontalSmall,
                        Icon(Icons.send, size: 15.sp, color: Colors.white,)
                      ],
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: controller.totalQty > 0 ? AppColors.blue : AppColors.grey300,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () async {
                      if(controller.totalQty <= 0) return;
                      var result = await Get.toNamed(ERouter.priceInfoPage.name);

                      /*if(result != null) {
                        final controllerCart = Get.find<InventoryItemQuotePriceController>();
                        List<InventroyItemModel> listItemsInCart = controllerCart.quotesCart;
                        controller.calcTotalInCart(listItemsInCart);
                        controllerCart.fetchInventoryItem();
                      }*/
                    },
                  ),
                ),
              ],
            );
          },
              onLoading: SizedBox(height: 0,)
          ),
          onPress: () {
            if(disableViewCartList == true) return;
            showCartItemsWidget(context);
          },
        )
    );
  }

  showCartItemsWidget(BuildContext context) {
    final InventoryItemQuotePriceController controller = Get.find();
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: controller.obx((state) {
              List<InventroyItemModel> list = controller.quotesCart;
              int n = list.length;
              //print("cart quote item: $n");
              return Column(
                children: [
                  SummaryCartWidget(disableViewCartList: true),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        child: controller.obx((state) {
                          return
                            controller.totalQty <= 0 ?
                            Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text("Không có sản phẩm nào trong giỏ.",
                                      style: TextStyle(color: AppColors.grey300)
                                  ),
                                )
                            )
                                :
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final InventroyItemModel item = list[index];
                                  return _InventoryItemCartWidget(
                                    inventroyItem: item,
                                    backgroundColor: index % 2 == 0
                                        ? AppColors.grey50.withOpacity(0.1)
                                        : null,
                                  );
                                },
                                itemCount: n
                            );
                        }),
                      ),
                    ),
                  )
                ],
              );
            }),
          );
        });
  }
}