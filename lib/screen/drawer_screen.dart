import 'dart:convert';

import 'package:getwidget/components/drawer/gf_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/api/api.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/pos_model.dart';
import 'package:pointofsales/screen/history_screen.dart';
import 'package:pointofsales/screen/home_screen.dart';
import 'package:pointofsales/screen/invoice_screen.dart';
import 'package:pointofsales/screen/log%20n%20reg/login_screen.dart';
import 'package:pointofsales/screen/merchant_screen.dart';
import 'package:pointofsales/screen/report_screen.dart';
import 'package:pointofsales/screen/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  int? userId;
  String? userName, userEmail;
  late Future<User> _user;

  Future<void> logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Uri uri =
        Uri.parse(Constants.apiLogout);
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

    Future<User> fetchUser() async {
    final url = Uri.parse(Constants.apiPosIndex);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.get(
      url,
      headers: ({
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json'
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final user = User.fromJson(json);

      setState(() {
        /////////////////////////// User ////////////////////////////////////

        final userData = json['data'][0]['user'];
        if (userData != null) {
          final user = User(
            userid: userData['id'],
            username: userData['fullname'].toString(),
            useremail: userData['email'].toString(),
          );
          userId = user.userid;
          userName = user.username;
          userEmail = user.useremail;
        } else {
          print("User data is null");
        }
      });
      return user;
    } else {
      throw Exception('Failed to fetch user');
    }
  }


@override
void initState() {
  super.initState();
   _user = fetchUser();
}
  @override
  Widget build(BuildContext context) {
    return GFDrawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              userName != null && userName!.isNotEmpty
                  ? 'Welcome $userName'
                  : 'Welcome to Cartsini POS',
              style: GoogleFonts.ubuntu(
                fontSize: 12.sp,
                color: kTextColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
              ),
            ),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              // image: DecorationImage(
              //   fit: BoxFit.fill,
              //   image: AssetImage(''),
              // ),
            ),
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.houseChimney,
            ),
            title: Text('Home'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              ),
            },
          ),
          // ListTile(
          //   leading: FaIcon(
          //     FontAwesomeIcons.building,
          //   ),
          //   title: Text('Merchant'),
          //   onTap: () => {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => MerchantScreen(),
          //       ),
          //     ),
          //   },
          // ),
          // ListTile(
          //   leading: FaIcon(
          //     FontAwesomeIcons.fileInvoiceDollar,
          //   ),
          //   title: Text('Invoices'),
          //   onTap: () => {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => InvoiceScreen(
          //           invoiceData: invoiceData
          //         ),
          //       ),
          //     ),
          //   },
          // ),
          // ListTile(
          //     leading: FaIcon(
          //       FontAwesomeIcons.clockRotateLeft,
          //     ),
          //     title: Text('History'),
          //     onTap: () => {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => HistoryScreen(),
          //             ),
          //           ),
          //         }),
          // ListTile(
          //     leading: FaIcon(
          //       FontAwesomeIcons.clipboardList,
          //     ),
          //     title: Text('Report'),
          //     onTap: () => {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => ReportScreen(),
          //             ),
          //           ),
          //         }),
          // ListTile(
          //     leading: FaIcon(FontAwesomeIcons.user),
          //     title: Text('Profile'),
          //     onTap: () => {Navigator.of(context).pop()}),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () => {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => SettingScreen(),
          //       ),
          //     ),
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false, // Remove all existing routes
              );
            },
          ),
        ],
      ),
    );
  }
}
