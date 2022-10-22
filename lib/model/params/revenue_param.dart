import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/model/store.dart';

class RevenueParam {
  DateTime? fromDate;
  DateTime? toDate;
  List<StoreModel>? branchs;

  RevenueParam({
    this.fromDate,
    this.toDate,
    this.branchs,
  });
}

extension RevenueParamExt on RevenueParam {
  ///
  /// Lấy fromDate
  ///
  String getFromDateStr() {
    return DateTimeHelper.dateToStringFormat(
            parten: DateTimeHelper.k_DD_MM_YYYY2, date: fromDate) ??
        '';
  }

  ///
  String getToDateStr() {
    return DateTimeHelper.dateToStringFormat(
            parten: DateTimeHelper.k_DD_MM_YYYY2, date: toDate) ??
        '';
  }
}
