import 'dart:convert';

import 'package:sale_soft/common/utils.dart';

class CashFlowModel {
  int? stt;
  String? nhom;
  String? ma;
  String? ten;
  double doanhThu = 0.0;
  double chiPhi = 0.0;
  double chenhLech = 0.0;

  CashFlowModel({
    this.stt,
    this.nhom,
    this.ma,
    this.ten,
    this.doanhThu = 0,
    this.chiPhi = 0,
    this.chenhLech = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'STT': stt,
      'Nhom': nhom,
      'Ma': ma,
      'Ten': ten,
      'DoanhThu': doanhThu,
      'ChiPhi': chiPhi,
      'ChenhLech': chenhLech,
    };
  }

  factory CashFlowModel.fromMap(Map<String, dynamic> map) {
    return CashFlowModel(
      stt: map['STT'],
      nhom: map['Nhom'],
      ma: map['Ma'],
      ten: map['Ten'],
      doanhThu: getNullValue(map['DoanhThu']),
      chiPhi: getNullValue(map['ChiPhi']),
      chenhLech: getNullValue(map['ChenhLech']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CashFlowModel.fromJson(String source) =>
      CashFlowModel.fromMap(json.decode(source));

  static List<CashFlowModel> listFromJson(list) =>
      List<CashFlowModel>.from(list.map((x) => CashFlowModel.fromMap(x)));
}