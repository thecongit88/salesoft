import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/inventory_item_model.dart';
import 'package:sale_soft/model/order_model.dart';
import 'package:sale_soft/model/topsale_model.dart';
import 'package:sale_soft/pages/account/receipt_detail/receipt_detail_controller.dart';
import 'package:sale_soft/pages/account/receipt_detail/receipt_detail_page.dart';
import 'package:sale_soft/pages/account/search_customer/customer_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/dash_line_widget.dart';
import 'package:sale_soft/widgets/expanded_widget.dart';
import 'package:sale_soft/widgets/filter_warehouse_widget.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/input_dialog.dart';
import 'order_controller.dart';
import 'package:sale_soft/common/number_formater.dart';

class OrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OrderPage();
  }
}

class _OrderPage extends State<OrderPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 48,
        elevation: 0,
        leading: BackButtonWidget(),
        backgroundColor: AppColors.blue,
        centerTitle: false,
        title: TitleAppBarWidget(
          title: "Tạo mới phiếu đặt hàng",
        ),
      ),
      body: controller.obx((data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppConstant.spaceVerticalMediumExtra,
            _StepByStepWidget(
              documentExpanded: controller.documentExpanded,
              inventoryItemExpanded: controller.inventoryItemExpanded,
              saveOrderExpanded: controller.saveOrderExpanded,
              onClick: (step) {
                switch (step) {
                  case 1:
                    controller.setDocumentActive();
                    break;
                  case 2:
                    controller.setInventoryItemActive();
                    break;
                  case 3:
                    controller.setSaveOrderActive();
                    break;
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppConstant.spaceVerticalMediumExtra,
                    _DocumentInfoWidget(
                        isExpanded: controller.documentExpanded,
                        expandStateChange: (isExpanded) {
                          controller.setDocumentActive()();
                        }),
                    AppConstant.spaceVerticalSmallExtraExtraExtra,
                    _InventoryItemsWidget(
                      isExpanded: controller.inventoryItemExpanded,
                      expandStateChange: (isExpanded) {
                        controller.setInventoryItemActive();
                      },
                    ),
                    AppConstant.spaceVerticalSmallExtraExtraExtra,
                    _SaveOrderWidget(controller.saveOrderExpanded,
                        (isExpanded) {
                      controller.setSaveOrderActive();
                    }),
                    AppConstant.spaceVerticalSmallExtraExtraExtra,
                    _ExpandedItemNoBorder(
                      expandStateChange: (topSaleExpanded) {
                        controller.topReceiptExpanded =
                            !controller.topReceiptExpanded;
                        controller.updateUi();
                      },
                      isExpanded: controller.topReceiptExpanded,
                      title: 'Danh sách chứng từ gần đây',
                      childExpanded: ListView.separated(
                          padding: EdgeInsets.only(
                              top: AppConstant.kSpaceVerticalSmallExtraExtraExtra),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final TopsaleModel invoice =
                                controller.listTopSale[index];

                            return InkWellWidget(
                              onPress: () {
                                return;
                                ///congnt: bỏ chỗ mở popup xem chi tiết này đi vì TopsaleModel bị thiếu thông tin của khách hàng
                                /*Dialog dialog = Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.r)), //this right here
                                  child: ReceiptDetailPage(invoice.chungTu!, type: AppConstant.otPhieuDatHang,),
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: AppConstant
                                          .kSpaceHorizontalSmallExtraExtraExtra),
                                );
                                showDialog(
                                    context: context,
                                    builder: (context) => dialog).then((value) {
                                  Get.delete<ReceiptDetailController>();
                                });*/
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 22.r,
                                          height: 22.r,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: invoice.getColor(),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.r)),
                                              shape: BoxShape.rectangle),
                                          child: Text(
                                            invoice.stt.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                ?.copyWith(color: Colors.white),
                                          ),
                                        ),
                                        AppConstant.spaceHorizontalSmallExtra,
                                        Expanded(
                                          child: _TopSaleColumnWidget(
                                            topValue: invoice.loai ?? '',
                                            botValue: invoice.chungTu ?? '',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _TopSaleColumnWidget(
                                      topValue:
                                          'Ngày: ${DateTimeHelper.dateToStringFormat(date: invoice.ngay)}',
                                      botValue:
                                          'Số lượng: ${(invoice.soLuong ?? 0).toInt().toString()}',
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      (invoice.thanhTien ?? 0).toAmountFormat(),
                                      textAlign: TextAlign.end,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              thickness: 1,
                              color: AppColors.grey50,
                              height: 30,
                            );
                          },
                          itemCount: controller.listTopSale.length),
                    ),
                    AppConstant.spaceVerticalSmallExtraExtraExtra,
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _SaveOrderWidget(
      bool isExpanded, Function(bool isExpanded) expandStateChange) {
    var controller = Get.find<OrderController>();
    return _ExpandedItem(
        expandStateChange: expandStateChange,
        isExpanded: isExpanded,
        childExpanded: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(child: Text("Tiền hàng: ")),
                Text(controller.calculateTotalAmount().toAmountFormat())
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text("Tiền thuế: "),
                Container(
                  padding: EdgeInsets.only(
                    left: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                  ),
                  height: 30.h,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: AppColors.blue50,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      shape: BoxShape.rectangle),
                  width: 70.w,
                  child: DropdownButtonFormField<String>(
                    onChanged: (s) {
                      if (s == "10%") {
                        controller.tax = 10;
                      } else if (s == "5%") {
                        controller.tax = 5;
                      } else {
                        controller.tax = 0;
                      }
                      controller.updateUi();
                    },
                    decoration: InputDecoration.collapsed(hintText: "10%"),
                    items: <String>["10%", "5%", "0%"].map((value) {
                      return DropdownMenuItem<String>(
                          child: Text(
                            value,
                            textAlign: TextAlign.start,
                          ),
                          value: value);
                    }).toList(),
                  ),
                ),
                Expanded(child: SizedBox()),
                Text((controller.calculateTotalAmount() / 100 * controller.tax)
                    .toAmountFormat())
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(child: Text("Thành tiền: ")),
                Text((controller.calculateTotalAmount() *
                        (1 + controller.tax / 100))
                    .toAmountFormat())
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(child: Text("Tạm ứng: ")),
                InkWellWidget(
                  onPress: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return InputDialog(
                              value: controller.prepaid,
                              type: InputNumberType.QUANTITY,
                              title: "Nhập số tiền",
                              callback: (newQuantity) {
                                controller.prepaid = newQuantity;
                                controller.updateUi();
                              });
                        });
                  },
                  child: Container(
                    child: Text(controller.prepaid.toAmountFormat()),
                    padding: EdgeInsets.only(
                      left: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                    ),
                    height: 30.h,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: AppColors.blue50,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        shape: BoxShape.rectangle),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(child: Text("Ngày hẹn giao: ")),
                InkWellWidget(
                  onPress: () {
                    _selectDate(context);
                  },
                  child: Container(
                    child: Text(
                        DateTimeHelper.dateToStringFormat(
                                date: controller.deadlineDate) ??
                            "",
                        style: TextStyle(fontWeight: FontWeight.normal)), //
                    padding: EdgeInsets.only(
                      left: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
                    ),
                    height: 30.h,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: AppColors.blue50,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        shape: BoxShape.rectangle),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 32,
            ),
            InkWellWidget(
              child: Container(
                height: 45.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    shape: BoxShape.rectangle),
                child: Text(
                  "Lưu phiếu",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPress: () async {
                controller.createOrder();
              },
            )
          ],
        ),
        title: "Lưu phiếu");
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _selectDate(BuildContext context) async {
    var controller = Get.find<OrderController>();
    final DateTime? picked = await showDatePicker(
        context: context,
        locale: const Locale("vi", "VN"),
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        cancelText: 'Bỏ qua',
        confirmText: 'Đồng ý',
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.blue,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: AppColors.blue,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            child: child!,
          );
        }
    );
    if (picked != null && picked != controller.deadlineDate) {
      controller.setDeadlineDate(picked);
    }
  }
}

class _InventoryItemsWidget extends StatelessWidget {
  const _InventoryItemsWidget(
      {Key? key, required this.isExpanded, required this.expandStateChange})
      : super(key: key);
  final bool isExpanded;
  final Function(bool isExpanded) expandStateChange;
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<OrderController>();
    return _ExpandedItem(
      isExpanded: isExpanded,
      expandStateChange: expandStateChange,
      title: "Danh sách hàng hóa",
      childExpanded: Column(
        children: [
          AppConstant.spaceVerticalSmallMedium,
          !controller.listItem.isEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: AppConstant.kSpaceVerticalSmallExtra,
                          bottom: AppConstant.kSpaceVerticalSmallExtra),
                      width: double.infinity,
                      height: 1,
                      color: AppColors.grey50,
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildInventoryItemWidget(
                        context, controller.listItem[index]);
                  },
                  itemCount: controller.listItem.length)
              : Container(
                  width: double.infinity,
                  height: 75,
                  child: Center(
                    child: Text(
                      "Chưa có hàng hóa",
                      style: TextStyle(color: AppColors.grey50),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
          AppConstant.spaceVerticalSmallMedium,
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.grey50,
          ),
          AppConstant.spaceVerticalSmallMedium,
          Row(
            children: [
              Expanded(
                child: InkWellWidget(
                  onPress: () async {
                    List<InventroyItemModel> selectedList = await Get.toNamed(
                        ERouter.inventoryItem.name,
                        arguments: controller.listItem);

                    controller.setNewData(selectedList);
                  },
                  child: Text(
                    "Thêm hàng",
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 14,
                      fontStyle: FontStyle.italic, // italic
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: controller.listItem.isNotEmpty
                        ? TextAlign.start
                        : TextAlign.center,
                  ),
                ),
              ),
              Visibility(
                visible: controller.listItem.isNotEmpty,
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'Số lượng: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: controller.getTotalQuantity().toString(),
                    style: TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: ' Thành tiền: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: controller.calculateTotalAmount().toAmountFormat(),
                    style: TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ])),
              )
            ],
          )
        ],
      ),
    );
  }

  Container buildInventoryItemWidget(
      BuildContext context, InventroyItemModel item) {
    var controller = Get.find<OrderController>();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.code ?? "",
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: AppColors.grey300, fontSize: 10.sp),
          ),
          _InventoryItemNameWidget(
            name: item.name,
            onDelete: () {
              controller.listItem
                  .removeWhere((element) => element.code == item.code);
              controller.updateUi();
            },
          ),
          Row(
            children: [
              SizedBox(
                width: 40.w,
                child: Row(
                  children: [
                    // Text(
                    //   'SL',
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .caption
                    //       ?.copyWith(fontSize: 10.sp),
                    // ),
                    // AppConstant.spaceHorizontalSmall,
                    Expanded(
                      child: InkWellWidget(
                        onPress: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return InputDialog(
                                    value: item.quantity ?? 0.0,
                                    type: InputNumberType.QUANTITY,
                                    title: "Nhập số lượng",
                                    callback: (newQuantity) {
                                      item.quantity = newQuantity;
                                      controller.updateUi();
                                    });
                              });
                        },
                        child: Container(
                          height: 30.h,
                          child: Center(
                              child: Text("${item.quantity}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ))),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            border:
                                Border.all(color: AppColors.grey50, width: 1),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              AppConstant.spaceHorizontalSmall,
              Text("X",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold)),
              AppConstant.spaceHorizontalSmall,
              SizedBox(
                width: 60.w,
                child: Row(
                  children: [
                    // Text(
                    //   'ĐG',
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .caption
                    //       ?.copyWith(fontSize: 10.sp),
                    // ),
                    // AppConstant.spaceHorizontalSmall,
                    Expanded(
                      child: InkWellWidget(
                        onPress: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return InputDialog(
                                    value: item.Price ?? 0.0,
                                    type: InputNumberType.PRICE,
                                    title: "Nhập đơn giá",
                                    priceMin: 0.0,
                                    callback: (newPrice) {
                                      item.Price = newPrice;
                                      controller.updateUi();
                                    });
                              });
                        },
                        child: Container(
                          height: 30.h,
                          child: Center(
                              child: Text((item.Price ?? 0.0).toAmountFormat(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ))),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            border:
                                Border.all(color: AppColors.grey50, width: 1),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              AppConstant.spaceHorizontalSmall,
              Text("KM",
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold)),
              AppConstant.spaceHorizontalSmall,
              SizedBox(
                width: 60.w,
                child: InkWellWidget(
                  onPress: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return InputDialog(
                              value: item.promotion,
                              type: InputNumberType.PRICE,
                              title: "Nhập khuyến mại",
                              priceMin: 0.0,
                              callback: (newPromotion) {
                                item.promotion = newPromotion;
                                controller.updateUi();
                              });
                        });
                  },
                  child: Container(
                    height: 30.h,
                    child: Center(
                        child: Text(getPromotionDisplay(item),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ))),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(color: AppColors.grey50, width: 1),
                    ),
                  ),
                ),
              ),
              AppConstant.spaceHorizontalSmall,
              Text(
                '= ${controller.calculateTotalEachItem(item).toAmountFormat()}',
                style: Theme.of(context).textTheme.caption?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange),
              )
            ],
          ),
        ],
      ),
    );
  }

  String getPromotionDisplay(InventroyItemModel item) {
    if (item.promotion <= 100 && item.promotion > 0.0) {
      return item.promotion.toAmountFormat() + "%";
    } else {
      if (item.promotion == 0.0) {
        return "0.0";
      } else {
        return item.promotion.toString() + "đ";
      }
    }
  }
}

class _InventoryItemNameWidget extends StatelessWidget {
  const _InventoryItemNameWidget({
    Key? key,
    this.name,
    this.onDelete,
  }) : super(key: key);

  final String? name;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name ?? '',
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: AppColors.grey700),
          ),
        ),
        InkWellWidget(
          padding: EdgeInsets.all(AppConstant.kSpaceHorizontalSmallExtra),
          borderRadius: 12.r,
          onPress: onDelete,
          child: Image.asset(
            AppResource.icTrash,
            fit: BoxFit.fill,
            width: 12.r,
            height: 12.r,
          ),
        )
      ],
    );
  }
}

class _DocumentInfoWidget extends StatelessWidget {
  const _DocumentInfoWidget(
      {Key? key, required this.isExpanded, required this.expandStateChange})
      : super(key: key);
  final bool isExpanded;
  final Function(bool isExpanded) expandStateChange;
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<OrderController>();

    return _ExpandedItem(
      isExpanded: isExpanded,
      expandStateChange: expandStateChange,
      title: 'Thông tin chứng từ',
      childExpanded: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppConstant.spaceVerticalSmall,
          _OneLineInfoWidget(
            title: "Ngày: ",
            value: DateTimeHelper.dateToStringFormat(date: DateTime.now()),
          ),
          AppConstant.spaceVerticalSmall,
          _OneLineInfoWidget(
            title: "Số chứng từ: ",
            value: controller.orderCode,
          ),
          AppConstant.spaceVerticalSmallMedium,
          AppConstant.spaceVerticalSmallMedium,
          SearchCustomerWidget(),
          AppConstant.spaceVerticalSmallMedium,
          StoreDropdownWidget(),
          AppConstant.spaceVerticalSmallMedium,
        ],
      ),
    );
  }
}

class _OneLineInfoWidget extends StatelessWidget {
  const _OneLineInfoWidget({
    Key? key,
    this.title,
    this.value,
  }) : super(key: key);

  final String? title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: title,
            style: Theme.of(context).textTheme.caption,
            children: [
          TextSpan(
              text: value,
              style: Theme.of(context).textTheme.caption?.copyWith(
                    fontWeight: FontWeight.bold,
                  ))
        ]));
  }
}

class _StepByStepWidget extends StatelessWidget {
  const _StepByStepWidget(
      {Key? key,
      required this.documentExpanded,
      required this.inventoryItemExpanded,
      required this.saveOrderExpanded,
      required this.onClick})
      : super(key: key);
  final bool documentExpanded;
  final bool inventoryItemExpanded;
  final bool saveOrderExpanded;
  final Function(int step) onClick;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepWidget(
            number: "1",
            title: "Chứng từ",
            isActive: documentExpanded,
            onClick: () {
              onClick(1);
            },
          ),
          _DashWidget(),
          _StepWidget(
            onClick: () {
              onClick(2);
            },
            number: "2",
            isActive: inventoryItemExpanded,
            title: "Hàng hóa",
          ),
          _DashWidget(),
          _StepWidget(
            onClick: () {
              onClick(3);
            },
            isActive: saveOrderExpanded,
            number: "3",
            title: "Lưu phiếu",
          ),
        ],
      ),
    );
  }
}

class _DashWidget extends StatelessWidget {
  const _DashWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 40.w,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: DashLineWidget(
            color: AppColors.grey50,
          ),
        ));
  }
}

class _StepWidget extends StatelessWidget {
  const _StepWidget(
      {Key? key,
      this.number,
      this.title,
      required this.isActive,
      required this.onClick})
      : super(key: key);

  final String? number;
  final String? title;
  final bool isActive;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            InkWellWidget(
              onPress: onClick,
              child: Container(
                width: 44.r,
                height: 44.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: isActive ? AppColors.blue : AppColors.grey300,
                    shape: BoxShape.circle),
                child: Text(
                  number ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
            AppConstant.spaceVerticalSmallExtra,
            Text(
              title ?? '',
              style: Theme.of(context).textTheme.caption,
            )
          ],
        )
      ],
    );
  }
}

class _ExpandedItemNoBorder extends StatelessWidget {
  const _ExpandedItemNoBorder(
      {Key? key,
      required this.childExpanded,
      required this.title,
      required this.isExpanded,
      required this.expandStateChange})
      : super(key: key);

  final Widget childExpanded;
  final String title;
  final bool isExpanded;
  final Function(bool isExpanded) expandStateChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
      padding: EdgeInsets.only(
          left: AppConstant.kSpaceHorizontalSmallExtraExtra,
          right: AppConstant.kSpaceHorizontalSmallExtraExtra,
          top: AppConstant.kSpaceVerticalSmallExtraExtra,
          bottom: AppConstant.kSpaceVerticalSmallExtraExtra),
      child: Column(
        children: [
          _TitleViewCenter(
            title: title,
            isExpanded: isExpanded,
            titleColor: isExpanded ? AppColors.blue : AppColors.blue,
            onChangeValue: () {
              expandStateChange(isExpanded);
            },
          ),
          ExpandedWidget(
            expand: isExpanded,
            child: childExpanded,
          )
        ],
      ),
    );
  }
}

class _ExpandedItem extends StatelessWidget {
  const _ExpandedItem(
      {Key? key,
      required this.childExpanded,
      required this.title,
      required this.isExpanded,
      required this.expandStateChange})
      : super(key: key);

  final Widget childExpanded;
  final String title;
  final bool isExpanded;
  final Function(bool isExpanded) expandStateChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
      padding: EdgeInsets.only(
          left: AppConstant.kSpaceHorizontalSmallExtraExtra,
          right: AppConstant.kSpaceHorizontalSmallExtraExtra,
          top: AppConstant.kSpaceVerticalSmallExtraExtra,
          bottom: AppConstant.kSpaceVerticalSmallExtraExtra),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(
            color: AppColors.grey50,
          ),
          shape: BoxShape.rectangle),
      child: Column(
        children: [
          _TitleView(
            title: title,
            isExpanded: isExpanded,
            titleColor: isExpanded ? AppColors.blue : AppColors.grey700,
            onChangeValue: () {
              expandStateChange(isExpanded);
            },
          ),
          ExpandedWidget(
            expand: isExpanded,
            child: childExpanded,
          )
        ],
      ),
    );
  }
}

class _TitleViewCenter extends StatelessWidget {
  const _TitleViewCenter({
    Key? key,
    required this.title,
    required this.isExpanded,
    this.titleColor,
    this.onChangeValue,
  }) : super(key: key);

  final String title;
  final bool isExpanded;
  final Color? titleColor;
  final Function()? onChangeValue;

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onPress: onChangeValue,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                color: titleColor ?? AppColors.grey,
                fontWeight: FontWeight.w600),
          ),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: AppColors.blue,
          )
        ],
      ),
    );
  }
}

class _TitleView extends StatelessWidget {
  const _TitleView({
    Key? key,
    required this.title,
    required this.isExpanded,
    this.titleColor,
    this.onChangeValue,
  }) : super(key: key);

  final String title;
  final bool isExpanded;
  final Color? titleColor;
  final Function()? onChangeValue;

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onPress: onChangeValue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  color: titleColor ?? AppColors.grey,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: AppColors.grey300,
          )
        ],
      ),
    );
  }
}

class SearchCustomerWidget extends StatelessWidget {
  const SearchCustomerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<OrderController>();
    return Container(
        decoration: BoxDecoration(
            color: AppColors.blue100,
            borderRadius: BorderRadius.all(Radius.circular(6))),
        height: 48,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextFormField(
                  onTap: () async {
                    var result =  await Get.toNamed(
                        ERouter.customerList.name,
                        arguments: controller.customerController.text);
                    if(result != null) {
                      CustomerModel customer = result;
                      controller.setCustomer(customer);
                    }
                  },
                  readOnly: true,
                  controller: controller.customerController,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      ?.copyWith(color: AppColors.grey300, fontSize: 14, fontWeight: FontWeight.bold),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 50, right: 8, top: 2, bottom: 2),
                    hintText: "Chọn khách hàng",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
                  ),

                ),
                SizedBox(
                  width: 37,
                  child: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppColors.grey300,
                    size: 32.r,
                  ),
                )
              ],
            ),
            Container(
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 0.8, color: AppColors.grey50))),
              width: 37,
              child: Icon(Icons.search, color: AppColors.grey300, size: 19.sp,),
            ),
          ],
        )
    );

    ///old code
    return Row(
      children: [
        Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.blue100,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              height: 48,
              child: TextFormField(
                onTap: () async {
                  print("click here");
                  CustomerModel customer = await Get.toNamed(
                      ERouter.customerList.name,
                      arguments: controller.customerController.text);

                  if (customer != null) {
                    controller.setCustomer(customer);
                  }
                },
                readOnly: true,
                controller: controller.customerController,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    ?.copyWith(color: Colors.black, fontSize: 14),
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        left: 8, right: 8, top: 2, bottom: 2),
                    hintText: "Khách hàng",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(color: Colors.grey, fontSize: 14)),
              )
            )
        ),
        SizedBox(
          width: 8,
        ),
        Container(
          decoration: BoxDecoration(
              color: AppColors.blue100,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          width: 48,
          height: 48,
          child: IconButton(
            icon: Icon(
              Icons.filter_alt_outlined,
              color: AppColors.grey,
            ),
            onPressed: () async {
              CustomerModel customer = await Get.toNamed(
                    ERouter.customerList.name,
                    arguments: controller.customerController.text);

                if (customer != null) {
                  controller.setCustomer(customer);
                }
            },
          ),
        )
      ],
    );
  }
}

class StoreDropdownWidget extends StatelessWidget {
  const StoreDropdownWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<OrderController>();
    return InkWellWidget(
        onPress: () {
          showViewDialog(
              context,
              FilterWarehouseWidget(
                searchListWarehouse: (String keyword) {
                  return controller.searchWarehouseByKey(keyword);
                },
                onDone: (item) {
                  Get.back();
                  controller.setSelectedWarehouse(item);
                },
              ));
        },
        child: Container(
          padding:
              EdgeInsets.only(left: AppConstant.kSpaceHorizontalSmallExtra),
          height: 48,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: AppColors.blue50,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              shape: BoxShape.rectangle),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 41),
                      child: Text(
                        controller.warehouseSelected == null
                            ? 'Chọn kho hàng'
                            : controller.warehouseSelected?.Ten ?? "",
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: AppColors.grey300, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  AppConstant.spaceHorizontalSmall,
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: AppColors.grey300,
                    size: 30.r,
                  ),
                  AppConstant.spaceHorizontalSmall,
                ],
              ),
              Container(
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 0.8, color: AppColors.grey50))),
                padding: const EdgeInsets.only(left: 0, right: 10),
                child: Icon(Icons.search, color: AppColors.grey300, size: 19.sp,),
              ),
            ],
          )
        ));
  }
}

class _TopSaleColumnWidget extends StatelessWidget {
  const _TopSaleColumnWidget({
    Key? key,
    required this.topValue,
    required this.botValue,
  }) : super(key: key);

  final String topValue;
  final String botValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          topValue,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .caption
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          botValue,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption?.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.grey300),
        ),
      ],
    );
  }
}
