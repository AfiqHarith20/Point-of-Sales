import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/api/api.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/data.dart';
import 'package:pointofsales/models/invoice_model.dart';
import 'package:pointofsales/models/pos_model.dart';
import 'package:pointofsales/screen/home_screen.dart';
import 'package:pointofsales/screen/product_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class InvoiceScreen extends StatefulWidget {
  final int posId;

  InvoiceScreen({required this.posId});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  int? id;
  String? discAmount,
      taxAmount,
      taxId,
      isReceipt,
      merchantId,
      paymentType,
      posTxnNo,
      grossPrice,
      customerId,
      netPrice,
      remarks,
      custEmail;
  dynamic discId;
  bool isLoading = true;
  double discountPercentage = 10;
  double taxPercentage = 3;

  List<ItemsArray> searchResults = [];

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

Future<void> _refreshPage() async {
    try {
      final responseData = await _postPaymentTransaction(widget.posId);

      // Update the state with the new data
      setState(() {
        isLoading = false;
        // Update other relevant variables here based on the responseData
      });
    } catch (error) {
      print("Error refreshing page: $error");
      // Handle the error appropriately
    }
  }



  /////////////// POST Request ////////////////////////////////

Future<Map<String, dynamic>> _postPaymentTransaction(int posId) async {
    final url = Uri.parse(Constants.apiPosPayment + '${widget.posId}'); // Use posId

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ' + prefs.getString('token').toString(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pos_id': widget.posId, // Use posId
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String customerEmail = responseData['data']['pos_trans']['cust_email'];

        print("POS TRANSACTION PAYMENT");
        print("Response Data: $responseData");

        setState(() {
          isLoading = false;
          custEmail = customerEmail; 
        });

        return responseData;
      } else {
        print(
            "Failed to save POS transaction. Response status code: ${response.statusCode}");
        throw Exception('Failed to save POS transaction');
      }
    } catch (error) {
      print("Error saving POS transaction: $error");
      throw Exception('Failed to save POS transaction');
    }
  }

void initState() {
  super.initState();
  _refreshPage(); // Call the method to fetch data using posId
}
@override
  void dispose() {
    
    super.dispose();
  }

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
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.0),
                      1: FlexColumnWidth(1.0),
                      2: FlexColumnWidth(2.0),
                    },
                    children: [
                      TableRow(
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
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final currentDate = DateTime.now();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1.0),
                          1: FlexColumnWidth(1.0),
                          2: FlexColumnWidth(2.0),
                        },
                        children: [
                          TableRow(
                            children: [
                              Text(
                                "${widget.posId}",
                                style: GoogleFonts.breeSerif(
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor,
                                  fontSize: 12.sp,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                DateFormat('yyyy-MM-dd').format(currentDate),
                                style: GoogleFonts.breeSerif(
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor,
                                  fontSize: 12.sp,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                custEmail ?? '',
                                style: GoogleFonts.breeSerif(
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor,
                                  fontSize: 12.sp,
                                  letterSpacing: 1.0,
                                ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
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
                      for (final result in searchResults)
                        TableRow(children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                result.name,
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
                                result.price ?? "",
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
                                result.quantity ?? "",
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
                                (double.parse(result.price ?? "0") *
                                        double.parse(result.quantity ?? "0"))
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
                    ],
                  ),
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
      ),
    );
  }
}
