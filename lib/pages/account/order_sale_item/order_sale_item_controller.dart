import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/enum/period_time.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/get_list_customer_param.dart';
import 'package:sale_soft/model/order_model.dart';
import 'package:sale_soft/pages/account/searchCustomerDebt/search_customer_debt_controller.dart';

class OrderListArgument {
  String? title;
  String? type;
  OrderListArgument({this.type, this.title});
}

class OrderSaleItemController extends GetxController
    with StateMixin<List<OrderModel>> {
  TextEditingController edittextController = TextEditingController();

  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  int page = 1;
  List<OrderModel> orderSales = [];

  final IReportRepository _repository = Get.find();

  /// Kỳ báo cáo
  final listPeriodReport = EPeriodTime.values;
  var periodReportSelected = EPeriodTime.thisMonth.obs;

  /// tham số truyền lên controller
  OrderListArgument? argument;

  var isSelectedNoQuaHan = true.obs;

  @override
  void onInit() {
    super.onInit();
    ///lấy tham số từ việc click vào các element
    argument = Get.arguments;
    getListOrderSales();
  }

  void getDataByTimePeriod(EPeriodTime value) {
    periodReportSelected.value = value;
    getListOrderSales();
  }

  void getListOrderSales({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      page = 1;
      change(null, status: RxStatus.loading());
      this.orderSales = [];
      refreshController.resetNoData();
    } else {}

    final param = GetListCustomerParam(
        keyword: edittextController.text.trim(),
        page: page,
        fromDate: "${getDateString(periodReportSelected.value.timeValue.fromDate)}",
        toDate: "${getDateString(periodReportSelected.value.timeValue.toDate)}",
        type: isSelectedNoQuaHan.value == true && argument!.type != AppConstant.otHoaDonBanHang ? "3" : argument!.type
    );
    final result = await _repository.getListOrders(param);

    if (result?.isNotEmpty == true) {
      orderSales.addAll(result ?? []);
      page++;
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }

    change(orderSales,
        status: orderSales.isEmpty ? RxStatus.empty() : RxStatus.success());
  }
}
