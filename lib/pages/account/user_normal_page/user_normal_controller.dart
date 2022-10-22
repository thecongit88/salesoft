import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/model/app_info.dart';
import 'package:sale_soft/model/barchart_data_custom.dart';
import 'package:sale_soft/model/company_info.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/staff_revenue_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserNormalController extends GetxController
    with StateMixin<StaffRevenueModel> {
  /// Reload Data
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  var userName = ''.obs;

  LoginResponseModel? loginResponse;
  StaffRevenueModel? staffRevenue;

  /// Repository
  final IReportRepository _repository = Get.find();

  CompanyInfoModel? companyInfo;

  @override
  void onInit() async {
    loginResponse = await SharedPreferencesCommon.getLoginResponse();
    userName.value = loginResponse?.name ?? '';
    fetchData();

    companyInfo = await SharedPreferencesCommon.getCompanyInfo();
    super.onInit();
  }

  ///
  /// Fill dữ liệu từ service
  ///
  void fetchData({bool isRefreshData = false}) async {
    if (!isRefreshData) {
      change(null, status: RxStatus.loading());
    }
    staffRevenue = await _repository.fetchStaffRevenue();

    refreshController.refreshCompleted();
    change(staffRevenue,
        status: staffRevenue != null ? RxStatus.success() : RxStatus.empty());
  }

  ///
  /// Build dữ liệu chartview
  ///
  List<BarchartDataCustom> getDataChart() {
    /// Chia cho 1tr vì đơn vị vẽ biểu đồ là triệu đồng
    final item1 = BarchartDataCustom(
      'Tháng này',
      x: 0,
      barRods: [
        BarChartRodData(
            width: 48.w,
            y: (staffRevenue?.ThangNay ?? 0) / 1000000,
            colors: [AppColors.turquoise],
            borderRadius: const BorderRadius.all(Radius.zero)),
      ],
    );

    final item2 = BarchartDataCustom(
      'Tháng trước',
      x: 1,
      barRods: [
        BarChartRodData(
            width: 48.w,
            y: (staffRevenue?.ThangTruoc ?? 0) / 1000000,
            colors: [AppColors.yellow],
            borderRadius: const BorderRadius.all(Radius.zero)),
      ],
    );

    return [item1, item2];
  }
}
