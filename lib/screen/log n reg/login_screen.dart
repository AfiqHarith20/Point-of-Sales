import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/api/api.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/screen/home_screen.dart';
import 'package:pointofsales/widget/login/login_textfield.dart';
import 'package:pointofsales/widget/login/square_tile.dart';
import 'package:pointofsales/widget/progressIndicator.dart';
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

  bool _isLoader = false;

  Future<void> userLogin() async {
    try {
      final http.Response response = await http.post(
        Uri.parse(Constants.apiLogin),
        body: ({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );
      final Map<String, dynamic> responseData = JSON.jsonDecode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final token = responseData['data']['token'] as String?;
        final email = responseData['data']['email'] as String?;
        print(response);

        emailController.clear();
        passwordController.clear();

        if(token != null && email != null) {
          prefs.setString('token', token);
          prefs.setString('email', email);
        }else{
          throw "Token or email is null in API response";
        }

        setState(() {
          _isLoader = true;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        });
      } else {
        throw jsonDecode(response.body)["Message"] ??
            "Sorry Wrong Email or Password!";
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Error"),
            contentPadding: EdgeInsets.all(20),
            children: [
              Text(
                e.toString(),
              )
            ],
          );
        },
      );
    }
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
              padding: const EdgeInsets.all(0),
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
              padding: const EdgeInsets.all(0),
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
            _loginButton(context),
            // LoginButton(
            //   onTap: userLogin,
            // ),
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => RegisterScreen(),
                    //   ),
                    // ),
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

  Widget _loginButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _isLoader ? buildCircularProgressIndicator() : userLogin(),
      child: Container(
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: kScaffoldColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
            child: Text(
          "Sign In",
          style: GoogleFonts.ubuntu(
            fontSize: 14.sp,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w500,
            color: kTextColor,
          ),
        )),
      ),
    );
  }
}
