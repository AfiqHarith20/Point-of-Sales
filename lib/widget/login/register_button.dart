import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/constant.dart';
import 'package:sizer/sizer.dart';

class RegisterButton extends StatelessWidget {
  final Function()? onTap;
  const RegisterButton({
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
          "Sign Up",
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
