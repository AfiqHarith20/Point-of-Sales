
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static String pos_baseurl = "http://template.gosini.xyz:8880/cspos/public/api";

  static String appName = "Point of Sales";

  static String apiRegister = pos_baseurl + "/register";
  static String apiLogin = pos_baseurl + "/login";
  static String apiLogout = pos_baseurl + "/logout";

  static String apiPosIndex = "/pos";
  static String apiSearchPosTransaction = "/search/item";

  static String apiProductIndex = "/product";
  static String apiSearchProduct = "/product/search/item";


}



