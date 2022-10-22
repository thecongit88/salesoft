import 'Dart:convert';
import 'package:sale_soft/common/date_time_helper.dart';
import 'package:sale_soft/model/inventory_item_model.dart';

class PriceQuoteCart {
  int qty;
  double amount;

  PriceQuoteCart({
    this.qty = 0,
    this.amount = 0
  });
}

class TotalQuote {
  int totalQty;
  double totalAmount;

  TotalQuote({
    this.totalQty = 0,
    this.totalAmount = 0
  });
}