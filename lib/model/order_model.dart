import 'Dart:convert';
import 'package:sale_soft/common/date_time_helper.dart';

class OrderModel {
  int? stt;
  int? id;
  String? chungTu;
  String? loaiChungTu;
  double? phatSinhCo;
  double? phatSinhNo;
  DateTime? ngay;
  String? tenKhachHang;
  String? dienThoai;
  String? email;
  String? diaChi;
  double? soLuong;
  String? ttDatHang;
  String? ttBanHang;
  String? ttXuatKho;
  double? tinhTrang;

  OrderModel({
    this.stt,
    this.id,
    this.chungTu,
    this.loaiChungTu,
    this.phatSinhCo,
    this.phatSinhNo,
    this.ngay,
    this.tenKhachHang,
    this.dienThoai,
    this.email,
    this.diaChi,
    this.soLuong,
    this.ttDatHang,
    this.ttBanHang,
    this.ttXuatKho,
    this.tinhTrang
  });

  Map<String, dynamic> toMap() {
    return {
      "STT": this.stt,
      "ID": this.id,
      "Chung_Tu": this.chungTu,
      "LoaiCT": this.loaiChungTu,
      "PsCo": this.phatSinhCo,
      "PsNo": this.phatSinhNo,
      "Ngay": DateTimeHelper.dateToStringFormat(date: this.ngay),
      "TenKhachHang": this.tenKhachHang,
      "DienThoai":this.dienThoai,
      "Email": this.email,
      "DiaChi": this.diaChi,
      "So_Luong":this.soLuong,
      "TT_DatHang":this.ttDatHang,
      "TT_BanHang":this.ttBanHang,
      "TT_XuatKho":this.ttXuatKho,
      "TinhTrang":this.tinhTrang
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      stt: map['Stt'],
      id: map['ID'],
      chungTu: map['Chung_Tu'],
      loaiChungTu: map['LoaiCT'],
      phatSinhCo: map['PsCo'],
      phatSinhNo: map['PsNo'],
      ngay: DateTimeHelper.stringToDate(dateStr: map['Ngay']),
      tenKhachHang: map['TenKhachHang'],
      dienThoai: map['DienThoai'],
      email: map['Email'],
      diaChi: map['DiaChi'],
      soLuong: map['So_Luong'],
      ttDatHang: map['TT_DatHang'],
      ttBanHang: map['TT_BanHang'],
      ttXuatKho: map['TT_XuatKho'],
      tinhTrang: map['TinhTrang']
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));
}
