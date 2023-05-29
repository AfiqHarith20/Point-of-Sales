import 'dart:convert' as JSON;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pointofsales/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logout() async {
  Uri uri =
      Uri.parse("http://template.gosini.xyz:8880/cspos/public/api/logout");
  var response = await http.post(uri,
      headers: ({
        'Authorization': 'Bearer<token>',
        'Content-Type': 'application/json',
      }));
  print(response.statusCode);

  if (response.statusCode == 200) {
    print(response);
    print("SUCCESS REGISTER!!!!!!!!!!!!!!!!!!!!!!!!!!");
  } else {
    print(response.reasonPhrase);
  }
  return logout();
}
