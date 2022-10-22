import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/enum/period_time.dart';
import 'package:sale_soft/model/barchart_data_custom.dart';
import 'package:sale_soft/model/cashbook_model.dart';
import 'package:sale_soft/model/params/revenue_param.dart';
import 'package:sale_soft/model/store.dart';
import 'package:sale_soft/pages/account/filter_mixin.dart';

class MonthlyReportController extends GetxController
    with StateMixin<CashBookModel>, FilterMixin {
  ///
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  CashBookModel? cashBookData;

  /// Kỳ báo cáo
  final listPeriodReport = EPeriodTime.values;
  var periodReportSelected = EPeriodTime.thisMonth.obs;

  List<StoreModel> stores = [];
  // Store đang chọn
  var storesSelected = <StoreModel>[].obs;

  /// Repository
  final IReportRepository _repository = Get.find();

  @override
  void onInit() async {
    super.onInit();
    stores = await SharedPreferencesCommon.getStores() ?? [];
    fetchData();
  }

  ///
  /// Get dữ liệu từ service
  ///
  void fetchData({bool isRefreshData = false}) async {
    if (isRefreshData == false) {
      change(null, status: RxStatus.loading());
    }

    final fromDate = periodReportSelected.value.timeValue.fromDate;
    final toDate = periodReportSelected.value.timeValue.toDate;
    final List<CashBookModel>? response = await _repository.fetchCashbook(
        RevenueParam(
            fromDate: fromDate, toDate: toDate, branchs: storesSelected.value));
    if (response?.isNotEmpty == true) {
      cashBookData = response?.first;
    } else {
      cashBookData = null;
    }

    change(cashBookData,
        status: cashBookData == null ? RxStatus.empty() : RxStatus.success());
    refreshController.refreshCompleted();
  }

  ///
  /// Build dữ liệu chartview
  ///
  List<BarchartDataCustom> getDataChart() {
    final item1 = BarchartDataCustom(
      'Tiền thu',
      x: 0,
      barRods: [
        BarChartRodData(
            width: 54,
            y: (cashBookData?.doanhThu ?? 0) / 1000000,
            colors: [AppColors.orange],
            borderRadius: const BorderRadius.all(Radius.zero)),
      ],
    );

    final item2 = BarchartDataCustom(
      'Tiền chi',
      x: 1,
      barRods: [
        BarChartRodData(
            width: 54,
            y: (cashBookData?.chiPhi ?? 0) / 1000000,
            colors: [AppColors.blue],
            borderRadius: const BorderRadius.all(Radius.zero)),
      ],
    );

    final item3 = BarchartDataCustom(
      'Chênh lệch',
      x: 2,
      barRods: [
        BarChartRodData(
            width: 54,
            y: (cashBookData?.chenhLech ?? 0) / 1000000,
            colors: [AppColors.turquoise],
            borderRadius: const BorderRadius.all(Radius.zero)),
      ],
    );

    return [item1, item2, item3];
  }

  ///
  /// Xử lý khi thay đổi thời gian báo cáo
  ///
  void handleChangePeriodReport(EPeriodTime value) {
    periodReportSelected.value = value;
    fetchData();
  }
}
