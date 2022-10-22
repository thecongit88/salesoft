import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sale_soft/common/app_colors.dart';
import 'dart:math';

class RevenueModel {
  int? stt;
  int? id;
  String? cuaHang;
  double? soTien;

  /// Biến tạm
  String? subTitle;
  double? percent;

  RevenueModel({
    this.stt,
    this.id = 0,
    this.cuaHang,
    this.soTien,
  });

  Map<String, dynamic> toMap() {
    return {
      'STT': stt,
      'ID': id,
      'CuaHang': cuaHang,
      'SoTien': soTien,
    };
  }

  factory RevenueModel.fromMap(Map<String, dynamic> map) {
    return RevenueModel(
      stt: map['STT'],
      id: map['ID'],
      cuaHang: map['CuaHang'],
      soTien: map['SoTien'],
    );
  }

  Color getColor() {
    int indexColor = stt ?? 0;
    if ((stt ?? 0) > 5) {
      indexColor = ((stt ?? 0) / 5).round();
    }

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

  Color getColorForchart() {
    switch (stt) {
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
        return Color((Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0);
    }
  }

  String toJson() => json.encode(toMap());

  factory RevenueModel.fromJson(String source) =>
      RevenueModel.fromMap(json.decode(source));

  static List<RevenueModel> listFromJson(list) =>
      List<RevenueModel>.from(list.map((x) => RevenueModel.fromMap(x)));
}
