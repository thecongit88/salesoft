import 'dart:convert';

class ItemInStockModel {
  int? STT;
  String? Kho;
  double? Ton;
  ItemInStockModel({
    this.STT,
    this.Kho,
    this.Ton,
  });
  Map<String, dynamic> toMap() {
    return {
      'STT': STT,
      'Kho': Kho,
      'Ton': Ton,
    };
  }

  factory ItemInStockModel.fromMap(Map<String, dynamic> map) {
    return ItemInStockModel(
      STT: map['STT'],
      Kho: map['Kho'],
      Ton: map['Ton'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemInStockModel.fromJson(String source) =>
      ItemInStockModel.fromMap(json.decode(source));

  static List<ItemInStockModel> listFromJson(list) {
    return List<ItemInStockModel>.from( 
        list.map((x) => ItemInStockModel.fromMap(x)));
  }
}
