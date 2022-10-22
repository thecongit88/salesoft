import 'package:sale_soft/model/price_list_item.dart';

class PriceListObject {
  String TuXung = '';
  String XungDanh = '';
  String TGGH = '';
  String TGGH_ID = '';
  String DaiDienHang = '';
  String PTVC = '';
  String PTVC_ID = '';
  String DKTT = '';
  String DKTT_ID = '';
  String? MucGia = '';
  String? LoaiTien = '';
  String TuNgay = '';
  String DenNgay = '';
  String Email = '';
  String DienThoai = '';
  String NguoiDaiDien = '';
  String Ten = '';
  String Code = '';
  String DiaChi = '';
  String CodeTax = '';
  String EmailNV = '';
  String Password = '';
  String EmailCC = '';
  String NoiDung = '';
  bool VAT = false;
  double TongTien = 0;
  List<PriceListItem> Lists = [];

  String UserName = '';
  String UserPhone = '';
  String UserEmail = '';
  String key = "";

  PriceListObject();

  PriceListObject.fromJson(Map<String, dynamic> json)
      : TuXung = json['TuXung'] as String,
        XungDanh = json['XungDanh'] as String,
        TGGH = json['TGGH'] as String,
        TGGH_ID = json['TGGH_ID'] as String,
        DaiDienHang = json['DaiDienHang'] as String,
        PTVC = json['PTVC'] as String,
        PTVC_ID = json['PTVC_ID'] as String,
        DKTT = json['DKTT'] as String,
        DKTT_ID = json['DKTT_ID'] as String,
        MucGia = json['MucGia'] as String,
        LoaiTien = json['LoaiTien'] as String,
        TuNgay = json['TuNgay'] as String,
        DenNgay = json['DenNgay'] as String,
        Email = json['Email'] as String,
        DienThoai = json['DienThoai'] as String,
        NguoiDaiDien = json['NguoiDaiDien'] as String,
        Ten = json['Ten'] as String,
        Code = json['Code'] as String,
        DiaChi = json['DiaChi'] as String,
        CodeTax = json['CodeTax'] as String,
        VAT = json['VAT'] as bool,
        EmailNV = json['EmailNV'] as String,
        Password = json['Password'] as String,
        TongTien = (json['TongTien'] as num).toDouble(),
        EmailCC = json['EmailCC'] as String,
        UserName = json['UserName'] as String,
        UserPhone = json['UserPhone'] as String,
        UserEmail = json['UserEmail'] as String,
        NoiDung = json['NoiDung'] as String,
        key = json['key'] as String,
        Lists = json['Lists'].map<PriceListItem>((e) => PriceListItem.fromJson(e)).toList();

  Map<String, dynamic> toJson() => <String, dynamic>{
        'TuXung': this.TuXung,
        'XungDanh': this.XungDanh,
        'TGGH': this.TGGH,
        'TGGH_ID': this.TGGH_ID,
        'DaiDienHang': this.DaiDienHang,
        'PTVC': this.PTVC,
        'PTVC_ID': this.PTVC_ID,
        'DKTT': this.DKTT,
        'DKTT_ID': this.DKTT_ID,
        'MucGia': this.MucGia,
        'LoaiTien': this.LoaiTien,
        'TuNgay': this.TuNgay,
        'DenNgay': this.DenNgay,
        'Email': this.Email,
        'DienThoai': this.DienThoai,
        'NguoiDaiDien': this.NguoiDaiDien,
        'Ten': this.Ten,
        'Code': this.Code,
        'DiaChi': this.DiaChi,
        'CodeTax': this.CodeTax,
        'VAT': this.VAT,
        'EmailNV': this.EmailNV,
        'Password': this.Password,
        'TongTien': this.TongTien,
        'EmailCC': this.EmailCC,
        'UserName': this.UserName,
        'UserPhone': this.UserPhone,
        'UserEmail': this.UserEmail,
        'NoiDung': this.NoiDung,
        'key': this.key,
        'Lists': this.Lists.map((e) => e.toJson()).toList(),
      };
}
