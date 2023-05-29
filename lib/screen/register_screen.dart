import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/api/api.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/user_model.dart';
import 'package:pointofsales/screen/login_screen.dart';
import 'package:pointofsales/widget/login/sign_in_up_button.dart';
import 'package:pointofsales/widget/login/login_textfield.dart';
import 'package:pointofsales/widget/login/square_tile.dart';
import 'package:sizer/sizer.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({Key? key, this.onTap}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> userRegister() async {
    print(emailController.text);
    print(nameController.text);
    print(passwordController.text);
    final http.Response response = await http.post(
      Uri.parse("http://template.gosini.xyz:8880/cspos/public/api/register"),
      body: ({
        'email': emailController.text,
        'name': nameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      print(response);
      print("SUCCESS REGISTER!!!!!!!!!!!!!!!!!!!!!!!!!!");
    } else {
      print(response.reasonPhrase);
    }
    return userRegister();
  }

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
              size: 40,
              color: kScaffoldColor,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "Let\'s create an account for you!",
              style: GoogleFonts.ubuntu(
                fontSize: 14.sp,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w500,
                color: kScaffoldColor,
              ),
            ),
            SizedBox(
              height: 3.h,
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
              padding: const EdgeInsets.only(right: 335),
              child: Text(
                "Name:",
                style: GoogleFonts.ubuntu(
                  fontSize: 14.sp,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w500,
                  color: kScaffoldColor,
                ),
              ),
            ),
            LoginTextfield(
              controller: nameController,
              hintText: 'Please Enter Name',
              obscureText: false,
            ),
            SizedBox(
              height: 1.h,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 299),
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
              hintText: 'Please Confirm Your Password',
              obscureText: true,
            ),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              height: 1.h,
            ),
            RegisterButton(
              onTap: userRegister,
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
                      "Or Register With",
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
                  "Already Members?",
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
                        builder: (context) => LoginScreen(),
                      ),
                    ),
                  },
                  child: Text(
                    "Login now",
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
