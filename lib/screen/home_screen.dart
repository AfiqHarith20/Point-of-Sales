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
  int? merchantId, userId, payid, status;
  String? userName,
      userEmail,
      companyName,
      customerId,
      posTxnNo,
      grossPrice,
      netPrice,
      remarks,
      payname,
      paymentTypes;
  dynamic taxId, taxAmount, discId, discAmount;
  late List<dynamic> products;
  // late List<PaymentType> paymentTypeName;
  // late List<PaymentTax> paymentTax, paymentTaxPercent, paymentTaxName;
  PaymentType? _selectedPaymentType;
  PaymentTax? _selectedPaymentTax;

  late Future<List<PaymentType>> _paymentType;
  late Payment type = Payment(
    paymentType: [],
    paymentTax: [],
  );
  late Future<List<PaymentTax>> _paymentTax;

  List<PaymentType> paymentType = [];
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

  Future<List<PaymentType>> fetchPaymentTypes() async {
    final url = Uri.parse(Constants.apiPosIndex);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.get(
      url,
      headers: ({
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json'
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final payType = Payment.fromJson(json);
      return payType.paymentType;

    } else {
      throw Exception('Failed to fetch payment types');
    }
  }

  Future<List<PaymentTax>> fetchPaymentTax() async {
    final url = Uri.parse(Constants.apiPosIndex);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.get(
      url,
      headers: ({
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json'
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final payTax = Payment.fromJson(json);
      return payTax.paymentTax;
    } else {
      throw Exception('Failed to fetch payment types');
    }
  }

  /////////////////////////// fetch Get and Post //////////////////////////

  void fetchPos() async {
    final url = Uri.parse(Constants.apiPosIndex);

    //GET Request
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.get(
      url,
      headers: ({
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json'
      }),
    );
    print(response.statusCode);
    final Map<String, dynamic> pos = json.decode(response.body);
    final List<dynamic> paymentTypesData = pos['payment_type'];
    final List<dynamic> paymentTaxData = pos['payment_tax'];
    if (response.statusCode == 200) {
      print("INDEX POS >>>>>>>>>>>>>>>>>>>>>");
      setState(() {
        isLoading = false;

        if (pos["data"] == null) {
          Future<List<PaymentType>> _paymentType = fetchPaymentTypes();
          Future<List<PaymentTax>> _paymentTax = fetchPaymentTax();

          _paymentTax.then((paymentTax) {
            var data = PaymentTax(
              id: pos['payment_tax']['id'],
              name: pos['payment_tax']['name'],
              taxPercentage: pos['payment_tax']['tax_percentage'],
            );
          });

          _paymentType.then((paymentTypes) {
            var data = PaymentType(
              id: pos["payment_type"]["id"],
              name: pos["payment_type"]["name"],
            );
            payid = data.id;
            payname = data.name;

            setState(() {
              _paymentType = Future.value(paymentTypes);
            });
          });

          print(paymentType);
        } else {
          print(response.reasonPhrase);
        }
      });
    } else {
      print(response.reasonPhrase);
    }

    //POST Request
    //   SharedPreferences prefern = await SharedPreferences.getInstance();
    //   final http.Response res = await http.post((url),
    //   body: ({
    //     'customer_id': prefs.getString('customer_id'),
    //     'gross_price': prefs.getString('gross_price'),
    //     'tax_id': prefs.getString('tax_id'),
    //     'tax_amount': prefs.getString('tax_amount'),
    //     'disc_id': prefs.getString('disc_id'),
    //     'disc_amount': prefs.getString('disc_amount'),
    //     'net_price': prefs.getDouble('net_price'),
    //     'payment_type': paymentType.toString(),
    //     'remarks': prefs.getString('remarks'),
    //     'items_array': ItemsArray,
    //   }),
    //   );

    //   final Map<String, dynamic> customer = json.decode(response.body);

    //   if (response.statusCode == 200) {
    //   print("POS TRANSACTION SUCCESSFULLY SAVED");
    //   setState(() {
    //     isLoading = false;
    //     if (customer['data']['customer'] == null) {
    //       var data = Customer(
    //         id: customer['data']['custom']['id'],
    //         merchantId: customer['data']['customer']['merchant_id'],
    //         customerId: customer['data']['customer']['customer_id'],
    //         posTxnNo: customer['data']['customer']['pos_txn_no'],
    //         grossPrice: customer['data']['customer']['gross_price'],
    //         taxId: customer['data']['customer']['tax_id'],
    //         taxAmount: customer['data']['customer']['tax_amount'],
    //         discId: customer['data']['customer']['disc_id'],
    //         discAmount: customer['data']['customer']['disc_amount'],
    //         netPrice: customer['data']['customer']['net_price'].toDouble(),
    //         paymentTypes: customer['data']['customer']['payment_type'],
    //         remarks: customer['data']['customer']['remarks'],
    //         status: customer['data']['customer']['status'],
    //       );

    //       id = data.id;
    //       merchantId = data.merchantId;
    //       customerId = data.customerId;
    //       posTxnNo = data.posTxnNo;
    //       grossPrice = data.grossPrice;
    //       taxId = data.taxId;
    //       taxAmount = data.taxAmount;
    //       discId = data.discId;
    //       discAmount = data.discAmount;
    //       netPrice = data.netPrice;
    //       paymentTypes = data.paymentTypes;
    //       remarks = data.remarks;
    //     }
    //   });
    // } else {
    //   print(response.reasonPhrase);
    // }
    return;
  }

  // Future fetchSavePostTransaction() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   isLoading = true;

  //   var dataFromResponse = await _postSavePosTransaction();
  //   dataFromResponse['data']['items_array'].forEach((newItems) {
  //     List<ItemsArray> itemsArray = [];
  //     itemsArray.add(
  //       new ItemsArray(
  //       productId: newItems['product_id'].toString(),
  //       quantity: newItems['quantity'],
  //       price: newItems['price'],
  //     )
  //     );
  //   });

  // }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fetchPos();
    _paymentType = fetchPaymentTypes();
    _paymentTax = fetchPaymentTax();
    
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
            flex: 3,
            child: Form(
              child: Container(
                height: 65.h,
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
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kTextColor,
                                ),
                                width: 32.w,
                                height: 4.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 15,
                                ),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return FutureBuilder<List<PaymentTax>>(
                                    future: _paymentTax,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton<PaymentTax>(
                                          icon: FaIcon(
                                            FontAwesomeIcons.chevronDown,
                                            size: 15,
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                          isExpanded: true,
                                          hint: Text(
                                            "Select Tax Type",
                                            style: TextStyle(
                                              color: kHint,
                                              fontSize: 6.5.sp,
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          items: [
                                            ...snapshot.data!.map(
                                              (tax) => DropdownMenuItem(
                                                value: tax,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${tax.name}',
                                                      style: TextStyle(
                                                        color: kForm,
                                                        fontSize: 5.sp,
                                                        letterSpacing: 1.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                          onChanged: (type) {
                                            setState(() {
                                              _selectedPaymentTax = type;
                                            });
                                          },
                                          value: _selectedPaymentTax,
                                        ),
                                      );
                                    },
                                  );
                                })),
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
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kTextColor,
                              ),
                              width: 32.w,
                              height: 4.h,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15,
                              ),
                              child: LayoutBuilder(builder: (context, constraints) {
                                return FutureBuilder<List<PaymentType>>(
                                future: _paymentType,
                                builder: (context, snapshot) {
                                  if(snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton<PaymentType>(
                                      icon: FaIcon(
                                        FontAwesomeIcons.chevronDown,
                                        size: 15,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      isExpanded: true,
                                      hint: Text(
                                        "Select Payment Type",
                                        style: TextStyle(
                                          color: kHint,
                                          fontSize: 6.5.sp,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      items: [
                                        ...snapshot.data!.map((type) =>
                                            DropdownMenuItem(
                                              value: type,
                                              child: Row(
                                              children: [
                                                Text('${type.name}',
                                                style: TextStyle(
                                                      color: kForm,
                                                      fontSize: 5.sp,
                                                      letterSpacing: 1.0,
                                                      fontWeight: FontWeight.w600,
                                                    ),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                      onChanged: (type) {
                                        setState(() {
                                          _selectedPaymentType = type;
                                        });
                                      },
                                      value: _selectedPaymentType,
                                    ),
                                  );
                                },
                              );
                              })
                            ),
                            
                          ],
                        ),
                        
                        SizedBox(
                          height: 1.h,
                        ),
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
            flex: 4,
            child: Container(
              height: 65.h,
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
                      ]),
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
