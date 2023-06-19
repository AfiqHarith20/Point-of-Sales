import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/api/api.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/data.dart';
import 'package:pointofsales/models/pos_model.dart';
import 'package:pointofsales/models/user_model.dart';
import 'package:pointofsales/screen/drawer_screen.dart';
import 'package:pointofsales/screen/product_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;
  int? merchantId, userId;
  String? userName, userEmail, companyName;
  late List<dynamic> products;
  late List<PaymentType> paymentType, paymentTypeName;
  late List<PaymentTax> paymentTax, paymentTaxPercent, paymentTaxName;
  bool isLoading = true;
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

  Future<void> _getIndexPos() async {
    try{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final http.Response response = await http.get(
        Uri.parse(Constants.apiPosIndex),
        headers: ({
          'Authorization': 'Bearer ' + prefs.getString('token').toString(),
          'Content-Type': 'application/json'
        }),
      );
      final Map<String, dynamic> pos = json.decode(response.body);
      if(response.statusCode == 200) {
        print("INDEX POS >>>>>>>>>>>>>>>>>>>>>");
        setState(() {
          isLoading = false;

          if(pos["data"] == null) {
            var data = Pos (
              merchantId: pos["data"]["merchant_id"],
              userId: pos["data"]["user_id"],
              userName: pos["data"]["user"]["name"].toString(),
              userEmail: pos["data"]["user"]["email"].toString(),
              companyName: pos["data"]["merchant"]["company_name"].toString(),
              products: pos["data"]["products"],
              paymentType:  pos["data"]["payment_type"]["id"],
              paymentTypeName:  pos["data"]["payment_type"]["name"],
              paymentTax: pos["data"]["payment_tax"]["id"],
              paymentTaxName: pos["data"]["payment_tax"]["name"],
              paymentTaxPercent: pos["data"]["payment_tax"]["tax_percentage"]
            );

            merchantId = data.merchantId;
          }
        });
      }

    }catch (e) {

    }
  }

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
                            fontSize: 12.sp,
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
                                fontSize: 11.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              "\RM${calculateDiscount().toStringAsFixed(2)}",
                              style: GoogleFonts.breeSerif(
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                                fontSize: 11.sp,
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
                                fontSize: 11.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              "\RM${calculateTax().toStringAsFixed(2)}",
                              style: GoogleFonts.breeSerif(
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                                fontSize: 11.sp,
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
                                fontSize: 11.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              "\RM${calculateTotal().toStringAsFixed(2)}",
                              style: GoogleFonts.breeSerif(
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                                fontSize: 11.sp,
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
                                fontSize: 11.sp,
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
                            ),
                            
                          ],
                        ),
                        SizedBox(height: 1.h,),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            "CHECKOUT",
                            style: GoogleFonts.ubuntu(
                              fontSize: 14.sp,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
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
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(color: Colors.transparent),
                  columnWidths: {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                                "Product Name",
                                style: GoogleFonts.aubrey(
                                  fontWeight: FontWeight.w600,
                                  color: kLabel,
                                  fontSize: 12.sp,
                                  letterSpacing: 1.0,
                                ),
                            ),
                          ),
                          ),
                          TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              "Price (MYR)",
                              style: GoogleFonts.aubrey(
                                fontWeight: FontWeight.w600,
                                color: kLabel,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              "Quantity",
                              style: GoogleFonts.aubrey(
                                fontWeight: FontWeight.w600,
                                color: kLabel,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              "Subtotal (MYR)",
                              style: GoogleFonts.aubrey(
                                fontWeight: FontWeight.w600,
                                color: kLabel,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (int index = 0; index < invoice().length; index++)
                      TableRow(children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              invoice()[index].prodname ?? "",
                              style: GoogleFonts.breeSerif(
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              invoice()[index].price ?? "",
                              style: GoogleFonts.breeSerif(
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              invoice()[index].quantity ?? "",
                              style: GoogleFonts.breeSerif(
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              (double.parse(invoice()[index].price ?? "0") *
                                      double.parse(
                                          invoice()[index].quantity ?? "0"))
                                  .toStringAsFixed(2),
                              style: GoogleFonts.breeSerif(
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                                fontSize: 12.sp,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
