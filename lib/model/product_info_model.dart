import 'dart:convert';

class ProductInfoModel {
  String? code;
  String? name;
  String? unit;

  ProductInfoModel({
    this.code,
    this.name,
    this.unit
  });

  Map<String, dynamic> toMap() {
    return {
      "Code": code,
      "Name": name,
      "DVT": unit
    };
  }

  factory ProductInfoModel.fromMap(Map<String, dynamic> map) {
    return ProductInfoModel(
      code: map['Code'],
      name: map['Name'],
      unit: map['DVT']
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductInfoModel.fromJson(String source) =>
      ProductInfoModel.fromMap(json.decode(source));

  static List<ProductInfoModel> listFromJson(list) =>
      List<ProductInfoModel>.from(list.map((x) => ProductInfoModel.fromMap(x)));
}
