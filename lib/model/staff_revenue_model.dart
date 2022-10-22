import 'dart:convert';

class StaffRevenueModel {
  double? today;
  double? yesterday;
  double? ThangNay;
  double? ThangTruoc;
  int? DoanhSoNhom;
  int? SoPhieu;
  int? SoBaoGia;
  int? ChuaXuLy;
  int? ChuaXacNhan;

  int? TheoDoi;
  int? PhatSinh;
  int? PhatSinh3T;
  int? KoPhatSinh3T;
  int? SoKhachNo;
  int? TienNo;
  int? TienQuaHan;

  StaffRevenueModel(
      {this.today,
      this.yesterday,
      this.ThangNay,
      this.ThangTruoc,
      this.DoanhSoNhom,
      this.SoPhieu,
      this.SoBaoGia,
      this.ChuaXacNhan,
      this.ChuaXuLy,
      this.TheoDoi,
      this.PhatSinh,
      this.PhatSinh3T,
      this.KoPhatSinh3T,
      this.SoKhachNo,
      this.TienNo,
      this.TienQuaHan});

  Map<String, dynamic> toMap() {
    return {
      'Today': today,
      'Yesterday': yesterday,
      'ThangNay': ThangNay,
      'ThangTruoc': ThangTruoc,
      'DoanhSoNhom': DoanhSoNhom,
      'SoPhieu': SoPhieu,
      'SoBaoGia': SoBaoGia,
      'ChuaXacNhan': ChuaXacNhan,
      'ChuaXuLy': ChuaXuLy,
      'TheoDoi': TheoDoi,
      'PhatSinh': PhatSinh,
      'PhatSinh3T': PhatSinh3T,
      'KoPhatSinh3T': KoPhatSinh3T,
      'SoKhachNo': SoKhachNo,
      'TienNo': TienNo,
      'TienQuaHan': TienQuaHan,
    };
  }

  factory StaffRevenueModel.fromMap(Map<String, dynamic> map) {
    return StaffRevenueModel(
      today: map['Today'],
      yesterday: map['Yesterday'],
      ThangNay: map['ThangNay'],
      ThangTruoc: map['ThangTruoc'],
      DoanhSoNhom: map['DoanhSoNhom'],
      SoPhieu: map['SoPhieu'],
      SoBaoGia: map['SoBaoGia'],
      ChuaXacNhan: map['ChuaXacNhan'],
      ChuaXuLy: map['ChuaXuLy'],
      TheoDoi: map['TheoDoi'],
      PhatSinh: map['PhatSinh'],
      PhatSinh3T: map['PhatSinh3T'],
      KoPhatSinh3T: map['KoPhatSinh3T'],
      SoKhachNo: map['SoKhachNo'],
      TienNo: map['TienNo'],
      TienQuaHan: map['TienQuaHan'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StaffRevenueModel.fromJson(String source) =>
      StaffRevenueModel.fromMap(json.decode(source));

  static List<StaffRevenueModel> listFromJson(list) =>
      List<StaffRevenueModel>.from(
          list.map((x) => StaffRevenueModel.fromMap(x)));
}
