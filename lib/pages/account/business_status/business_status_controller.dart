import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:sale_soft/enum/period_time.dart';
import 'package:sale_soft/model/params/revenue_param.dart';
import 'package:sale_soft/model/revenue_model.dart';
import 'package:sale_soft/pages/account/filter_mixin.dart';

class BusinessStatusController extends GetxController
    with StateMixin<List<BusinessStatusData>>, FilterMixin {
  ///
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  List<BusinessStatusData> dataDisplay = [];
  var totalRevenue = 0.0.obs;

  // /// Kỳ báo cáo
  // final listPeriodReport = EPeriodTime.values;
  // var periodReportSelected = EPeriodTime.thisMonth.obs;

  // List<StoreModel> stores = [];
  // // Store đang chọn
  // var storesSelected = <StoreModel>[].obs;

  /// Repository
  final IReportRepository _repository = Get.find();

  @override
  void onInit() async {
    super.onInit();
    stores = await SharedPreferencesCommon.getStores() ?? [];

    fetchData();
  }

  ///
  /// Xử lý khi thay đổi thời gian báo cáo
  ///
  void handleChangePeriodReport(EPeriodTime value) {
    periodReportSelected.value = value;
    fetchData();
  }

  ///
  /// Lấy dữ liệu
  ///
  void fetchData({bool isRefreshData = false}) async {
    if (isRefreshData == false) {
      change(null, status: RxStatus.loading());
    }
    dataDisplay = [];

    final fromDate = periodReportSelected.value.timeValue.fromDate;
    final toDate = periodReportSelected.value.timeValue.toDate;
    final List<RevenueModel>? response = await _repository.revenue(RevenueParam(
        fromDate: fromDate, toDate: toDate, branchs: storesSelected.value));

    if (response?.isEmpty == true) {
      totalRevenue.value = 0;
      change(dataDisplay, status: RxStatus.empty());
    } else {
      _buildData(response ?? []);
      change(dataDisplay, status: RxStatus.success());
    }

    refreshController.refreshCompleted();
  }

  ///
  /// Build dữ liệu
  ///
  void _buildData(List<RevenueModel> data) {
    dataDisplay.add(BusinessStatusData(type: EBusinessStatusDataType.header));

    if (data.isEmpty) {
      return;
    }

    totalRevenue.value =
        data.fold(0.0, (value, element) => value + (element.soTien ?? 0));
    double totalPercent = 0;
    for (int i = 0; i < data.length - 1; i++) {
      final amount = (data[i].soTien ?? 0) / totalRevenue.value;
      final currentPercent = (amount * 100).convertWithPrecision(2);
      totalPercent += currentPercent;
      data[i].subTitle = '${currentPercent.toStringAsFixed(2)}%';
      data[i].percent = currentPercent;
      dataDisplay.add(BusinessStatusData(
          type: EBusinessStatusDataType.store,
          revennue: data[i],
          color: data[i].getColorForchart()));
    }

    final lastPercentItem = 100 - totalPercent;
    data.last.subTitle = "${lastPercentItem.toStringAsFixed(2)}%";
    data.last.percent = lastPercentItem;
    dataDisplay.add(BusinessStatusData(
        type: EBusinessStatusDataType.store,
        revennue: data.last,
        color: data.last.getColorForchart()));
  }

  ///
  /// Build Data Chart
  ///
  List<PieChartSectionData> getPieChartData(BuildContext context) {
    final result = <PieChartSectionData>[];
    final radius = 50.0.r;

    for (var item in dataDisplay) {
      if (item.type != EBusinessStatusDataType.header) {
        final itemData = PieChartSectionData(
          color: item.color,
          value: item.revennue?.soTien ?? 0.0,
          title: (item.revennue?.percent ?? 0.0) > 10.0
              ? item.revennue?.subTitle
              : '',
          radius: radius,
          titleStyle: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Colors.white),
        );
        result.add(itemData);
      }
    }
    return result;
  }
}

class BusinessStatusData {
  EBusinessStatusDataType type;
  RevenueModel? revennue;
  Color? color;

  BusinessStatusData({
    required this.type,
    this.revennue,
    this.color,
  });
}

enum EBusinessStatusDataType { header, store }
