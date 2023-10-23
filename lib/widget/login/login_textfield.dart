import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/constant.dart';
import 'package:sizer/sizer.dart';

class LoginTextfield extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const LoginTextfield({
    Key? key,
    this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  State<LoginTextfield> createState() => _LoginTextfieldState();
}

class _LoginTextfieldState extends State<LoginTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: TextField(
        style: GoogleFonts.inder(
          fontSize: 10.sp,
          letterSpacing: 1.0,
          fontWeight: FontWeight.w400,
          color: kTextColor,
        ),
        controller: widget.controller,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: kPrimaryColor,
          filled: true,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const PasswordTextField({
    Key? key,
    this.controller,
    required this.hintText,
    required this.obscureText,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: TextField(
        style: GoogleFonts.inder(
          fontSize: 10.sp,
          letterSpacing: 1.0,
          fontWeight: FontWeight.w400,
          color: kTextColor,
        ),
        controller: widget.controller,
        obscureText: !_obscureText,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: kPrimaryColor,
          filled: true,
          hintText: widget.hintText,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: FaIcon(
                _obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                color: kHint,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
