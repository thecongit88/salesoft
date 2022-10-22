import 'dart:convert';

class InsertTokenParam {
  String? Code;
  String? Token;
  String? Key;

  InsertTokenParam(
      {required this.Code, required this.Token, required this.Key});

  String toJson() => json.encode(toMap());
  Map<String, dynamic> toMap() {
    return {'Code': Code, 'Token': Token, 'Key': Key};
  }
}
