import 'dart:convert';

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
