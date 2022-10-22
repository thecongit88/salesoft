import 'dart:convert';

class InventoryItemCategoryModel {
  int? stt;
  int? number;
  String? idParent;
  String? code;
  String? name;

  bool isSelected = false;

  InventoryItemCategoryModel({
    this.stt,
    this.number,
    this.idParent,
    this.code,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'STT': stt,
      'Num': number,
      'IDParent': idParent,
      'Code': code,
      'Name': name,
    };
  }

  factory InventoryItemCategoryModel.fromMap(Map<String, dynamic> map) {
    return InventoryItemCategoryModel(
      stt: map['STT'],
      number: map['Num'],
      idParent: map['IDParent'],
      code: map['Code'],
      name: map['Name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryItemCategoryModel.fromJson(String source) =>
      InventoryItemCategoryModel.fromMap(json.decode(source));
}
