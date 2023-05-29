import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/screen/history_screen.dart';
import 'package:pointofsales/screen/home_screen.dart';
import 'package:pointofsales/screen/invoice_screen.dart';
import 'package:pointofsales/screen/product_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Welcome Afiq Harith',
              style: GoogleFonts.aBeeZee(
                fontSize: 14.sp,
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
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.basketShopping,
            ),
            title: Text('Product'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductScreen(),
                ),
              ),
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.fileInvoiceDollar,
            ),
            title: Text('Invoices'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceScreen(),
                ),
              ),
            },
          ),
          ListTile(
              leading: FaIcon(
                FontAwesomeIcons.clockRotateLeft,
              ),
              title: Text('History'),
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryScreen(),
                      ),
                    ),
                  }),
          ListTile(
              leading: FaIcon(
                FontAwesomeIcons.clipboardList,
              ),
              title: Text('Report'),
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportScreen(),
                      ),
                    ),
                  }),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.user),
              title: Text('Profile'),
              onTap: () => {Navigator.of(context).pop()}),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingScreen(),
                ),
              ),
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.clear();
            },
          ),
        ],
      ),
    );
  }
}
