import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/common/app_constant.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/get_list_customer_param.dart';

class CustomerListArgument {
  String? title;
  String? type;
  double? totalAmount;
  CustomerListArgument({this.type, this.title, this.totalAmount = 0.0});
}


class CustomersController extends GetxController
    with StateMixin<List<CustomerModel>> {
  ///
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  var isSelectedCustomer = true.obs;
  var isSelectedSupply = true.obs;

  final textEditController = TextEditingController();

  /// Ds khách hàng
  List<CustomerModel> customers = [];

  /// Repository
  final IReportRepository _repository = Get.find();

  /// tham số truyền lên controller
  CustomerListArgument? argument;

  @override
  void onInit() {
    super.onInit();
    ///lấy tham số từ việc click vào các element
    argument = Get.arguments;
    fetchCustomers();
  }

  ///
  /// Lấy dữ liệu ds khách hàng
  ///
  void fetchCustomers({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      page = 1;
      change(null, status: RxStatus.loading());
      this.customers = [];
      refreshController.resetNoData();
    } else {}

    final param = GetListCustomerParam(
        keyword: textEditController.value.text.trim(),
        page: page,
        isCustomer: isSelectedCustomer.value,
        isSupplier: isSelectedSupply.value,
        type: argument?.type == null ? AppConstant.customerTypeAll : argument?.type
    );
    ///Gọi đến state lấy dữ liệu
    final result = await _repository.getListCustomer(param);

    if (result?.isNotEmpty == true) {
      customers.addAll(result ?? []);
      page++;
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }

    change(customers,
        status: customers.isEmpty ? RxStatus.empty() : RxStatus.success());
  }
}
