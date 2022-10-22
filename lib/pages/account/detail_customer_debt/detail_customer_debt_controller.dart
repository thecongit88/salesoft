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

class DetailCustomerDebtArgument {
  String? customerCode;
  EPeriodTime? periodReportSelected;
  DetailCustomerDebtArgument({this.customerCode, this.periodReportSelected});
}

class DetailCustomerDebtPageController extends GetxController
    with StateMixin<CustomerWithDebt> {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    argument = Get.arguments;
    customerCode = argument!.customerCode;
    periodReportSelected = argument!.periodReportSelected;
    getData();
  }

  ///
  RefreshController refreshController =
  RefreshController(initialRefresh: false);

  /// Kỳ báo cáo
  final listPeriodReport = EPeriodTime.values;
  List<Debt> listData = [];
  CustomerWithDebt customerWithDebt = CustomerWithDebt();

  /// tham số truyền lên controller để lấy debt detail
  DetailCustomerDebtArgument? argument;
  String? customerCode;
  EPeriodTime? periodReportSelected;

  getData() async { 
    final LoginResponseModel? responseLogin =
        await SharedPreferencesCommon.getLoginResponse();
    final key = responseLogin?.key ?? '';
    final keyLog = responseLogin?.keyLog ?? '';

    List<Debt> response = await HttpUtil()
        .get(
            "${UrlHelper.CUSTOMER_DEBT}/$customerCode/${getDateString(periodReportSelected!.timeValue.fromDate)}/${getDateString(periodReportSelected!.timeValue.toDate)}/$key/$keyLog")
        .then((value) {
      if (value != null) {
        return Future<List<Debt>>.value(Debt.listFromJson(value));
      } else {
        return Future<List<Debt>>.value(Debt.listFromJson(value));
      }
    });

    List<CustomerDetailModel>? customerDetail = await HttpUtil()
        .get(
            "${UrlHelper.REPORT_CUSTOMER_DETAIL}/$customerCode/$key/$keyLog")
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
  }

  String getDateString(DateTime input) {
    return DateTimeHelper.dateToStringFormat(
        parten: DateTimeHelper.k_DD_MM_YYYY2, date: input) ??
        '';
  }
}
