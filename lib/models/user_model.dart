import 'dart:convert';

class UserModel {
  String message;
  Data data;

  UserModel({
    required this.message,
    required this.data,
  });
}

class Data {
  String token;
  String email;
  dynamic fullname;
  int roleId;
  String roleName;

  Data({
    required this.token,
    required this.email,
    required this.fullname,
    required this.roleId,
    required this.roleName,
  });

  // factory Data.fromJson(Map<String, dynamic> json) => Data(
  //       token: json['token'],
  //       email: json['email'],
  //       fullname: json['fullname'],
  //       roleId: json['role_id'],
  //       roleName: json['role_name'],
  //     );
}

class Register {
  String email;
  String name;
  String password;

  Register({
    required this.email,
    required this.name,
    required this.password,
  });
}

class Login {
  String email;
  String password;

  Login({
    required this.email,
    required this.password,
  });
}
