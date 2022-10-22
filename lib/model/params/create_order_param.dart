import 'dart:convert';
import 'dart:core';

class CreateOrderParam {
  int? ID;
  String? Code;
  String? Ngay;
  String? Kho;
  String? LoaiCT;
  String? Key;
  String? ChungTu;
  String? KhachHang;
  String? TenKhachHang;
  String? DiaChi;
  double TienHang = 0.0;
  double MucThue = 10;
  double TienThue = 0.0;
  double? KhuyenMai;
  double PsCo = 0.0;
  double PsNo = 0.0;
  double ConLai = 0.0;
  int? IDCuaHang;
  String? GhiChu;
  String? HanThanhToan;
  List<Item> list;

  CreateOrderParam(
      {required this.ID,
      required this.Code,
      required this.Ngay,
      required this.Kho,
      required this.Key,
      required this.ChungTu,
      required this.KhachHang,
      required this.TenKhachHang,
      required this.DiaChi,
      required this.TienHang,
      required this.MucThue,
      required this.TienThue,
      required this.KhuyenMai,
      required this.PsCo,
      required this.PsNo,
      required this.ConLai,
      required this.IDCuaHang,
      required this.GhiChu,
      required this.HanThanhToan,
      required this.list,
      required this.LoaiCT});
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'Code': Code,
      'Ngay': Ngay,
      'Kho': Kho,
      'Key': Key,
      'ChungTu': ChungTu,
      'KhachHang': KhachHang,
      'TenKhachHang': TenKhachHang,
      'LoaiCT': LoaiCT,
      'DiaChi': DiaChi,
      'TienHang': TienHang,
      'MucThue': MucThue,
      'KhuyenMai': KhuyenMai,
      'PsCo': PsCo,
      'PsNo': PsNo,
      'IDCuaHang': IDCuaHang,
      'GhiChu': GhiChu,
      'HanThanhToan': HanThanhToan,
      'TienThue': TienThue,
      'ConLai': ConLai,
      'ListItem': list.map((x) => x.toMap()).toList(),
    };
  }
}

class Item {
  String? Id;
  String? Name;
  double Quantity = 0.0;
  double Price = 0.0;
  double Promo = 0.0;

  Item({
    required this.Id,
    required this.Name,
    required this.Quantity,
    required this.Price,
    required this.Promo,
  });

  String toJson() => json.encode(toMap());
  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'Name': Name,
      'Quantity': Quantity,
      'Price': Price,
      'Promo': Promo
    };
  }
}
