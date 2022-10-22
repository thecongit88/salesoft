import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PriceListOption {
  String Code;
  String? Id;
  String Name;

  PriceListOption({
    required this.Code,
    required this.Id,
    required this.Name,
  });

  factory PriceListOption.fromJson(Map<String, dynamic> map) {
    return PriceListOption(
      Code: map['Code'],
      Id: map['Id'],
      Name: map['Name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'Code': Code, 'Id': Id, 'Name': Name};
  }

  factory PriceListOption.fromJsonString(String json) =>
      PriceListOption.fromJson(jsonDecode(json));

  String toJsonString() => jsonEncode(toJson());
}

class PriceListOptionResponse {
  List<PriceListOption> items = [];
  PriceListOptionResponse.fromJson(json) {
    json.forEach((item) {
      var it = new PriceListOption.fromJson(item);
      items.add(it);
    });
  }
}