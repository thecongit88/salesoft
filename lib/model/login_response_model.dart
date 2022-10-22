import 'dart:convert';

class LoginResponseModel {
  int? id;
  String? code;
  String? name;
  String? email;
  String? password;
  String? admin;
  String? error;
  String? keyLog;
  int? idShop;
  String? key;
  String? userType;

  LoginResponseModel(
      {this.id,
      this.code,
      this.name,
      this.email,
      this.password,
      this.admin,
      this.error,
      this.idShop,
      this.keyLog,
      this.key,
      this.userType
  });

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'Code': code,
      'Name': name,
      'Email': email,
      'Password': password,
      'Admin': admin,
      'Error': error,
      'IDShop': idShop,
      'KeyLog': keyLog,
      'Key': key,
      'UserType': userType,
    };
  }

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      id: map['ID'],
      code: map['Code'],
      name: map['Name'],
      email: map['Email'],
      password: map['Password'],
      admin: map['Admin'],
      error: map['Error'],
      idShop: map['IDShop'],
      keyLog: map['KeyLog'],
      key: map['Key'],
      userType: map['UserType'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromJson(String source) =>
      LoginResponseModel.fromMap(json.decode(source));


}
