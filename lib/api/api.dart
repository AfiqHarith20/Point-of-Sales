import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pointofsales/model/user_model.dart';

Future<Register> userRegister() async {
  Uri uri =
      Uri.parse("http://template.gosini.xyz:8880/cspos/public/api/register");
  var response = await http.post(uri);
  print(response.statusCode);

  if (response.statusCode == 200) {
    print(response);
    print("SUCCESS REGISTER!!!!!!!!!!!!!!!!!!!!!!!!!!");
  } else {
    print(response.reasonPhrase);
  }
  return userRegister();
}

Future<Login> userLogin() async {
  Uri uri = Uri.parse("http://template.gosini.xyz:8880/cspos/public/api/login");
  var response = await http.post(uri);
  print(response.statusCode);

  if (response.statusCode == 200) {
    print(response);
  } else {
    print(response.reasonPhrase);
  }
  return userLogin();
}
