import 'dart:convert';

class CustomerDebtModel {
  int? STT;
  String? code;
  String? Ten;
  String? DiaChi;
  String? DienThoai;
  double? NoDauKy;
  double? NoCuoiKy;

  CustomerDebtModel({
    this.STT,
    this.code,
    this.Ten,
    this.DiaChi,
    this.DienThoai,
    this.NoDauKy,
    this.NoCuoiKy,
  });

  Map<String, dynamic> toMap() {
    return {
      'STT': STT,
      'Ma': code,
      'Ten': Ten,
      'DiaChi': DiaChi,
      'DienThoai': DienThoai,
      'NoDauKy': NoDauKy,
      'NoCuoiKy': NoCuoiKy,
    };
  }

  factory CustomerDebtModel.fromMap(Map<String, dynamic> map) {
    return CustomerDebtModel(
      STT: map['STT'],
      code: map['Ma'],
      Ten: map['Ten'],
      DiaChi: map['DiaChi'],
      DienThoai: map['DienThoai'],
      NoDauKy: map['NoDauKy'],
      NoCuoiKy: map['NoCuoiKy']
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerDebtModel.fromJson(String source) =>
      CustomerDebtModel.fromMap(json.decode(source));
}
