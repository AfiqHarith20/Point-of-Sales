import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/api/api.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/user_model.dart';
import 'package:pointofsales/screen/register_screen.dart';
import 'package:pointofsales/widget/login/login_button.dart';
import 'package:pointofsales/widget/login/login_textfield.dart';
import 'package:pointofsales/widget/login/square_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  LoginScreen({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<Login> userLogin() async {
    print(emailController.text);
    print(passwordController.text);
    final http.Response response = await http.post(
      Uri.parse("http://template.gosini.xyz:8880/cspos/public/api/login"),
      body: ({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );
    final Map<String, dynamic> responseData = JSON.jsonDecode(response.body);
    print(responseData);

    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['data']['token']);
      prefs.setString('email', responseData['data']['email']);
      print(response);
    } else {
      print(response.reasonPhrase);
    }
    return userLogin();
  }

  //Sign in user
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 5.h,
            ),
            FaIcon(
              FontAwesomeIcons.shopLock,
              size: 100,
              color: kScaffoldColor,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "Welcome back you\'ve been missed!",
              style: GoogleFonts.ubuntu(
                fontSize: 14.sp,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500,
                color: kScaffoldColor,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 338),
              child: Text(
                "Email:",
                style: GoogleFonts.ubuntu(
                  fontSize: 14.sp,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w500,
                  color: kScaffoldColor,
                ),
              ),
            ),
            LoginTextfield(
              controller: emailController,
              hintText: 'Please Enter Email',
              obscureText: false,
            ),
            SizedBox(
              height: 1.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 300),
              child: Text(
                "Password:",
                style: GoogleFonts.ubuntu(
                  fontSize: 14.sp,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w500,
                  color: kScaffoldColor,
                ),
              ),
            ),
            LoginTextfield(
              controller: passwordController,
              hintText: 'Please Enter Password',
              obscureText: true,
            ),
            SizedBox(
              height: 1.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password?",
                    style: GoogleFonts.ubuntu(
                      fontSize: 10.sp,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500,
                      color: kScaffoldColor,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            LoginButton(
              onTap: userLogin,
            ),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1.0,
                      color: Colors.grey[400],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Or Continue With",
                      style: GoogleFonts.ubuntu(
                        fontSize: 10.sp,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                        color: kScaffoldColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1.0,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareTile(
                  imagePath: "assets/google.png",
                ),
                SizedBox(
                  width: 4.w,
                ),
                SquareTile(
                  imagePath: "assets/apple.png",
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a member?",
                  style: GoogleFonts.ubuntu(
                    fontSize: 14.sp,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w500,
                    color: kTextColor,
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    ),
                  },
                  child: Text(
                    "Register now",
                    style: GoogleFonts.ubuntu(
                      fontSize: 14.sp,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      )),
    );
  }
}
