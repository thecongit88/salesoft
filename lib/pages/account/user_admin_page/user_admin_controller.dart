import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/common/utils.dart';
import 'package:get/get.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/model/login_response_model.dart';
import 'package:sale_soft/model/params/revenue_param.dart';
import 'package:sale_soft/model/revenue_model.dart';

class UserAdminController extends GetxController
    with StateMixin<List<UserAdminItemDisplay>> {
  LoginResponseModel? loginResponse;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  /// Ds item hiển thị
  List<UserAdminItemDisplay> listData = [];

  /// Repository
  final IReportRepository _repository = Get.find();
  var userName = ''.obs;

  @override
  void onInit() async {
    loginResponse = await SharedPreferencesCommon.getLoginResponse();
    userName.value = loginResponse?.name ?? '';
    super.onInit();
    fetchData();
  }

  ///
  /// Lấy dữ liệu doanh thu
  ///
  void fetchData({bool isRefreshData = false}) async {
    listData = [];
    if (isRefreshData == false) {
      change(null, status: RxStatus.loading());
    }
    final toDate = DateTime.now();
    final fromDate = DateTime(toDate.year, toDate.month, 1);
    final List<RevenueModel>? response = await _repository
        .revenue(RevenueParam(fromDate: fromDate, toDate: toDate));

    listData.add(UserAdminItemDisplay(type: EUserAdminItemType.header));
    listData.add(UserAdminItemDisplay(
        type: EUserAdminItemType.title, title: "Tình hình kinh doanh"));

    if (response != null) {
      _buildData(response);
    }
    refreshController.refreshCompleted();
    change(listData, status: RxStatus.success());
  }

  ///
  /// Build dữ liệu
  ///
  void _buildData(List<RevenueModel> data) {
    if (data.isEmpty) {
      return;
    }

    final double totalAmount =
        data.fold(0.0, (value, element) => value + (element.soTien ?? 0));
    double totalPercent = 0;
    for (int i = 0; i < data.length - 1; i++) {
      final amount = (data[i].soTien ?? 0) / totalAmount;
      final currentPercent = (amount * 100).convertWithPrecision(2);
      totalPercent += currentPercent;
      data[i].subTitle = '${currentPercent.toStringAsFixed(2)}%';
      listData.add(UserAdminItemDisplay(
          type: EUserAdminItemType.store,
          title: data[i].cuaHang,
          revenueStore: data[i]));
    }

    final lastPercentItem = 100 - totalPercent;
    data.last.subTitle = "${lastPercentItem.toStringAsFixed(2)}%";
    listData.add(UserAdminItemDisplay(
        type: EUserAdminItemType.store,
        title: data.last.cuaHang,
        revenueStore: data.last));
  }
}

class UserAdminItemDisplay {
  EUserAdminItemType type;
  String? title;
  RevenueModel? revenueStore;

  UserAdminItemDisplay({
    required this.type,
    this.title,
    this.revenueStore,
  });
}

enum EUserAdminItemType { header, title, store }
