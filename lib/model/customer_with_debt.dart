import 'package:sale_soft/model/customer_debt_model.dart';
import 'package:sale_soft/model/customer_detail_model.dart';
import 'package:sale_soft/model/customer_model.dart';

import 'debt.dart';

class CustomerWithDebt {
  List<CustomerDetailModel>? listCustomerDetail = null;
  List<Debt> listDebt = [];
  List<CustomerDebtModel> customersDebt = [];
}
