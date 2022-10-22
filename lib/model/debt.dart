import 'dart:convert';

class Debt {
  int? ID = null;
  int? STT = null;
  String? Ngay = null;
  double? ThanhToan = null;
  double? ConLai = null;
  double? DauKy = null;
  double? CuoiKy = null;
  double? MuaHang = null;
  String? Chung_Tu = null;

  Debt(
      {this.ID,
      this.STT,
      this.Ngay,
      this.ThanhToan,
      this.ConLai,
      this.DauKy,
      this.MuaHang,
      this.CuoiKy,
      this.Chung_Tu});

  Map<String, dynamic> toMap() {
    return {
      "STT": STT,
      "ID": ID,
      "Ngay": Ngay,
      "ThanhToan": ThanhToan,
      "ConLai": ConLai,
      "DauKy": DauKy,
      "MuaHang": MuaHang,
      "CuoiKy": CuoiKy,
      "Chung_Tu": Chung_Tu
    };
  }

  factory Debt.fromMap(Map<String, dynamic> map) {
    return Debt(
        STT: map["STT"],
        Ngay: map["Ngay"],
        ThanhToan: map["ThanhToan"],
        ConLai: map["ConLai"],
        DauKy: map["DauKy"],
        MuaHang: map["MuaHang"],
        CuoiKy: map["CuoiKy"],
        Chung_Tu: map["Chung_Tu"]);
  }
  String toJson() {
    return json.encode(toMap());
  }

  factory Debt.fromJson(String source) {
    return Debt.fromMap(json.decode(source));
  }

  static List<Debt> listFromJson(list) {
    return List<Debt>.from(list.map((x) => Debt.fromMap(x)));
  }
}
