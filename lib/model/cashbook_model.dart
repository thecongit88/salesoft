import 'dart:convert';

import 'package:sale_soft/model/base_model.dart';

class CashBookModel extends BaseModel {
  double? dauky;
  double? doanhThu;
  double? chiPhi;
  double? chenhLech;
  double? cuoiKy;

  CashBookModel({
    this.dauky,
    this.doanhThu,
    this.chiPhi,
    this.chenhLech,
    this.cuoiKy,
  });

  Map<String, dynamic> toMap() {
    return {
      'DauKy': dauky,
      'DoanhThu': doanhThu,
      'ChiPhi': chiPhi,
      'ChenhLech': chenhLech,
      'CuoiKy': cuoiKy,
    };
  }

  factory CashBookModel.fromMap(Map<String, dynamic> map) {
    return CashBookModel(
      dauky: map['DauKy'],
      doanhThu: map['DoanhThu'],
      chiPhi: map['ChiPhi'],
      chenhLech: map['ChenhLech'],
      cuoiKy: map['CuoiKy'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CashBookModel.fromJson(String source) =>
      CashBookModel.fromMap(json.decode(source));
}
