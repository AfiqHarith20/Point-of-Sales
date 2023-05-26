import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  Future<void> userLogin(String email, String password) async {
    Uri uri =
        Uri.parse("http://template.gosini.xyz:8880/cspos/public/api/register");

    try {
      var response = await http.post(uri,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));

      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw responseData['error']["message"];
      }
    } catch (error) {
      throw error;
    }
  }
}
