import 'dart:convert';

class WareHouseModel {
  String? Ma;
  String? Ten;

  bool isSelected = false;

  WareHouseModel({this.Ma, this.Ten});
  Map<String, dynamic> toMap() {
    return {'Ma': Ma, 'Ten': Ten};
  }

  factory WareHouseModel.fromMap(Map<String, dynamic> map) {
    return WareHouseModel(Ma: map['Ma'], Ten: map['Ten']);
  }

  String toJson() => json.encode(toMap());

  factory WareHouseModel.fromJson(String source) =>
      WareHouseModel.fromMap(json.decode(source));

  static List<WareHouseModel> listFromJson(list) =>
      List<WareHouseModel>.from(list.map((x) => WareHouseModel.fromMap(x)));

  static List<WareHouseModel> decode(String stores) =>
      (json.decode(stores) as List<dynamic>)
          .map<WareHouseModel>((item) => WareHouseModel.fromMap(item))
          .toList();
}
