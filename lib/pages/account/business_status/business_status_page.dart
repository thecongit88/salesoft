import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/pages/account/business_status/business_status_controller.dart';
import 'package:sale_soft/pages/account/search_customer/customer_page.dart';
import 'package:sale_soft/resources/resources.dart';
import 'package:sale_soft/widgets/description_widget.dart';
import 'package:sale_soft/widgets/empty_data_widget.dart';
import 'package:sale_soft/widgets/filter_branch_widget.dart';
import 'package:sale_soft/widgets/filter_time_widget.dart';
import 'package:sale_soft/widgets/filter_widget.dart';
import 'package:sale_soft/widgets/pie_chart_widget.dart';
import 'package:sale_soft/widgets/total_amount_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sale_soft/enum/period_time.dart';

///
/// Tình hình kinh doanh
///
class BusinessStatusPage extends StatelessWidget {
  const BusinessStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BusinessStatusController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        leading: BackButtonWidget(),
        backgroundColor: AppColors.blue,
        centerTitle: false,
        title: TitleAppBarWidget(
          title: "Tình hình kinh doanh",
        ),
      ),
      body: Column(
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
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final item = data![index];
                    if (item.type == EBusinessStatusDataType.header) {
                      return Column(
                        children: [
                          AppConstant.spaceVerticalSmallMedium,
                          TotalAmountWidget(
                            title: 'Doanh thu toàn chuỗi',
                            totalAmount: controller.totalRevenue.value,
                          ),
                          PieChartWidget(
                            radius: 50.r,
                            dataChart: controller.getPieChartData(context),
                          )
                        ],
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstant
                                .kSpaceHorizontalSmallExtraExtraExtra),
                        child: Column(
                          children: [
                            DescriptionWidget(
                              index: item.revennue?.stt ?? 0,
                              colorIndex: item.color ?? Colors.blue,
                              title: item.revennue?.cuaHang ?? '',
                              subTitle: item.revennue?.subTitle,
                              totalAmount: item.revennue?.soTien ?? 0.0,
                            ),
                            Divider(
                              thickness: 1,
                              height: 10.h,
                            )
                          ],
                        ),
                      );
                    }
                  },
                  itemCount: data?.length ?? 0,
                ),
              );
            },
                onEmpty: EmptyDataWidget(
                  onReloadData: () => controller.fetchData(),
                )),
          )
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
    final BusinessStatusController controller = Get.find();
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
