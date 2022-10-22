import 'dart:convert';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/enum/period_time.dart';
import 'package:sale_soft/model/castflow_model.dart';
import 'package:sale_soft/model/params/revenue_param.dart';
import 'package:sale_soft/model/store.dart';

class AdminChiTietThuChiArgument {
  Rx<EPeriodTime>? periodReportSelected;
  RxList<StoreModel>? storesSelected;
  AdminChiTietThuChiArgument({this.periodReportSelected, this.storesSelected});
}

class AdminChiTietThuChiController extends GetxController
    with StateMixin<List<CashFlowModel>> {

  RefreshController refreshController =
  RefreshController(initialRefresh: false);

  AdminChiTietThuChiArgument? argument;

  final IReportRepository _repository = Get.find();
  List<CashFlowModel> cashFlowData = [];

  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments;
    fetchCashflow();
;  }

  void fetchCashflow({bool isRefreshData = false}) async {
    if (isRefreshData == false) {
      change(null, status: RxStatus.loading());
    }

    final fromDate = argument!.periodReportSelected!.value.timeValue.fromDate;
    final toDate = argument!.periodReportSelected!.value.timeValue.toDate;
    final List<CashFlowModel>? response = await _repository.fetchCashflow(
        RevenueParam(
            fromDate: fromDate, toDate: toDate, branchs: argument!.storesSelected!.value));

    if (response?.isNotEmpty == true) {
      cashFlowData.addAll(response ?? []);
    } else {
      cashFlowData = [];
    }

    change(cashFlowData, status: RxStatus.success());
    refreshController.refreshCompleted();
  }
}
