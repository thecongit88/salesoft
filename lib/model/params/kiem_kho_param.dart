import 'dart:convert';
import 'dart:core';

class KiemKhoParam {
  int? UserID;
  String? Code;
  String? Ngay;
  String? Kho;
  String? KeHoach;
  String? Key;
  List<ItemKiemKho>? list;

  KiemKhoParam(
      {
        this.UserID,
        this.Code,
        this.Ngay,
        this.Kho,
        this.Key,
        this.KeHoach,
        this.list,
     });
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'UserID': UserID,
      'Code': Code,
      'Ngay': Ngay,
      'Kho': Kho,
      'Key': Key,
      'KeHoach': KeHoach,
      'ListItem': list!.map((x) => x.toMap()).toList(),
    };
  }
}

class ItemKiemKho {
  int? DetailID;
  String? Code;
  double Quantity = 0;

  ItemKiemKho({
     this.DetailID,
     this.Code,
     this.Quantity = 0
  });

  String toJson() => json.encode(toMap());
  Map<String, dynamic> toMap() {
    return {
      'DetailID': DetailID,
      'Code': Code,
      'Quantity': Quantity
    };
  }
}
