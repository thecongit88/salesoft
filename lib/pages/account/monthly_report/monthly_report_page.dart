import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/router.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/enum/period_time.dart';
import 'package:sale_soft/pages/account/admin_chi_tiet_thu_chi/admin_chi_tiet_thu_chi_list_controller.dart';
import 'package:sale_soft/pages/account/monthly_report/monthly_report_controller.dart';
import 'package:sale_soft/pages/account/search_customer/customer_page.dart';
import 'package:sale_soft/pages/account/widgets/barchart_widget.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/description_widget.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/filter_branch_widget.dart';
import 'package:sale_soft/widgets/filter_time_widget.dart';
import 'package:sale_soft/widgets/filter_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/widgets/inkwell_widget.dart';
import 'package:sale_soft/widgets/total_amount_widget.dart';

///
/// Báo cáo thu chi
///
class MonthlyReportPage extends StatelessWidget {
  const MonthlyReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MonthlyReportController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        leading: BackButtonWidget(),
        backgroundColor: AppColors.blue,
        centerTitle: false,
        title: TitleAppBarWidget(
          title: "Quản lý quỹ",
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              _HeaderWidget(),
              Expanded(
                child: controller.obx((data) {
                  return SmartRefresher(
                    controller: controller.refreshController,
                    enablePullDown: true,
                    onRefresh: () {
                      controller.fetchData(isRefreshData: true);
                    },
                    child: Column(
                      children: [
                        AppConstant.spaceVerticalSmallMedium,
                        _RevenueWidget(),
                        BarChartWidget(
                          listData: controller.getDataChart(),
                        ),
                        AppConstant.spaceVerticalSmallMedium,
                        _DescriptionWidget(),
                        AppConstant.spaceVerticalSafeArea,
                      ],
                    ),
                  );
                }, onEmpty: EmptyDataWidget()),
              )
            ],
          ),
          wdgButtonCashFlowDetail()
        ],
      )
    );
  }

  Widget wdgButtonCashFlowDetail() {
    return Container(
      width: 230,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      height: 55,
      child: InkWell(
        onTap: () {
          /*final MonthlyReportController controller = Get.find();
          final fromDate = controller.periodReportSelected.value.timeValue.fromDate;
          final toDate = controller.periodReportSelected.value.timeValue.toDate;
          final chuoiCuaHang = controller.storesSelected.value;
          print("get data month");
          print("$fromDate - $toDate - ${json.encode(chuoiCuaHang)}");*/

          final MonthlyReportController controller = Get.find();
          Get.toNamed(ERouter.adChiTietThuChiPage.name,
              arguments: AdminChiTietThuChiArgument(
                periodReportSelected: controller.periodReportSelected,
                storesSelected: controller.storesSelected
              )
          );
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppColors.grey300,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                color: AppColors.blue
            ),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Xem chi tiết quỹ',
                  style: TextStyle(fontSize:  15.sp, color: Colors.white),
                ),
                SizedBox(width: 5.sp),
                Icon(Icons.double_arrow, color: Colors.white, size:  18.sp),
              ],
            )
        ),
      ),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MonthlyReportController controller = Get.find();
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra),
      child: Column(
        children: [
          DescriptionWidget(
            index: 1,
            colorIndex: AppColors.orange,
            title: 'Tiền thu',
            totalAmount: controller.cashBookData?.doanhThu ?? 0.0,
          ),
          Divider(
            thickness: 0.25,
            color: AppColors.grey50,
          ),
          DescriptionWidget(
            index: 2,
            colorIndex: AppColors.blue,
            title: 'Tiền chi',
            totalAmount: controller.cashBookData?.chiPhi ?? 0.0,
          ),
          Divider(
            thickness: 0.25,
            color: AppColors.grey50,
          ),
          DescriptionWidget(
            index: 3,
            colorIndex: AppColors.turquoise,
            title: 'Chênh lệch',
            totalAmount: controller.cashBookData?.chenhLech ?? 0.0,
          ),
        ],
      ),
    );
  }
}

class _RevenueWidget extends StatelessWidget {
  const _RevenueWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MonthlyReportController controller = Get.find();
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtra),
      child: Row(
        children: [
          Expanded(
            child: TotalAmountWidget(
              title: 'Tiền đầu kỳ',
              totalAmount: controller.cashBookData?.dauky ?? 0.0,
            ),
          ),
          Container(
            width: 2.w,
            height: 40.h,
            color: AppColors.grey50,
          ),
          Expanded(
            child: TotalAmountWidget(
              title: 'Tiền cuối kỳ',
              totalAmount: controller.cashBookData?.cuoiKy ?? 0.0,
            ),
          ),
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
    final MonthlyReportController controller = Get.find();
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstant.kSpaceHorizontalSmallExtraExtraExtra,
          vertical: AppConstant.kSpaceVerticalSmallExtraExtra),
      color: AppColors.blue,
      child: Row(
        children: [
          Obx(() {
            return FilterWidget(
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
                        controller.handleChangePeriodReport(value);
                      },
                    ));
              },
            );
          }),
          AppConstant.spaceHorizontalMediumExtra,
          Obx(() {
            return FilterWidget(
              title: 'Chuỗi cửa hàng',
              value: controller.getStoresTitle(),
              imageAssetName: AppResource.icStore,
              onPress: () {
                showViewDialog(
                    context,
                    FilterBranchWidget(
                      searchListStore: (String keyword) {
                        return controller.searchStoreByKey(keyword);
                      },
                      onDone: () {
                        Get.back();
                        controller.filterStoresAction();
                        controller.fetchData();
                      },
                    ));
              },
            );
          })
        ],
      ),
    );
  }
}
