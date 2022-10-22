import 'dart:convert';

class OrderDetailModel {
  int? STT;
  int? ID;
  String? Name;
  double? Price;
  double? Quantity;
  double? Promotion;
  double? Total;

  OrderDetailModel(
      {this.STT,
      this.Name,
      this.ID,
      this.Price,
      this.Quantity,
      this.Promotion,
      this.Total});

  Map<String, dynamic> toMap() {
    return {
      'STT': STT,
      'ID': ID,
      'Name': Name,
      'Price': Price,
      'Quantity': Quantity,
      'Promotion': Promotion,
      'Total': Total
    };
  }

  factory OrderDetailModel.fromMap(Map<String, dynamic> map) {
    return OrderDetailModel(
      STT: map['STT'],
      ID: map['ID'],
      Name: map['Name'],
      Price: map['Price'],
      Quantity: map['Quantity'],
      Promotion: map['Promotion'],
      Total: map['Total'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetailModel.fromJson(String source) =>
      OrderDetailModel.fromMap(json.decode(source));

  static List<OrderDetailModel> listFromJson(list) {
    return List<OrderDetailModel>.from(
        list.map((x) => OrderDetailModel.fromMap(x)));
  }
}
