import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/constant.dart';
import 'package:sizer/sizer.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;
  const LoginButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
