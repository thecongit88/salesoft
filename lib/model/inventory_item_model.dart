import 'dart:convert';

class InventroyItemModel {
  int? stt;
  String? code;
  String? name;
  String? origin;
  String? tradeMark;
  double? Price; // giá lẻ
  double? Price0; // gía sỉ
  double? Price1;
  double? Price2;
  double? Price3;
  double? Price4;

  double? quantity;
  String? unit;

  bool isSelected = false;
  double promotion = 0.0;
  int soluongBaoGia = 0;
  double donGiaBaoGia = 0;
  int orderInCart = 0;
  String? ghiChu;

  InventroyItemModel({
    this.stt,
    this.code,
    this.name,
    this.origin,
    this.tradeMark,
    this.Price,
    this.Price0,
    this.Price1,
    this.Price2,
    this.Price3,
    this.Price4,
    this.quantity,
    this.unit,
    this.isSelected = false,
    this.promotion = 0,
    this.soluongBaoGia = 0,
    this.donGiaBaoGia = 0,
    this.orderInCart = 0,
    this.ghiChu
  });

  Map<String, dynamic> toMap() {
    return {
      'STT': stt,
      'Code': code,
      'Name': name,
      'Origin': origin,
      'TradeMark': tradeMark,
      'Price': Price,
      'Price0': Price0,
      'Price1': Price1,
      'Price2': Price2,
      'Price3': Price3,
      'Price4': Price4,
      'Quantity': quantity,
      'Unit': unit,
    };
  }

  factory InventroyItemModel.fromMap(Map<String, dynamic> map) {
    return InventroyItemModel(
      stt: map['STT'],
      code: map['Code'],
      name: map['Name'],
      origin: map['Origin'],
      tradeMark: map['TradeMark'],
      Price: map['Price'],
      Price0: map['Price0'],
      Price1: map['Price1'],
      Price2: map['Price2'],
      Price3: map['Price3'],
      Price4: map['Price4'],
      quantity: map['Quantity'],
      unit: map['Unit'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InventroyItemModel.fromJson(String source) =>
      InventroyItemModel.fromMap(json.decode(source));
}
