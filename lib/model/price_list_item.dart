import 'dart:convert';

class PriceListItem {
  String code;
  String name;
  double price = 0;
  double quantity = 0;
  double discount = 0;
  String note = '';
  String dvt = '';


  String image = '';
  double priceOrigin = 0;
  double priceMin = 0;
  double amount = 0;

  PriceListItem(this.code, this.name, this.price,
      this.quantity, this.discount, this.note,this.dvt);

  factory PriceListItem.fromJson(Map<String, dynamic> json) {
    return PriceListItem(
      json['Id'] as String,
      json['Name'] as String,
      (json['Price'] as num).toDouble(),
      (json['Quantity'] as num).toDouble(),
      (json['Promo'] as num).toDouble(),
      json['Note'] as String,
      json['DVT'] as String,
    );
  }

  Map<String, dynamic> toJson() =><String, dynamic>{
    'Id': this.code,
    'Name': this.name,
    'Price': this.price,
    'Quantity': this.quantity,
    'Promo': this.discount,
    'Note': this.note,
    'DVT': this.dvt,
  };

  factory PriceListItem.fromJsonString(String json) => PriceListItem.fromJson(jsonDecode(json));

  String toJsonString() => jsonEncode(toJson());
}
