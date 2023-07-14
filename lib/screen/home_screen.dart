// ignore_for_file: cast_from_null_always_fails

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
import 'package:pointofsales/widget/progressIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final skuController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  int? merchantId, userId, taxid, payid, taxpercentage, status;
  String? userName,
      userEmail,
      companyName,
      customerId,
      posTxnNo,
      grossPrice,
      netPrice,
      remarks,
      taxname,
      payname,
      paymentTypes;
  dynamic taxId, taxAmount, discId, discAmount;
  late List<dynamic> products;
  late Future<User> _user;
  PaymentType? _selectedPaymentType;
  PaymentTax? _selectedPaymentTax;
  bool _isLoader = false;

  late Future<List<PaymentType>> _paymentType;
  late Payment type = Payment(
    paymentType: [],
    paymentTax: [],
  );
  late Future<List<PaymentTax>> _paymentTax;
  List<ItemsArray> searchResults = [];

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

  ///////////////////////// Payment Type //////////////////////////////////////////////////////////

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

  ////////////////////// Payment Tax //////////////////////////////////////////////////////

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
      throw Exception('Failed to fetch payment tax');
    }
  }

  ///////////////////////////// Fetch User //////////////////////////////////////////////////////////

Future<User> fetchUser() async{
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
      final user = User.fromJson(json);
      return user;
    } else {
      throw Exception('Failed to fetch user');
    }
}


  /////////////////////////// fetch Get and Post ////////////////////////////////////////

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
    if (response.statusCode == 200) {
      print("INDEX POS >>>>>>>>>>>>>>>>>>>>>");
      setState(() {
        isLoading = false;

        if (pos["data"] != null) {
          var userData = pos['data'][0]['user'];
          if (userData != null) {
            var data = User(
              userid: pos['data'][0]['user']['id'],
              username: pos['data'][0]['user']['name'].toString(),
              useremail: pos['data'][0]['user']['email'].toString(),
            );
            userId = data.userid;
            userName = data.username;
            userEmail = data.useremail;
            
          } else {
            print("User data is null");
          }

          Future<List<PaymentType>> _paymentType = fetchPaymentTypes();
          Future<List<PaymentTax>> _paymentTax = fetchPaymentTax();

          var paymentTaxId = pos["payment_type"]?["id"];
          if (paymentTaxId is int) {
            _paymentTax.then((paymentTax) {
              var parsedPaymentTaxId = paymentTaxId;
              var data = PaymentTax(
                id: parsedPaymentTaxId,
                name: pos['payment_tax']['name'].toString(),
                taxPercentage: pos['payment_tax']['tax_percentage'],
              );
              taxid = data.id;
              taxname = data.name;
              taxpercentage = data.taxPercentage;

              setState(() {
                _paymentTax = Future.value(paymentTax);
              });
            });

            _paymentType.then((paymentTypes) {
              var parsedPaymentTypeId = paymentTaxId;
              var data = PaymentType(
                id: parsedPaymentTypeId,
                name: pos["payment_type"]["name"].toString(),
              );
              payid = data.id;
              payname = data.name;

              setState(() {
                _paymentType = Future.value(paymentTypes);
              });
            });
          } else {
            // Handle the case when the value is not an integer or is null
            if (pos["payment_type"] == null) {
              print("Payment type data is null");
            } else {
              var idValue = pos["payment_type"]["id"];
              print("Invalid payment type ID: $idValue");
            }
          }

          print(paymentType);
        } else {
          print(response.reasonPhrase);
        }
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  /////////////// POST Request ////////////////////////////////

  Future<Map<String, dynamic>> _postSavePosTransaction() async {
    final url = Uri.parse(Constants.apiPosIndex);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final http.Response response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json',
      },
      body: {
       'customer_id': prefs.getString('customer_id'),
        'gross_price': prefs.getString('gross_price'),
        'tax_id': prefs.getString('tax_id'),
        'tax_amount': prefs.getString('tax_amount'),
        'disc_id': prefs.getString('disc_id'),
        'disc_amount': prefs.getString('disc_amount'),
        'net_price': prefs.getDouble('net_price'),
        'payment_type': paymentType.toString(),
        'remarks': prefs.getString('remarks'),
        'items_array': ItemsArray,
      },
    );
    
      final Map<String, dynamic> customer = json.decode(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      print("POS TRANSACTION SUCCESSFULLY SAVED");
      setState(() {
        isLoading = false;
        if (customer['data']['customer'] == null) {
          var data = Customer(
            id: customer['data']['customer']['id'],
            merchantId: customer['data']['customer']['merchant_id'],
            customerId: customer['data']['customer']['customer_id'],
            posTxnNo: customer['data']['customer']['pos_txn_no'],
            grossPrice: customer['data']['customer']['gross_price'],
            taxId: customer['data']['customer']['tax_id'],
            taxAmount: customer['data']['customer']['tax_amount'],
            discId: customer['data']['customer']['disc_id'],
            discAmount: customer['data']['customer']['disc_amount'],
            netPrice: customer['data']['customer']['net_price'].toDouble(),
            paymentTypes: customer['data']['customer']['payment_type'],
            remarks: customer['data']['customer']['remarks'],
            status: customer['data']['customer']['status'],
          );

          merchantId = data.merchantId;
          customerId = data.customerId;
          posTxnNo = data.posTxnNo;
          grossPrice = data.grossPrice;
          taxId = data.taxId;
          taxAmount = data.taxAmount;
          discId = data.discId;
          discAmount = data.discAmount;
          netPrice = data.netPrice;
          paymentTypes = data.paymentTypes;
          remarks = data.remarks;
        }
        });
      return responseData;
    } else {
      throw Exception('Failed to save POS transaction');
    }
  }
  ////////////////////////// Search SKU //////////////////////////////////////////////////

  Future<void> searchProduct() async {
    final url = Uri.parse(Constants.apiSearchProduct);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> requestBody = {
      "sku": skuController.text,
    };

    final http.Response response = await http.post(
      url,
      body: jsonEncode(requestBody),
      headers: {
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);

      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('data')) {
        final dynamic productData = responseData['data'];

        if (productData.containsKey('products') &&
            productData['products'] is Map<String, dynamic>) {
          final dynamic product = productData['products'];
          final ItemsArray result = ItemsArray(
            productId: product['id'].toString(),
            name: product['name'].toString(),
            quantity: quantityController.text.isNotEmpty
                ? quantityController.text
                : '1',
            price: product['price'].toString(),
          );

          setState(() {
            final existingProductIndex = searchResults.indexWhere(
              (item) => item.productId == result.productId,
            );
            if (existingProductIndex != -1) {
              // If the product already exists, update the quantity
              searchResults[existingProductIndex].quantity = result.quantity;
            } else {
              // If the product doesn't exist, add it to the search results
              searchResults.add(result);
            }
          });
        } else {
          print('Invalid product data');
        }
      } else {
        print('Invalid response format: $responseData');
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fetchPos();
    _paymentType = fetchPaymentTypes();
    _paymentTax = fetchPaymentTax();
    _user = fetchUser();
    
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
                        Column(children: [
                          Text(
                              "Welcome $userName",
                              style: GoogleFonts.rubik(
                                fontSize: 12.sp,
                                color: kTextColor,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.0,
                              ),
                            ),
                        ],
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
                            controller: skuController ,
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
                            controller: quantityController,
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
                              onPressed: () => _isLoader ? buildCircularProgressIndicator() : searchProduct(),
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
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              "ID",
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
                              "Name",
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
                                fontSize: 11.sp,
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
                                fontSize: 10.sp,
                                letterSpacing: 1.0,
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
                              result.productId,
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
                              result.price,
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
                              result.quantity,
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
                              '',
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
