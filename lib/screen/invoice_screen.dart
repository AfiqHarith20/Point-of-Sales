import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/constant.dart';
import 'package:sizer/sizer.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "INVOICE",
          style: GoogleFonts.ubuntu(
            fontSize: 16.sp,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w500,
            color: kTextColor,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {},
            tooltip: "Notifications Section",
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order",
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w600,
                        color: kTextColor,
                        fontSize: 16.sp,
                        letterSpacing: 2.0,
                      ),
                    ),
                    Text(
                      "Date",
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w600,
                        color: kTextColor,
                        fontSize: 16.sp,
                        letterSpacing: 2.0,
                      ),
                    ),
                    Text(
                      "Customer",
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w600,
                        color: kTextColor,
                        fontSize: 16.sp,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(),
          ],
        ),
      ),
    );
  }
}
