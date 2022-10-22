import 'package:intl/intl.dart';

extension doubleExt on double {
  String toAmountFormat() {
    var numberFormat = NumberFormat("###,###,###,###", "en_US");
    return numberFormat.format(this);
  }
}

extension intExt on int {
  String toAmountFormat() {
    var numberFormat = NumberFormat("###,###,###,###", "en_US");
    return numberFormat.format(this);
  }
}
