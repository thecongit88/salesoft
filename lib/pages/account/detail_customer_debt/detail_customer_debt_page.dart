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

class DetailCustomerDebtPage extends StatelessWidget {
  const DetailCustomerDebtPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DetailCustomerDebtPageController controller = Get.find();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: BackButtonWidget(),
          backgroundColor: AppColors.blue,
          centerTitle: false,
          title: TitleAppBarWidget(
            title: "Chi tiết công nợ khách hàng",
          ),
        ),
        body: controller.obx((customerWithDebt) {
          return buildData(customerWithDebt!);
        }, onEmpty: EmptyDataWidget(
          onReloadData: () {
            controller.getData();
          },
        ))
    );
  }
}

Widget buildData(CustomerWithDebt customerWithDebt) {
  var listCustomerDetail = customerWithDebt.listCustomerDetail;
  var listDebt = customerWithDebt.listDebt;
  final DetailCustomerDebtPageController controller = Get.find();

  return SingleChildScrollView(
    child: Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          buildCustomerDetail(listCustomerDetail!),
          SizedBox(
            height: 16,
          ),
          _summaryTitle(Icons.timer, "Từ ${controller.getDateString(controller.periodReportSelected!.timeValue.fromDate)} đến ${controller.getDateString(controller.periodReportSelected!.timeValue.toDate)}"),
          buildDebtTable(listDebt),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    ),
  );
}

Widget buildDebtTable(List<Debt> listDebt) {
  if (listDebt.isEmpty) {
    return Center(
      child: Text("Không có giao dịch nào trong khoảng thời gian này."),
    );
  } else {
    return buildListDebt(listDebt);
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
  return originalLength == 0 ?
      Center(
        child: Text("Không có chi tiết."),
      )
      : ListView.builder(
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
          return Container(
            color: index % 2 == 0 ? AppColors.grey50.withOpacity(0.3) : null,
            child: Row(
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
            )
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _summaryTitle(Icons.supervisor_account, "${detail.name}"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Mã giao dịch",
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.black)),
            Spacer(),
            wdgCopyText(
              Text("${detail.code}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.grey, height: 1.3)),
              detail.code ?? '',
            ),
          ],
        ),
        AppConstant.spaceVerticalSmallExtra,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Mã số thuế",
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.black)),
            Spacer(),
            wdgCopyText(
              Text("${getNullOrEmptyValue(detail.taxCode)}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.grey, height: 1.3)),
              detail.taxCode ?? '',
            ),
          ],
        ),
        AppConstant.spaceVerticalSmallExtra,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Nhân viên chăm sóc",
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.black)),
            Spacer(),
            Text("${detail.staff}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: AppColors.grey, height: 1.3)),
          ],
        ),
        AppConstant.spaceVerticalSmallExtra,
        getNullOrEmptyValue(detail.address) != "-" ?
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Địa chỉ: ",
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.black)),
            AppConstant.spaceVerticalSmallExtra,
            Text("${getNullOrEmptyValue(detail.address)}",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.grey, height: 1.4), maxLines: 5,),
          ],
        ) :
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Địa chỉ",
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.black)),
            Spacer(),
            Text("${getNullOrEmptyValue(detail.address)}",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.grey, height: 1.4), maxLines: 5,),
          ],
        )
      ],
    );
  }
}

Widget _summaryTitle(IconData ic, title) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ic, size: 15, color: AppColors.grey,),

          SizedBox(width: 4,),
          Expanded(
            child: Text(title,
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 15),
              maxLines: 2,
          )
        )
        ],
      ),
      Divider(
        thickness: 1.2,
        color: AppColors.blue,
      ),
      AppConstant.spaceVerticalSmallExtra,
    ],
  );
}