import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'package:sale_soft/common/date_time_helper.dart';

class TopsaleModel {
  int? stt;
  String? chungTu;
  DateTime? ngay;
  double? soLuong;
  String? loai;
  double? thanhTien;

  TopsaleModel({
    this.stt,
    this.chungTu,
    this.ngay,
    this.soLuong,
    this.loai,
    this.thanhTien,
  });

  Map<String, dynamic> toMap() {
    return {
      'STT': stt,
      'ChungTu': chungTu,
      'Ngay': DateTimeHelper.dateToStringFormat(date: ngay),
      'SoLuong': soLuong,
      'Loai': loai,
      'ThanhTien': thanhTien,
    };
  }

  factory TopsaleModel.fromMap(Map<String, dynamic> map) {
    return TopsaleModel(
      stt: map['STT'],
      chungTu: map['ChungTu'],
      ngay: DateTimeHelper.stringToDate(dateStr: map['Ngay']),
      soLuong: map['SoLuong'],
      loai: map['Loai'],
      thanhTien: map['ThanhTien'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TopsaleModel.fromJson(String source) =>
      TopsaleModel.fromMap(json.decode(source));

  Color getColor() {
    int indexColor = stt ?? 1;
    switch (indexColor) {
      case 1:
        return AppColors.orange;
      case 2:
        return AppColors.blue;
      case 3:
        return AppColors.turquoise;
      case 4:
        return AppColors.yellow400;
      case 5:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
