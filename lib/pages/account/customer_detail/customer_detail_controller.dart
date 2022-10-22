import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/model/customer_detail_model.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/invoice_model.dart';
import 'package:sale_soft/model/topsale_model.dart';

class CustomerDetailController extends GetxController with StateMixin<String> {
  ///
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  var customers = <CustomerDetailModel>[].obs;
  var invoices = <InvoiceModel>[].obs;
  var topSales = <TopsaleModel>[].obs;

  final CustomerModel argument = Get.arguments;

  /// Repository
  final IReportRepository _repository = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  ///
  /// Lấy dữ liệu
  ///
  void fetchData({bool isRefreshData = true}) async {
    if (isRefreshData) {
      change(null, status: RxStatus.loading());
      customers.value =
          await _repository.getDetailCustomer(argument.code ?? "") ?? [];
      invoices.value =
          await _repository.getCustomerInvoice(argument.code ?? "") ?? [];
      topSales.value =
          await _repository.getTopSale(argument.code ?? "", 1) ?? [];
      change(" ", status: RxStatus.success());
      refreshController.refreshCompleted();
    }
  }
}
