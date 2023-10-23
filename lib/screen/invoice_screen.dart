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
import 'package:pointofsales/screen/product/add_product_dialog.dart';
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

Future<void> _refreshPage() async {
    try {
      setState(() {
        isLoading = true; // Set isLoading to true before making the API call
      });

      final responseData = await _postPaymentTransaction(widget.posId);

      // Update the state with the new data
      setState(() {
        isLoading = false; // Set isLoading to false after data is fetched
        // Update other relevant variables here based on the responseData
      });
    } catch (error) {
      print("Error refreshing page: $error");
      // Handle the error appropriately
      setState(() {
        isLoading = false; // Set isLoading to false if an error occurs
      });
    }
  }

  /////////////// POST Request ////////////////////////////////

  Future<void> _postPaymentTransaction(int posId) async {
    final url = Uri.parse(Constants.apiPosPayment);

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final Map<String, dynamic> requestBody = {
        'pos_id': posId,
      };

      print("Request Body: ${jsonEncode(requestBody)}"); // Print request body

      final http.Response response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ' + prefs.getString('token').toString(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> posTransData =
            responseData['data']['pos_trans'][0];

        final customerEmail = posTransData['cust_email'];
        final paymentTypes = posTransData['payment_type']['name'];
        final products = posTransData['pos_details'];
        final netPrices = posTransData['net_price'];
        final merchant = posTransData['merchant'];

        // Calculate discount, tax, and other fields as needed

        final updatedSearchResults = products
            .map<ItemsArray>((product) => ItemsArray(
                  name: product['product']['name'],
                  price: product['price'],
                  quantity: product['quantity'],
                  productId: product['product_id'],
                ))
            .toList();

        setState(() {
          isLoading = false;
          custEmail = customerEmail;
          searchResults = updatedSearchResults;
          paymentType = paymentTypes;
          netPrice = netPrices;
          merchantId = merchant['id'];
        });
      } else {
        print(
            "Failed to fetch POS transaction. Response status code: ${response.statusCode}");
        throw Exception('Failed to fetch POS transaction');
      }
    } catch (error) {
      print("Error fetching POS transaction: $error");
      throw Exception('Failed to fetch POS transaction');
    }
  }

@override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshPage();
  }
@override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kContainer,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: kTextColor,
              ),
              onPressed: () {
                Navigator.pop(context); // Navigate back to HomeScreen
              },
            );
          },
        ),
        centerTitle: true,
        title: Text(
          "INVOICE",
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w500,
            color: kTextColor,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.circleXmark,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
            },
            tooltip: "Delete Section",
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
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: kLabel,
                              fontSize: 14.sp,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Text(
                            "Date",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: kLabel,
                              fontSize: 14.sp,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Text(
                            "Customer",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: kLabel,
                              fontSize: 14.sp,
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
                    if (isLoading) {
                      // Show circular progress indicator when loading
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }else {
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
                                  custEmail ?? 'null',
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
                    }
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
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: kLabel,
                                  fontSize: 12.sp,
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
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: kLabel,
                                  fontSize: 12.sp,
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
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: kLabel,
                                  fontSize: 12.sp,
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
                                  fontSize: 10.sp,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                result.price != null
                                    ? "RM ${double.tryParse(result.price)?.toStringAsFixed(2) ?? '0.00'}"
                                    : "RM 0.00",
                                style: GoogleFonts.breeSerif(
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor,
                                  fontSize: 10.sp,
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
                                  fontSize: 10.sp,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                (double.parse(result.price) *
                                        double.parse(result.quantity ?? "0"))
                                    .toStringAsFixed(2),
                                style: GoogleFonts.breeSerif(
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor,
                                  fontSize: 10.sp,
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
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 15),
              //     child: TextButton(
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) =>
              //                 AddPoductDialogContent(
              //                   posId: widget
              //                       .posId) // Replace ProductPage with the actual product page widget
              //           ),
              //         );
              //       },
              //       child: Text(
              //         "Add Product",
              //         style: GoogleFonts.aubrey(
              //           fontWeight: FontWeight.w600,
              //           color: Color.fromARGB(255, 231, 96, 96),
              //           fontSize: 14.sp,
              //           letterSpacing: 2.0,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: Divider(
                  color: Colors.redAccent,
                  thickness: 1.0,
                ),
              ),
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           "Discount",
              //           style: GoogleFonts.aubrey(
              //             fontWeight: FontWeight.w600,
              //             color: kLabel,
              //             fontSize: 14.sp,
              //             letterSpacing: 2.0,
              //           ),
              //         ),
              //         Text(
              //           "\RM $discAmount",
              //           style: GoogleFonts.breeSerif(
              //             fontWeight: FontWeight.w500,
              //             color: kTextColor,
              //             fontSize: 12.sp,
              //             letterSpacing: 1.0,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //           "Tax",
              //           style: GoogleFonts.aubrey(
              //             fontWeight: FontWeight.w600,
              //             color: kLabel,
              //             fontSize: 14.sp,
              //             letterSpacing: 2.0,
              //           ),
              //         ),
              //         Text(
              //           "\RM $taxAmount",
              //           style: GoogleFonts.breeSerif(
              //             fontWeight: FontWeight.w500,
              //             color: kTextColor,
              //             fontSize: 12.sp,
              //             letterSpacing: 1.0,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: kLabel,
                          fontSize: 12.sp,
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        netPrice != null
                            ? "RM ${double.tryParse(netPrice!)?.toStringAsFixed(2) ?? '0.00'}"
                            : "RM 0.00",
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
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: kLabel,
                          fontSize: 12.sp,
                          letterSpacing: 2.0,
                        ),
                      ),
                      Text(
                        paymentType ??
                            'null', // Use the paymentTypes variable directly
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
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: kSecondaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      "CHECKOUT",
                      style: GoogleFonts.ubuntu(
                        fontSize: 16.sp,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                        color: kTextColor,
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
