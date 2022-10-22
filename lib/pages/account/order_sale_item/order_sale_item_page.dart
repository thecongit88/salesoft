import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/app_global.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/customer_debt_model.dart';
import 'package:sale_soft/model/customer_detail_model.dart';
import 'package:sale_soft/model/customer_with_debt.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/debt.dart';
import 'package:sale_soft/model/order_model.dart';
import 'package:sale_soft/pages/account/customer_list/customer_list_controller.dart';
import 'package:sale_soft/pages/account/detail_customer_debt/detail_customer_debt_controller.dart';
import 'package:sale_soft/pages/account/order_sale_item/order_sale_item_controller.dart';
import 'package:sale_soft/pages/account/receipt_detail/receipt_detail_controller.dart';
import 'package:sale_soft/pages/account/receipt_detail/receipt_detail_page.dart';
import 'package:sale_soft/pages/account/searchCustomerDebt/search_customer_debt_controller.dart';
import 'package:sale_soft/pages/account/search_customer/customer_page.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/filter_time_widget.dart';
import 'package:sale_soft/widgets/filter_widget.dart';
import 'package:sale_soft/enum/period_time.dart';
import 'package:sale_soft/common/number_formater.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/search_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSaleItemPage extends StatefulWidget {
  const OrderSaleItemPage({Key? key}) : super(key: key);

  @override
  _OrderSaleItemPageState createState() => _OrderSaleItemPageState();
}

/*class OrderSaleItemPage extends StatelessWidget {*/
class _OrderSaleItemPageState extends State<OrderSaleItemPage>
    with AutomaticKeepAliveClientMixin<OrderSaleItemPage> {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final OrderSaleItemController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: BackButtonWidget(),
        backgroundColor: AppColors.blue,
        centerTitle: false,
        title: TitleAppBarWidget(
          title: controller.argument!.title!,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
            vertical: AppConstant.kSpaceVerticalSmallExtraExtra),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded(
            //   child: _HeaderWidget(),
            // ),
            _HeaderFilterTimeWidget(),
            AppConstant.spaceVerticalSmallMedium,
            AppConstant.spaceVerticalSmallMedium,
            SearchWidget(
                hintText: "Nhập mã, số điện thoại hoặc mã chứng từ",
                textEditingController: controller.edittextController,
                onChange: (keyword) async {
                  controller.getListOrderSales();
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
                    //qrCodeResult = "HBB.01.22.07-0141";

                    ///Tìm theo mã chứng từ
                    if(qrCodeResult.isNotEmpty) {
                      if(hasValidUrl(qrCodeResult)) {
                        openUrl(qrCodeResult);
                      } else {
                        controller.edittextController.text = qrCodeResult;
                        controller.getListOrderSales();
                      }
                    } else {
                      showErrorToast("Không tìm thấy mã phiếu/đơn hàng.");
                    }
                  },
                ),
            ),
            AppConstant.spaceVerticalSmallMedium,
            controller.argument!.type! != AppConstant.otHoaDonBanHang && controller.argument!.type! != AppConstant.otHoaDonXuatHang ?
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _CheckBoxButtonWidget(
                  title: 'Nợ quá hạn',
                  onPress: (value) {
                    controller.getListOrderSales();
                  },
                  isChecked: controller.isSelectedNoQuaHan,
                )
              ],
            ) : SizedBox(height: 0,),
            AppConstant.spaceVerticalSmallMedium,
            Expanded(
              child: controller.obx((orderSales) {
                return SmartRefresher(
                  controller: controller.refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () => controller.getListOrderSales(),
                  onLoading: () => controller.getListOrderSales(isLoadMore: true),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        OrderModel order = orderSales![index];
                        ///dành cho chứng từ có order type = 1 và 2
                        if(controller.isSelectedNoQuaHan.value == true && controller.argument!.type != AppConstant.otHoaDonBanHang) {
                          order.ttDatHang = "Nợ quá hạn";
                        }

                        return _CustomerWidget(
                          orderSale: orderSales[index],
                          /*backgroundColor:
                          index % 2 == 0 ? AppColors.grey50.withOpacity(0.1) : null,*/
                          onPress: () {
                            /*showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: ReceiptDetailPage(orderSales[index].chungTu!),
                              );
                            }).then((value) => Get.delete<ReceiptDetailController>());*/

                            Dialog dialog = Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.r)), //this right here
                              child: ReceiptDetailPage(order.chungTu!, itOrderModel: order, type: controller.argument!.type,),
                              insetPadding: EdgeInsets.symmetric(
                                  horizontal: AppConstant
                                      .kSpaceHorizontalSmallExtraExtraExtra),
                            );
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => dialog).then((value) {
                              Get.delete<ReceiptDetailController>();
                              if(value == 1 || value == "1") {
                                controller.getListOrderSales();
                              }
                            });
                          },
                        );
                      },
                      itemCount: orderSales!.length),
                );
              },
              onEmpty: EmptyDataWidget(
                  onReloadData: () => controller.getListOrderSales(),
                  msg: "Không có dữ liệu. Vui lòng chọn thời gian khác hoặc tiêu chí tìm kiếm khác.",
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: controller.argument!.type == AppConstant.otHoaDonBanHang || controller.argument!.type == AppConstant.otHoaDonXuatHang ? null :
      FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.blue,
        onPressed: () async {
          var result =  await Get.toNamed(ERouter.orderPage.name);
          if(result != null && result == "1") {
            controller.isSelectedNoQuaHan.value = false;
            controller.getListOrderSales();
          }
        },
      ),
    );
  }
}

Widget buildData(CustomerWithDebt customerWithDebt) {
  var listCustomerDetail = customerWithDebt.listCustomerDetail;
  var listDebt = customerWithDebt.listDebt;

  return Expanded(
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          buildCustomerDetail(listCustomerDetail!),
          SizedBox(
            height: 16,
          ),
          buildDebtTable(listDebt),
        ],
      ),
    ),
  );
}

Widget buildDebtTable(List<Debt> listDebt) {
  if (listDebt.isEmpty) {
    return Text("");
  } else {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        buildListDebt(listDebt),
      ]),
    );
  }
}

Widget buildTableHeader(List<Debt> listDebt) {
  return Row(
    children: [
      Expanded(
        child: Column(
          children: [
            horirontalLine(),
            headerCellWithVerticalLine("STT", 1, 1),
            horirontalLine(),
          ],
        ),
        flex: 5,
      ),
      Expanded(
        child: Column(
          children: [
            horirontalLine(),
            headerCellWithVerticalLine("Giao dịch", 0, 1),
            horirontalLine(),
          ],
        ),
        flex: 15,
      ),
      Expanded(
        child: Column(
          children: [
            horirontalLine(),
            headerCellWithVerticalLine("Số tiền", 0, 1),
            horirontalLine(),
          ],
        ),
        flex: 10,
      ),
      Expanded(
        child: Column(
          children: [
            horirontalLine(),
            headerCellWithVerticalLine("Thanh toán", 0, 1),
            horirontalLine(),
          ],
        ),
        flex: 10,
      ),
    ],
  );
}

Widget headerCellWithVerticalLine(String text, double wLeft, double wRight) {
  return Row(
    children: [
      verticalLine(wLeft),
      Expanded(
        child: Container(
          height: 35,
          color: AppColors.grey50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      verticalLine(wRight),
    ],
  );
}

Widget buildDataCellWithVerticalLineAlignCenter(String text, double wLeft,
    double wRight, CrossAxisAlignment crossAxisAlignment) {
  return Row(
    children: [
      verticalLine(wLeft),
      Expanded(
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      verticalLine(wRight),
    ],
  );
}

Widget buildListDebt(List<Debt> listDebt) {
  var originalLength = listDebt.length;
  listDebt.add(Debt());
  listDebt.insert(0, Debt());
  return ListView.builder(
    physics: NeverScrollableScrollPhysics(),
    itemCount: originalLength + 2,
    shrinkWrap: true,
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      var debt = listDebt[index];
      if (index == 0) {
        return buildTableHeader(listDebt);
      } else {
        if (index == originalLength + 1) {
          return buildTableFooter(listDebt);
        } else {
          return Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    buildDataCellWithVerticalLineAlignCenter(
                        debt.STT.toString(), 1, 1, CrossAxisAlignment.center),
                    horirontalLine()
                  ],
                ),
              ),
              Expanded(
                flex: 15,
                child: Column(
                  children: [
                    buildDataCellWithVerticalLineAlignCenter(
                        "   " + (debt.Chung_Tu ?? ""),
                        0,
                        1,
                        CrossAxisAlignment.start),
                    horirontalLine()
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Column(
                  children: [
                    buildDataCellWithVerticalLineAlignCenter(
                        "   " +
                            ((debt.MuaHang ?? 0.0).toAmountFormat()) +
                            "   ",
                        0,
                        1,
                        CrossAxisAlignment.start),
                    horirontalLine()
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Column(
                  children: [
                    buildDataCellWithVerticalLineAlignCenter(
                        ((debt.ThanhToan ?? 0.0).toAmountFormat()) + "   ",
                        0,
                        1,
                        CrossAxisAlignment.end),
                    horirontalLine()
                  ],
                ),
              )
            ],
          );
        }
      }
    },
  );
}

Widget buildTableFooter(List<Debt> listDebt) {
  var totalBuy = 0.0;
  var paid = 0.0;
  var remain = 0.0;

  for (Debt debt in listDebt) {
    totalBuy += debt.MuaHang ?? 0.0;
    paid += debt.ThanhToan ?? 0.0;
    remain += debt.ConLai ?? 0.0;
  }
  return Row(
    children: [
      Expanded(
        child: Column(
          children: [
            footerCellWithVerticalLineAlignRight("Tổng cộng:", 1, 1),
            horirontalLine(),
            footerCellWithVerticalLineAlignRight("Nợ đầu kỳ:", 1, 1),
            horirontalLine(),
            footerCellWithVerticalLineAlignRight("Còn lại:", 1, 1),
            horirontalLine()
          ],
        ),
        flex: 2,
      ),
      Expanded(
        child: Column(
          children: [
            footerCellWithVerticalLineAlignRight(
                totalBuy.toAmountFormat(), 0, 1),
            horirontalLine(),
            footerCellWithVerticalLineAlignRight("", 0, 1),
            horirontalLine(),
            footerCellWithVerticalLineAlignRight("", 0, 1),
            horirontalLine(),
          ],
        ),
        flex: 1,
      ),
      Expanded(
        child: Column(
          children: [
            footerCellWithVerticalLineAlignRight(paid.toAmountFormat(), 0, 1),
            horirontalLine(),
            footerCellWithVerticalLineAlignRight(
                (listDebt[0].DauKy ?? 0.0).toAmountFormat(), 0, 1),
            horirontalLine(),
            footerCellWithVerticalLineAlignRight(remain.toAmountFormat(), 0, 1),
            horirontalLine(),
          ],
        ),
        flex: 1,
      ),
    ],
  );
}

Row footerCellWithVerticalLineAlignRight(
    String text, double wLeft, double wRight) {
  return Row(
    children: [
      verticalLine(wLeft),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text + "   ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      verticalLine(wRight),
    ],
  );
}

Container verticalLine(double w) {
  return Container(
    width: w,
    height: 35,
    color: AppColors.grey,
  );
}

Container horirontalLine() {
  return Container(
    height: 1,
    color: AppColors.grey,
  );
}

Widget buildCustomerDetail(List<CustomerDetailModel> list) {
  if (list.isEmpty) {
    return Text("");
  } else {
    var detail = list[0];
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColors.grey400),
          borderRadius: BorderRadius.all(Radius.circular(6))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.name ?? "",
            style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Mã giao dịch: ",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, color: Colors.black)),
                      TextSpan(
                          text: "${detail.code}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black)),
                    ])),
              ),
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "MST: ",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, color: Colors.black)),
                      TextSpan(
                          text: "${detail.taxCode}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black)),
                    ])),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Nhân viên chăm sóc: ",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black)),
                TextSpan(
                    text: "${detail.staff}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ])),
          SizedBox(
            height: 8,
          ),
          RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Địa chỉ: ",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black)),
                TextSpan(
                    text: "${detail.address}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
              ])),
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchCustomerDebtPageController controller = Get.find();
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
          vertical: AppConstant.kSpaceVerticalSmallExtraExtra),
      child: Row(
        children: [
          Obx(() {
            return FilterWidget(
              textColor: Colors.black,
              title: controller.periodReportSelected.value.name,
              value: controller.periodReportSelected.value.timeValue.toString(),
              imageAssetName: AppResource.icCalendar,
              onPress: () {
                showViewDialog(
                    context,
                    FilterTimeWidget(
                      values: controller.listPeriodReport,
                      valueSelected: controller.periodReportSelected.value,
                      onPress: (value) {
                        Get.back();
                        controller.getDataByTimePeriod(value);
                      },
                    ));
              },
            );
          }),
          AppConstant.spaceHorizontalMediumExtra,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.blue100,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              height: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: controller.customerTextfieldController,
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
                        hintText: "Khách hàng"),
                  )
                ],
              ),
            ),
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
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () async {
                CustomerModel customer = await Get.toNamed(
                    ERouter.customerList.name,
                    arguments: controller.customerTextfieldController.text);

                if (customer != null) {
                  controller.customer = customer;
                  ///Hàm này đã chuyển sang controller chi tiết công nợ khách hàng
                  //controller.getData();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class _HeaderFilterTimeWidget extends StatelessWidget {
  const _HeaderFilterTimeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderSaleItemController controller = Get.find();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.timer, color: AppColors.grey, size: 15.sp,),
              SizedBox(width: 5,),
              Text("Thời gian:",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: AppColors.grey),
              )
            ],
          ),
          flex: 5,
        ),

        Expanded(
          child: Obx(() {
            return controller.argument!.type == AppConstant.otPhieuDatHang && controller.isSelectedNoQuaHan.value == true ?
                Text("- Tất cả -", style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: AppColors.green)
                )
                :
              FilterWidget(
                textColor: Colors.black,
                title: controller.periodReportSelected.value.name,
                value: controller.periodReportSelected.value.timeValue.toString(),
                imageAssetName: AppResource.icCalendar,
                onPress: () {
                  showViewDialog(
                      context,
                      FilterTimeWidget(
                        values: controller.listPeriodReport,
                        valueSelected: controller.periodReportSelected.value,
                        onPress: (value) {
                          Get.back();
                          controller.getDataByTimePeriod(value);
                          //controller.myTimeSelected = value;
                        },
                      ));
                },
              );
          }),
          flex: 15,
        ),
      ],
    );
  }
}

class _CustomerWidget extends StatelessWidget {
  const _CustomerWidget({
    Key? key,
    this.onPress,
    this.orderSale,
    this.backgroundColor,
  }) : super(key: key);

  final Function()? onPress;
  final OrderModel? orderSale;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final OrderSaleItemController controller = Get.find();
    String trangThaiHoaDon = controller.argument!.type == AppConstant.otHoaDonXuatHang ? orderSale!.ttXuatKho! : orderSale!.ttDatHang!;
    return InkWellWidget(
        onPress: onPress,
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(const Radius.circular(8.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: Offset(4, 8), // Shadow position
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("#${orderSale?.chungTu ?? '-'}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: AppColors.orHeadTitle, fontSize: 12.5.sp),
              ),
              AppConstant.spaceVerticalSmallExtra,
              /*Divider(
                thickness: 0.25,
                color: AppColors.grey50,
                height: 23,
              ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text("${orderSale?.tenKhachHang  ?? '- (không có mã k/h)'}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: AppColors.orMainTitle, fontSize: 15.sp),
                    ),
                    flex: 6,
                  ),
                  Spacer(),
                  Text("${orderSale?.phatSinhCo!.toAmountFormat() ?? '-'} đ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: AppColors.orPrice, fontSize: 14.sp),
                  ),
                ],
              ),
              AppConstant.spaceVerticalSmallExtra,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.timer, color: AppColors.grey, size: 15.sp,),
                  SizedBox(width: 3,),
                  Text("${DateTimeHelper.dateToStringFormat(date: orderSale!.ngay)}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: AppColors.orTime, fontSize: 14.sp),
                  ),
                ],
              ),
              AppConstant.spaceVerticalSmallExtra,

              InkWellWidget(
                child: Row(
                  children: [
                    Icon(Icons.wifi_calling_3_outlined, color: AppColors.grey, size: 15.sp,),
                    SizedBox(width: 5,),
                    Text("Phone: ${getNullOrEmptyValue(orderSale!.dienThoai)}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: AppColors.orHeadTitle, fontSize: 14.sp),
                    ),
                  ],
                ),
                onPress: () {
                  if(orderSale!.dienThoai!.isNotEmpty)
                    launch("tel:${orderSale!.dienThoai}");
                  else return;
                },
              ),
              //AppConstant.spaceVerticalMedium,
              Divider(
                thickness: 0.25,
                color: AppColors.grey50,
                height: 30,
              ),
              controller.argument!.type == AppConstant.otHoaDonBanHang ?
              Container(
                width: 100.r,
                height: 30.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.orItemDetailBg,
                    borderRadius: BorderRadius.all(
                        Radius.circular(4.r)),
                    shape: BoxShape.rectangle),
                child: Text("Số lượng ${orderSale?.soLuong!.toInt() ?? '0'}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: AppColors.grey400, fontSize: 12.5.sp),
                ),
              )
                  :
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  controller.argument!.type == AppConstant.otHoaDonBanHang ? SizedBox(height: 0,) :
                  Container(
                    width: 90.r,
                    height: 30.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: controller.argument!.type == AppConstant.otHoaDonXuatHang ? AppColors.getStatusBgColorHoaDonXuat(orderSale!.tinhTrang!) : AppColors.getOrderStatusBgColor(trangThaiHoaDon),
                        borderRadius: BorderRadius.all(
                            Radius.circular(4.r)),
                        shape: BoxShape.rectangle),
                    child: Text("$trangThaiHoaDon",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: Colors.white, fontSize: 12.5.sp),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: 110.r,
                    height: 30.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppColors.orItemDetailBg,
                        borderRadius: BorderRadius.all(
                            Radius.circular(4.r)),
                        shape: BoxShape.rectangle),
                    child: Text("Số lượng ${orderSale?.soLuong!.toInt() ?? '0'}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(color: AppColors.grey400, fontSize: 12.5.sp),
                    ),
                  ),
                ],
              )
            ],
          )
        )
    );
  }
}

class _CheckBoxButtonWidget extends StatelessWidget {
  const _CheckBoxButtonWidget({
    Key? key,
    required this.title,
    required this.isChecked,
    this.onPress,
  }) : super(key: key);

  final String title;
  final RxBool isChecked;
  final Function(bool value)? onPress;

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onPress: () {
        isChecked.value = !isChecked.value;
        if (onPress != null) {
          onPress!(isChecked.value);
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstant.kSpaceHorizontalSmallExtra),
        child: Row(
          children: [
            Obx(() {
              return Icon(
                isChecked.value
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                color: AppColors.blue,
              );
            }),
            AppConstant.spaceHorizontalSmallExtra,
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
            )
          ],
        ),
      ),
    );
  }
}