import 'dart:convert';

class PlanModel {
  String? Ma;
  String? Ten;

  /// Biến tạm
  bool isSelected = false;

  PlanModel({this.Ma, this.Ten});

  Map<String, dynamic> toMap() {
    return {'Ma': Ma, 'Ten': Ten};
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      Ma: map['Ma'],
      Ten: map['Ten'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlanModel.fromJson(String source) =>
      PlanModel.fromMap(json.decode(source));

  static List<PlanModel> listFromJson(list) =>
      List<PlanModel>.from(list.map((x) => PlanModel.fromMap(x)));
}
