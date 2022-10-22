import 'Dart:convert';

class CustomerDetailModel {
  String? code;
  String? name;
  int? level;
  String? staff;
  String? address;
  String? taxCode;
  String? xungDanh;
  String? nguoiLienHe;
  String? chucVu;
  String? dienThoai;
  String? email;

  /// Biến tạm
  bool isExpanded = false;

  CustomerDetailModel({
    this.code,
    this.name,
    this.level,
    this.staff,
    this.address,
    this.taxCode,
    this.xungDanh,
    this.nguoiLienHe,
    this.chucVu,
    this.dienThoai,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'Code': code,
      'Name': name,
      'Level': level,
      'Staff': staff,
      'Address': address,
      'TaxCode': taxCode,
      'XungDanh': xungDanh,
      'NguoiLienHe': nguoiLienHe,
      'ChucVu': chucVu,
      'DienThoai': dienThoai,
      'Email': email,
    };
  }

  factory CustomerDetailModel.fromMap(Map<String, dynamic> map) {
    return CustomerDetailModel(
      code: map['Code'],
      name: map['Name'],
      level: map['Level'],
      staff: map['Staff'],
      address: map['Address'],
      taxCode: map['TaxCode'],
      xungDanh: map['XungDanh'],
      nguoiLienHe: map['NguoiLienHe'],
      chucVu: map['ChucVu'],
      dienThoai: map['DienThoai'],
      email: map['Email'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerDetailModel.fromJson(String source) =>
      CustomerDetailModel.fromMap(json.decode(source));
}
