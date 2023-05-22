import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/data.dart';
import 'package:pointofsales/widget/bottom_nav.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DASHBOARD",
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
              child: SizedBox(
                height: 36.h,
                child: _head(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Divider(
                    //   color: Colors.blueAccent,
                    //   height: 10,
                    // ),
                    Text(
                      "Last Transaction",
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w600,
                        color: kTextColor,
                        fontSize: 16.sp,
                        letterSpacing: 2.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: FaIcon(
                        FontAwesomeIcons.chevronRight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    title: Text(
                      transaction()[index].transactionId,
                      style: GoogleFonts.breeSerif(
                        fontWeight: FontWeight.w600,
                        color: kTextColor,
                        fontSize: 12.sp,
                        letterSpacing: 2.0,
                      ),
                    ),
                    trailing: Text(
                      transaction()[index].time,
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w500,
                        color: kTextColor,
                        fontSize: 12.sp,
                        letterSpacing: 2.0,
                      ),
                    ),
                  );
                },
                childCount: transaction().length,
              ),
            ),
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         // Divider(
            //         //   color: Colors.blueAccent,
            //         //   height: 10,
            //         // ),
            //         Text(
            //           "You Items",
            //           style: GoogleFonts.aubrey(
            //             fontWeight: FontWeight.w600,
            //             color: kTextColor,
            //             fontSize: 16.sp,
            //             letterSpacing: 2.0,
            //           ),
            //         ),
            //         Text(
            //           "Price",
            //           style: GoogleFonts.aubrey(
            //             fontWeight: FontWeight.w600,
            //             color: kTextColor,
            //             fontSize: 16.sp,
            //             letterSpacing: 2.0,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SliverList(
            //   delegate: SliverChildBuilderDelegate(
            //     (context, index) {
            //       return ListTile(
            //         leading: ClipRRect(
            //           borderRadius: BorderRadius.circular(5),
            //         ),
            //         title: Text(
            //           items()[index].itemnames,
            //           style: GoogleFonts.breeSerif(
            //             fontWeight: FontWeight.w600,
            //             color: kTextColor,
            //             fontSize: 12.sp,
            //             letterSpacing: 2.0,
            //           ),
            //         ),
            //         trailing: Text(
            //           items()[index].price,
            //           style: GoogleFonts.aubrey(
            //             fontWeight: FontWeight.w500,
            //             color: kTextColor,
            //             fontSize: 12.sp,
            //             letterSpacing: 2.0,
            //           ),
            //         ),
            //       );
            //     },
            //     childCount: items().length,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 25.h,
              decoration: BoxDecoration(
                color: Color(0xFF4A84C7),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back!",
                          style: GoogleFonts.aubrey(
                            fontWeight: FontWeight.w500,
                            color: kTextColor,
                            fontSize: 12.sp,
                            letterSpacing: 2.0,
                          ),
                        ),
                        Text(
                          "Afiq Harith",
                          style: GoogleFonts.breeSerif(
                            fontWeight: FontWeight.w600,
                            color: kTextColor,
                            fontSize: 16.sp,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: kMargin,
              padding: kPadding,
              height: 7.h,
              width: 32.w,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(47, 125, 121, 0.3),
                    offset: Offset(0, 6),
                    blurRadius: 12,
                    spreadRadius: 6,
                  ),
                ],
                color: kPrimaryColor,
                borderRadius: kRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Expense",
                    style: GoogleFonts.abel(
                      fontSize: 14.sp,
                      color: kTextColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Icon(
                    Icons.arrow_downward_sharp,
                    color: kTextColor,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 50,
          right: 50,
          child: Container(
            height: 20.h,
            width: 40.w,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(47, 125, 121, 0.3),
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 6,
                ),
              ],
              color: Color.fromARGB(255, 47, 125, 121),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Your Income",
                        style: GoogleFonts.aubrey(
                          fontWeight: FontWeight.w600,
                          color: kTextColor,
                          fontSize: 12.sp,
                          letterSpacing: 1.0,
                        ),
                      ),
                      // Icon(
                      //   Icons.more_horiz_outlined,
                      //   color: Colors.white,
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "\RM 3,759.90",
                        style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                          fontSize: 14.sp,
                          letterSpacing: 1.0,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(
                              Icons.arrow_downward_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Your Transactions",
                            style: GoogleFonts.aubrey(
                              fontWeight: FontWeight.w600,
                              color: kTextColor,
                              fontSize: 16.sp,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    children: [
                      Text(
                        "325",
                        style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                          fontSize: 16.sp,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "View Report",
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w600,
                        color: kTextColor,
                        fontSize: 12.sp,
                        letterSpacing: 1.0,
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
