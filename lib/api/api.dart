import 'dart:convert' as JSON;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pointofsales/models/user_model.dart';
import 'package:pointofsales/screen/log%20n%20reg/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _isLoader = false;

Future<void> logout(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Uri uri =
      Uri.parse("http://template.gosini.xyz:8880/cspos/public/api/logout");
  var response = await http.post(uri,
      headers: ({
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json',
      }));

  print(response.statusCode);
  prefs.remove('token');

  if (response.statusCode == 200) {
    print(response);
    print("Logout!!!!!!!!!!!!!!!!!!!!!!!!!!");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  } else {
    print(response.reasonPhrase);
  }
  return logout(context);
}
