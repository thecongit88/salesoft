import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sale_soft/api/api_config/http_util.dart';
import 'package:sale_soft/api/repository/report_repository.dart';
import 'package:sale_soft/api/url_helper.dart';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/common/shared_preferences.dart';
import 'package:sale_soft/enum/period_time.dart';
import 'package:sale_soft/model/base_model.dart';
import 'package:sale_soft/model/customer_debt_model.dart';
import 'package:sale_soft/model/customer_detail_model.dart';
import 'package:sale_soft/model/customer_with_debt.dart';
import 'package:sale_soft/model/debt.dart';
import 'package:sale_soft/model/customer_model.dart';
import 'package:sale_soft/model/get_list_customer_param.dart';
import 'package:sale_soft/model/login_response_model.dart';

class SearchCustomerDebtPageController extends GetxController
    with StateMixin<CustomerWithDebt> {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    change(
        customerWithDebt
          ..listCustomerDetail = []
          ..listDebt = [],
        status: RxStatus.success());
    getListDebtCustomer();
    //print("Date init data");
    //print("${getDateString(periodReportSelected.value.timeValue.fromDate)}/${getDateString(periodReportSelected.value.timeValue.toDate)}");
  }

  ///
  RefreshController refreshController =
  RefreshController(initialRefresh: false);
  int page = 1;

  /// Ds khách hàng
  List<CustomerDebtModel> customersDebt = [];

  /// Repository
  final IReportRepository _repository = Get.find();

  /// Kỳ báo cáo
  final listPeriodReport = EPeriodTime.values;
  var periodReportSelected = EPeriodTime.thisMonth.obs;

  var customerTextfieldController = TextEditingController();

  CustomerModel customer = CustomerModel();
  List<Debt> listData = [];
  CustomerWithDebt customerWithDebt = CustomerWithDebt();

  void getDataByTimePeriod(EPeriodTime value) {
    periodReportSelected.value = value;
    //getData();
    getListDebtCustomer();
  }

  ///Hàm này đã chuyển sang controller chi tiết công nợ khách hàng
  /*getData() async {
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final keyLog = responseLogin?.keyLog ?? '';

    List<Debt> response = await HttpUtil()
        .get(
            "${UrlHelper.CUSTOMER_DEBT}/${customer.code}/${getDateString(periodReportSelected.value.timeValue.fromDate)}/${getDateString(periodReportSelected.value.timeValue.toDate)}/$key/$keyLog")
        .then((value) {
      if (value != null) {
        return Future<List<Debt>>.value(Debt.listFromJson(value));
      } else {
        return Future<List<Debt>>.value(Debt.listFromJson(value));
      }
    });

    List<CustomerDetailModel>? customerDetail = await HttpUtil()
        .get(
            "${UrlHelper.REPORT_CUSTOMER_DETAIL}/${customer.code}/$key/$keyLog")
        .then<List<CustomerDetailModel>?>((value) {
      if (value != null) {
        return Future<List<CustomerDetailModel>>.value(
            BaseModel.listFromJson<CustomerDetailModel>(
                value, (dataMap) => CustomerDetailModel.fromMap(dataMap)));
      } else {
        return Future.value(null);
      }
    });

    if (response.isNotEmpty) {
      listData.clear();
      listData.addAll(response);
      change(
          customerWithDebt
            ..listCustomerDetail = customerDetail
            ..listDebt = listData,
          status: RxStatus.success());
    } else {
      change(
          customerWithDebt
            ..listCustomerDetail = customerDetail
            ..listDebt = [],
          status: RxStatus.success());
    }
  }*/

  void getListDebtCustomer({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      page = 1;
      change(null, status: RxStatus.loading());
      this.customersDebt = [];
      refreshController.resetNoData();
    } else {}

    final param = GetListCustomerParam(
        keyword: customerTextfieldController.text.trim(),
        page: page,
        fromDate: "${getDateString(periodReportSelected.value.timeValue.fromDate)}",
        toDate: "${getDateString(periodReportSelected.value.timeValue.toDate)}"
    );
    final result = await _repository.getListDebtCustomer(param);

    if (result?.isNotEmpty == true) {
      customersDebt.addAll(result ?? []);
      page++;
      refreshController.loadComplete();
    } else {
      refreshController.loadNoData();
    }

    change(
        customerWithDebt
          ..listCustomerDetail = []
          ..listDebt = []
          ..customersDebt = customersDebt,
        status: customersDebt.isEmpty ? RxStatus.empty() : RxStatus.success());
  }
}

String getDateString(DateTime input) {
  return DateTimeHelper.dateToStringFormat(
          parten: DateTimeHelper.k_DD_MM_YYYY2, date: input) ??
      '';
}
