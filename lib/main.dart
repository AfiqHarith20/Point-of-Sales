import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/screen/home_screen.dart';
import 'package:pointofsales/screen/log%20n%20reg/login_screen.dart';
import 'package:pointofsales/widget/bottom_nav.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Point of Sales',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: kScaffoldColor,
            appBarTheme: AppBarTheme(
              backgroundColor: kPrimaryColor,
              iconTheme: IconThemeData(
                size: 23,
                color: kSecondaryColor,
              ),
            ),
            iconTheme: IconThemeData(
              size: 23,
              color: kSecondaryColor,
            ),
          ),
          home: LoginScreen(),
        );
      },
    );
  }
}
