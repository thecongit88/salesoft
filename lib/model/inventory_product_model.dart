import 'dart:convert';

class InventoryProductModel {
  int? stt;
  int? detailID;
  String? ma;
  String? ten;
  double quantity = 0;
  String? unit;
  bool checked = false;
  bool isSelected = false;

  InventoryProductModel({
    this.stt,
    this.detailID,
    this.ma,
    this.ten,
    this.quantity = 0,
    this.unit,
    this.checked = false,
    this.isSelected = false
  });

  Map<String, dynamic> toMap() {
    return {
      "STT": stt,
      "DetailID": detailID,
      "Code": ma,
      "Name": ten,
      "Quantity": quantity,
      "DVT": unit,
      "Checked": checked
    };
  }

  factory InventoryProductModel.fromMap(Map<String, dynamic> map) {
    return InventoryProductModel(
      stt: map['STT'],
      detailID: map['DetailID'],
      ma: map['Code'],
      ten: map['Name'],
      quantity: map['Quantity'],
      unit: map['DVT'],
      checked: map['Checked']
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryProductModel.fromJson(String source) =>
      InventoryProductModel.fromMap(json.decode(source));
}
