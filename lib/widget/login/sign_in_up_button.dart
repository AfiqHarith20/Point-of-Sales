import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/screen/home_screen.dart';
import 'package:pointofsales/widget/progressIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

// class LoginButton extends StatefulWidget {
//   final Function()? onTap;
//   const LoginButton({
//     Key? key,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   State<LoginButton> createState() => _LoginButtonState();
// }

// class _LoginButtonState extends State<LoginButton> {
//   final GlobalKey<FormState> _formKeyForLogin = GlobalKey<FormState>();
//   bool _isLoader = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _isLoader ? buildCircularProgressIndicator() : userLogin,
//       child: Container(
//         padding: EdgeInsets.all(25),
//         margin: EdgeInsets.symmetric(horizontal: 25),
//         decoration: BoxDecoration(
//           color: kScaffoldColor,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//             child: Text(
//           "Sign In",
//           style: GoogleFonts.ubuntu(
//             fontSize: 14.sp,
//             letterSpacing: 1.0,
//             fontWeight: FontWeight.w500,
//             color: kTextColor,
//           ),
//         )),
//       ),
//     );
//   }
// }

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
