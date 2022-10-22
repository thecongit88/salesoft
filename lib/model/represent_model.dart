import 'dart:convert';

class RepresentModel {
  String? Code;
  String? Dear;
  String? Name;
  String? Phone;
  String? Email;
  bool isSelected = false;

  RepresentModel({
    this.Code,
    this.Dear,
    this.Name,
    this.Phone,
    this.Email,
    this.isSelected = false
  });

  Map<String, dynamic> toMap() {
    return {
      'Code': Code,
      'Dear': Dear,
      'Name': Name,
      'Phone': Phone,
      'Email': Email
    };
  }

  factory RepresentModel.fromMap(Map<String, dynamic> map) {
    return RepresentModel(
      Code: map['Code'],
      Dear: map['Dear'],
      Name: map['Name'],
      Phone: map['Phone'],
      Email: map['Email']
    );
  }

  String toJson() => json.encode(toMap());

  factory RepresentModel.fromJson(String source) =>
      RepresentModel.fromMap(json.decode(source));

  static List<RepresentModel> listFromJson(list) =>
      List<RepresentModel>.from(list.map((x) => RepresentModel.fromMap(x)));
}