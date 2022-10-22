import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/model/customer_debt_model.dart';
import 'package:sale_soft/model/customer_detail_model.dart';
import 'package:sale_soft/model/customer_with_debt.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/debt.dart';
import 'package:sale_soft/pages/account/customer_list/customer_list_controller.dart';
import 'package:sale_soft/pages/account/detail_customer_debt/detail_customer_debt_controller.dart';
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

class SearchCustomerDebtPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SearchCustomerDebtPageController controller = Get.find();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButtonWidget(),
          backgroundColor: AppColors.blue,
          centerTitle: false,
          title: TitleAppBarWidget(
            title: "Công nợ",
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
                  hintText: "Nhập mã khách hàng",
                  textEditingController: controller.customerTextfieldController,
                  onChange: (keyword) async {
                    controller.getListDebtCustomer();
                  }),
              AppConstant.spaceVerticalSmallMedium,
              Expanded(
                child:controller.obx((customerWithDebt) {
                    List<CustomerDebtModel>? customers = customerWithDebt!.customersDebt;
                    return SmartRefresher(
                    controller: controller.refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () => controller.getListDebtCustomer(),
                    onLoading: () => controller.getListDebtCustomer(isLoadMore: true),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _CustomerWidget(
                            customer: customers[index],
                            backgroundColor:
                            index % 2 == 0 ? AppColors.grey50.withOpacity(0.1) : null,
                            onPress: () {
                              //Get.back(result: customers[index]);
                              ///Liệt kê các công nợ của 1 khách hàng
                              //controller.getData(customer: customers[index]);
                              Get.toNamed(
                                  ERouter.customerDebtDetailPage.name,
                                  arguments: DetailCustomerDebtArgument(
                                    customerCode: customers[index].code,
                                    periodReportSelected: controller.periodReportSelected.value
                                  )
                              );
                            },
                          );
                        },
                        itemCount: customers.length),
                  );
                  },
                  onEmpty: EmptyDataWidget(
                    onReloadData: () => controller.getListDebtCustomer(),
                  )
                ),
              ),

              /*
              controller.obx((customerWithDebt) {
                return buildData(customerWithDebt!);
              }, onEmpty: EmptyDataWidget(
                onReloadData: () {
                  controller.getData();
                },
              )),
              SizedBox(height: 16)
              */
            ],
          ),
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
    final SearchCustomerDebtPageController controller = Get.find();
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
    this.customer,
    this.backgroundColor,
  }) : super(key: key);

  final Function()? onPress;
  final CustomerDebtModel? customer;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
        onPress: onPress,
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(const Radius.circular(3.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("#${customer?.code ?? '-'}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: AppColors.orHeadTitle, fontSize: 15.sp),
                ),

                AppConstant.spaceVerticalSmallExtra,

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: AppColors.grey, size: 15.sp,),
                    SizedBox(width: 3,),
                    Expanded(
                      child: Text("${customer?.Ten ?? '-'}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: AppColors.grey, fontSize: 12.5.sp),
                      ),
                    )
                  ],
                ),

              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120.r,
                  height: 22.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.getDebtColor(customer?.NoDauKy ?? 0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(4.r)),
                      shape: BoxShape.rectangle),
                  child: Text("${(customer?.NoDauKy ?? 0).toAmountFormat()} đ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(color: Colors.white, fontSize: 12.5.sp),
                  ),
                ),
                AppConstant.spaceVerticalSmallExtra,
                Text("${(customer?.NoCuoiKy ?? 0).toAmountFormat()} đ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: AppColors.orPrice, fontSize: 12.5.sp),
                ),
              ],
            ),
          ),
        )
    );
  }
}