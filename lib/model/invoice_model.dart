import 'Dart:convert';
import 'package:sale_soft/common/date_time_helper.dart';

class InvoiceModel {
  int? stt;
  DateTime? ngay;
  String? nhanVien;
  String? noiDung;

  InvoiceModel({
    this.stt,
    this.ngay,
    this.nhanVien,
    this.noiDung,
  });

  Map<String, dynamic> toMap() {
    return {
      'STT': stt,
      'Ngay': DateTimeHelper.dateToStringFormat(date: ngay),
      'NhanVien': nhanVien,
      'NoiDung': noiDung,
    };
  }

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      stt: map['Stt'],
      ngay: DateTimeHelper.stringToDate(dateStr: map['Ngay']),
      nhanVien: map['NhanVien'],
      noiDung: map['NoiDung'],
    );
  }

  String toJson() => json.encode(toMap());

  factory InvoiceModel.fromJson(String source) =>
      InvoiceModel.fromMap(json.decode(source));
}
