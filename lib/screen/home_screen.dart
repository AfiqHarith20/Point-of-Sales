import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/data.dart';
import 'package:pointofsales/models/user_model.dart';
import 'package:pointofsales/screen/drawer_screen.dart';
import 'package:pointofsales/screen/product_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;
  // bool _isLoading = false;
  double discountPercentage = 10;
  double taxPercentage = 3;

  double calculateDiscount() {
    double total = calculateSubtotal();
    return (total * discountPercentage) / 100;
  }

  double calculateTax() {
    double total = calculateSubtotal();
    return (total * taxPercentage) / 100;
  }

  double calculateSubtotal() {
    double subtotal = 0;
    for (int index = 0; index < invoice().length; index++) {
      double price = double.parse(invoice()[index].price ?? "0");
      double quantity = double.parse(invoice()[index].quantity ?? "0");
      subtotal += price * quantity;
    }
    return subtotal;
  }

  double calculateTotal() {
    double subtotal = calculateSubtotal();
    double discount = calculateDiscount();
    double tax = calculateTax();
    return subtotal - discount + tax;
  }

  String selectedPayment = "Cash";
  List<String> paymentOptions = [
    "Cash",
    "Credit Card",
    "Debit Card",
    "TNG",
    "Online Payment",
  ];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.bars,
                color: kTextColor,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
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
            icon: FaIcon(
              FontAwesomeIcons.bell,
              color: Colors.white,
            ),
            onPressed: () {},
            tooltip: "Notifications Section",
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Form(
              child: Container(
                height: 60.h,
                margin: kMargin,
                padding: kPadding,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: kRadius,
                ),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(children: [
                        Text(
                          "Welcome Afiq Harith",
                          style: GoogleFonts.rubik(
                            fontSize: 14.sp,
                            color: kTextColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Product Code (SKU)",
                          style: GoogleFonts.abel(
                            fontSize: 10.sp,
                            color: kTextColor,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                          child: TextField(
                            // controller: ,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: kTextColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                    width: 3, color: Colors.greenAccent),
                              ),
                            ),
                            style: GoogleFonts.abel(
                              fontSize: 11.sp,
                              color: kScaffoldColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          "Quantity",
                          style: GoogleFonts.abel(
                            fontSize: 10.sp,
                            color: kTextColor,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                          child: TextField(
                            // controller: ,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: kTextColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                    width: 3, color: Colors.greenAccent),
                              ),
                            ),
                            style: GoogleFonts.abel(
                              fontSize: 11.sp,
                              color: kScaffoldColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: .5.h,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.greenAccent;
                                    return null;
                                  },
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Add",
                                style: GoogleFonts.manrope(
                                  fontSize: 8.sp,
                                  color: kTextColor,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.purpleAccent;
                                    return null;
                                  },
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Edit",
                                style: GoogleFonts.manrope(
                                  fontSize: 8.sp,
                                  color: kTextColor,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.red,
                          thickness: 2.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Discount",
                              style: GoogleFonts.aubrey(
                                fontWeight: FontWeight.w600,
                                color: kLabel,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              "\RM${calculateDiscount().toStringAsFixed(2)}",
                              style: GoogleFonts.breeSerif(
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tax",
                              style: GoogleFonts.aubrey(
                                fontWeight: FontWeight.w600,
                                color: kLabel,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              "\RM${calculateTax().toStringAsFixed(2)}",
                              style: GoogleFonts.breeSerif(
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: GoogleFonts.aubrey(
                                fontWeight: FontWeight.w600,
                                color: kLabel,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              "\RM${calculateTotal().toStringAsFixed(2)}",
                              style: GoogleFonts.breeSerif(
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment",
                              style: GoogleFonts.aubrey(
                                fontWeight: FontWeight.w600,
                                color: kLabel,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                            DropdownButton<String>(
                              dropdownColor: kPrimaryColor,
                              iconEnabledColor: kLabel,
                              value: selectedPayment,
                              items: paymentOptions
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  child: Text(
                                    value,
                                    style: GoogleFonts.breeSerif(
                                      fontWeight: FontWeight.w500,
                                      color: kTextColor,
                                      fontSize: 10.sp,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedPayment = newValue!;
                                });
                              },
                            )
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              height: 60.h,
              margin: kMargin,
              padding: kPadding,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: kRadius,
              ),
              child: SingleChildScrollView(),
            ),
          ),
        ],
      ),
    );
  }
}
