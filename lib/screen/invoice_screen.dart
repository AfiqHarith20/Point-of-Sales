import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/data.dart';
import 'package:pointofsales/screen/home_screen.dart';
import 'package:pointofsales/screen/product_screen.dart';
import 'package:sizer/sizer.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: kTextColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
            );
          },
        ),
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
            icon: FaIcon(
              FontAwesomeIcons.bell,
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
                        color: kLabel,
                        fontSize: 16.sp,
                        letterSpacing: 2.0,
                      ),
                    ),
                    Text(
                      "Date",
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w600,
                        color: kLabel,
                        fontSize: 16.sp,
                        letterSpacing: 2.0,
                      ),
                    ),
                    Text(
                      "Customer",
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w600,
                        color: kLabel,
                        fontSize: 16.sp,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          invoice()[index].orderId ?? "",
                          style: GoogleFonts.breeSerif(
                            fontWeight: FontWeight.w500,
                            color: kTextColor,
                            fontSize: 12.sp,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          invoice()[index].date ?? "",
                          style: GoogleFonts.breeSerif(
                            fontWeight: FontWeight.w500,
                            color: kTextColor,
                            fontSize: 12.sp,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          invoice()[index].custusr ?? "",
                          style: GoogleFonts.breeSerif(
                            fontWeight: FontWeight.w500,
                            color: kTextColor,
                            fontSize: 12.sp,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: invoice().length,
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(
                color: Colors.redAccent,
                thickness: 1.0,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
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
                                  fontSize: 14.sp,
                                  letterSpacing: 2.0,
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
                                  fontSize: 14.sp,
                                  letterSpacing: 2.0,
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
                                  fontSize: 14.sp,
                                  letterSpacing: 2.0,
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
                                  fontSize: 14.sp,
                                  letterSpacing: 2.0,
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
                        ]),
                    ]),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductScreen(), // Replace ProductPage with the actual product page widget
                      ),
                    );
                  },
                  child: Text(
                    "Add Product",
                    style: GoogleFonts.aubrey(
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 231, 96, 96),
                      fontSize: 14.sp,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Divider(
                color: Colors.redAccent,
                thickness: 1.0,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Discount",
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w600,
                        color: kLabel,
                        fontSize: 14.sp,
                        letterSpacing: 2.0,
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
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tax",
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w600,
                        color: kLabel,
                        fontSize: 14.sp,
                        letterSpacing: 2.0,
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
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w600,
                        color: kLabel,
                        fontSize: 14.sp,
                        letterSpacing: 2.0,
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
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment",
                      style: GoogleFonts.aubrey(
                        fontWeight: FontWeight.w600,
                        color: kLabel,
                        fontSize: 14.sp,
                        letterSpacing: 2.0,
                      ),
                    ),
                    DropdownButton<String>(
                      dropdownColor: kPrimaryColor,
                      iconEnabledColor: kLabel,
                      value: selectedPayment,
                      items: paymentOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          child: Text(
                            value,
                            style: GoogleFonts.breeSerif(
                              fontWeight: FontWeight.w500,
                              color: kTextColor,
                              fontSize: 12.sp,
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
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    "CHECKOUT",
                    style: GoogleFonts.ubuntu(
                      fontSize: 16.sp,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
