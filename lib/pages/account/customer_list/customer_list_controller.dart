import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/get_list_customer_param.dart';

class CustomerListController extends GetxController
    with StateMixin<List<CustomerModel>> {
  TextEditingController edittextController = TextEditingController();

  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 1;
  List<CustomerModel> customers = [];

  final IReportRepository _repository = Get.find();

  @override
  void onInit() {
    super.onInit();
    //edittextController.text = Get.arguments;
    getListAllCustomer();
  }

  void getListAllCustomer({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      page = 1;
      change(null, status: RxStatus.loading());
      this.customers = [];
      refreshController.resetNoData();
    } else {}

    final param = GetListCustomerParam(
        keyword: edittextController.text.trim(),
        page: page,
        isCustomer: true,
        isSupplier: false);
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
