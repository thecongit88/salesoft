import 'dart:convert';

class StoreModel {
  int? id;
  String? name;
  String? address;

  /// Biến tạm
  bool isSelected = false;

  StoreModel({this.id, this.name, this.address});

  Map<String, dynamic> toMap() {
    return {'ID': id, 'Name': name, 'Address': address};
  }

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      id: map['ID'],
      name: map['Name'],
      address: map['Address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreModel.fromJson(String source) =>
      StoreModel.fromMap(json.decode(source));

  static List<StoreModel> listFromJson(list) =>
      List<StoreModel>.from(list.map((x) => StoreModel.fromMap(x)));

  static List<StoreModel> decode(String stores) =>
      (json.decode(stores) as List<dynamic>)
          .map<StoreModel>((item) => StoreModel.fromMap(item))
          .toList();

  static String encode(List<StoreModel> stores) => json.encode(
        stores.map<Map<String, dynamic>>((store) => store.toMap()).toList(),
      );
}
