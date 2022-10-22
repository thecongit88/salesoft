import 'dart:convert';

class LoginParam {
  String userName;
  String password;
  String companyCode;

  LoginParam({
    required this.userName,
    required this.password,
    required this.companyCode,
  });

  LoginParam copyWith({
    String? userName,
    String? password,
    String? companyCode,
  }) {
    return LoginParam(
      userName: userName ?? this.userName,
      password: password ?? this.password,
      companyCode: companyCode ?? this.companyCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'password': password,
      'companyCode': companyCode,
    };
  }

  factory LoginParam.fromMap(Map<String, dynamic> map) {
    return LoginParam(
      userName: map['userName'],
      password: map['password'],
      companyCode: map['companyCode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginParam.fromJson(String source) =>
      LoginParam.fromMap(json.decode(source));

  @override
  String toString() =>
      'LoginParam(userName: $userName, password: $password, companyCode: $companyCode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginParam &&
        other.userName == userName &&
        other.password == password &&
        other.companyCode == companyCode;
  }

  @override
  int get hashCode =>
      userName.hashCode ^ password.hashCode ^ companyCode.hashCode;
}
