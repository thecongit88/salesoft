import 'Dart:convert';

///
/// Thông tin doanh nghiệp
///
class CompanyInfoModel {
  String? key1;
  String? name;
  String? taxcode;
  String? address;
  String? phone;

  CompanyInfoModel({
    this.key1,
    this.name,
    this.taxcode,
    this.address,
    this.phone
  });

  Map<String, dynamic> toMap() {
    return {
      'Key1': key1,
      'Name': name,
      'TaxCode': taxcode,
      'Address': address,
      'Phone': phone
    };
  }

  factory CompanyInfoModel.fromMap(Map<String, dynamic> map) {
    return CompanyInfoModel(
      key1: map['Key1'],
      name: map['Name'],
      taxcode: map['TaxCode'],
      address: map['Address'],
      phone: map['Phone']
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyInfoModel.fromJson(String source) =>
      CompanyInfoModel.fromMap(json.decode(source));
}
