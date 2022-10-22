import 'dart:convert';

class CustomerModel {
  int? stt;
  String? code;
  String? name;
  int? level;
  String? staff;

  CustomerModel({
    this.stt,
    this.code,
    this.name,
    this.level,
    this.staff,
  });

  Map<String, dynamic> toMap() {
    return {
      'STT': stt,
      'Code': code,
      'Name': name,
      'Level': level,
      'Staff': staff,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      stt: map['STT'],
      code: map['Code'],
      name: map['Name'],
      level: map['Level'],
      staff: map['Staff'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source));
}
