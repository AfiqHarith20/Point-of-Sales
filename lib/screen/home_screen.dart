// ignore_for_file: cast_from_null_always_fails, unrelated_type_equality_checks, unnecessary_null_comparison

import 'dart:convert';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:pointofsales/models/category_model.dart';
import 'package:pointofsales/models/invoice_model.dart';
import 'package:pointofsales/screen/invoice_screen.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/api/api.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/pos_model.dart';
import 'package:pointofsales/models/user_model.dart';
import 'package:pointofsales/screen/drawer_screen.dart';
import 'package:pointofsales/screen/product_screen.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
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
  final custEmailController = TextEditingController();
  int quantity = 1;
  final TextEditingController quantityController = TextEditingController();
  int? merchantId,
      userId,
      catId,
      taxid,
      payid,
      taxpercentage,
      status,
      discountId,
      customerId,
      isReceipt;
  String? userName,
      catName,
      userEmail,
      companyName,
      posTxnNo,
      remarks,
      taxname,
      payname,
      paymentTypes,
      selectedPayment,
      customerEmail;
  double? grossPrice, netPrice, discountAmount;
  dynamic taxId, taxAmount, discId, discAmount;
  late String selectedCategory = "Food & Beverages";
  bool isInitialLoading = true;
  late Future<User> _user;
  late List<String> categoryNames = [];
  late List<Category> categories;
  List<Product> productListState = [];
  late Future<List<String>> _prodCategory;
  PaymentType? _selectedPaymentType;
  PaymentTax? _selectedPaymentTax;
  bool _isLoader = false;
  double total = 0;
  bool isCustomerFound = false;
  bool isChecked = false;
  bool isDisabled = false;
  MSHCheckboxStyle style = MSHCheckboxStyle.stroke;

  Category? selectedCategoryData;
  List<ProductList> productList = [];
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
    // Check if user is registered and has valid email
    if (custEmailController.text.isNotEmpty &&
        isValidEmail(custEmailController.text)) {
      // Apply discount logic for registered users
      return 10.0; // For example, 10% discount for registered users
    } else {
      // No discount for unregistered users
      return 0.0;
    }
  }

  bool isValidEmail(String email) {
    // You can use a regular expression or any other validation method to check email validity
    // Return true if the email is valid, otherwise false
    // Example validation using regular expression:
    return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(email);
  }

double calculateTax() {
    double netPrice = calculateSubtotal();
    num taxPercentage =
        _selectedPaymentTax != null ? _selectedPaymentTax!.taxPercentage : 0;
    return (netPrice * taxPercentage) / 100;
  }

  double calculateSubtotal() {
    double netPrice = 0;
    for (final item in searchResults) {
      double price = double.parse(item.price);
      double quantity = double.parse(item.quantity ?? '0');
      netPrice += price * quantity;
    }
    return netPrice;
  }

 double calculateTotal() {
    double netPrice = calculateSubtotal();
    double discount = calculateDiscount();
    double tax =
        calculateTax(); // Calculate the tax based on the selected tax percentage
    return netPrice + tax; // Add the tax to the subtotal to get the total
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

  Future<User> fetchUser() async {
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

////////////////////////////// Fetch Product Category ////////////////////////////////////////

  Future<List<String>> fetchCategoryNames() async {
    final url = Uri.parse(Constants.apiListCategory);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> categoryList = json['data']['category'];

      final List<String> categoryNames = categoryList
          .map((categoryData) => categoryData['name'].toString().trim())
          .toList();

      print('Category names from JSON: $categoryNames');

      return categoryNames;
    } else {
      throw Exception('Failed to fetch category names');
    }
  }

Future<List<Product>> fetchProductsForCategory(String category) async {
    final url = Uri.parse(Constants.apiPosIndex);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> pos = json.decode(response.body);
      final List<dynamic> productListData = pos['data'][0]['products'];

      // Filter products based on the selected category name
      List<Product> productList = productListData
          .where((productData) => productData['category']['name'] == category)
          .map((productData) => Product.fromJson(productData))
          .toList();

      return productList;
    } else {
      // Return an empty list if there's an error fetching products
      print('Failed to fetch products from API');
      return [];
    }
  }


  Future<void> _fetchProductList(String selectedCategoryName) async {
    try {
      List<Product> productList =
          await fetchProductsForCategory(selectedCategoryName);

      setState(() {
        selectedCategory = selectedCategoryName;
        productListState =
            productList; // Set the productListState to the fetched product list
        isLoading = false;
      });
    } catch (e) {
      // Handle any errors that might occur during API call
      setState(() {
        isLoading = false;
      });
      print('Error fetching product list: $e');
    }
  }

///////////////////////////// fetch Get and Post ////////////////////////////////////////

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
  if (response.statusCode == 200) {
    final Map<String, dynamic> pos = json.decode(response.body);
    print("INDEX POS >>>>>>>>>>>>>>>>>>>>>");
    // print(response.body);

    setState(() {
      isLoading = false;

      /////////////////////////// User ////////////////////////////////////

      final userData = pos['data'][0]['user'];
      if (userData != null) {
        final user = User(
          userid: userData['id'],
          username: userData['fullname'].toString(),
          useremail: userData['email'].toString(),
        );
        userId = user.userid;
        userName = user.username;
        userEmail = user.useremail;
      } else {
        print("User data is null");
      }

      ///////////////////// Payment Type and Tax ////////////////////////////////

      _parsePaymentTypeAndTax(pos);

      // Rest of your code...
    });
  } else {
    print(response.reasonPhrase);
  }
}

void _parsePaymentTypeAndTax(Map<String, dynamic> pos) {
    final paymentTypeDataList = pos['payment_type'];
    final paymentTaxDataList = pos['payment_tax'];

    if (paymentTypeDataList != null && paymentTypeDataList is List) {
      final List<PaymentType> paymentTypes = [];
      for (var paymentTypeData in paymentTypeDataList) {
        final paymentType = PaymentType.fromJson(paymentTypeData);
        paymentTypes.add(paymentType);
      }
      // ... handle paymentTypes list ...
    } else {
      print("Payment type data is null or not a List");
    }

    if (paymentTaxDataList != null && paymentTaxDataList is List) {
      final List<PaymentTax> paymentTaxes = [];
      for (var paymentTaxData in paymentTaxDataList) {
        final paymentTax = PaymentTax.fromJson(paymentTaxData);
        paymentTaxes.add(paymentTax);
      }
      // ... handle paymentTaxes list ...
    } else {
      print("Payment tax data is null or not a List");
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
              int currentQuantity = int.parse(
                  searchResults[existingProductIndex].quantity ?? '0');
              int newQuantity =
                  currentQuantity + int.parse(quantityController.text);
              searchResults[existingProductIndex].quantity =
                  newQuantity.toString();
            } else {
              // If the product doesn't exist, add it to the search results
              searchResults.add(result);
            }

            // Reset the quantity controller to '1' after adding
            quantityController.text = '1';

            // Calculate the new total price after updating the quantity
            total = calculateTotal();
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

//////////////////////// Add Product ////////////////////////////////////////////////////

  void addSelectedProduct(Product product) {
    setState(() {
      final existingProductIndex = searchResults
          .indexWhere((item) => item.productId == product.id.toString());

      if (existingProductIndex != -1) {
        // If the product already exists, update the quantity
        int currentQuantity =
            int.parse(searchResults[existingProductIndex].quantity ?? '0');
        searchResults[existingProductIndex].quantity =
            (currentQuantity + 1).toString();
      } else {
        // If the product doesn't exist, add it to the search results
        searchResults.add(
          ItemsArray(
            productId: product.id.toString(),
            name: product.name,
            quantity: '1',
            price: product.price.toString(),
          ),
        );
      }

      // Calculate the new total price
      total = calculateTotal();
    });
  }

// Function to calculate the total price
  double calculateTotals(double subtotal, double discount, double tax) {
    return subtotal - discount + tax;
  }

// Function to handle the checkout process
  Future<void> handleCheckout() async {
    try {
      // Calculate subtotal, discount, and tax
      double subtotal = calculateSubtotal();
      double discount = calculateDiscount();
      double tax = calculateTax();
      double total = calculateTotals(subtotal, discount, tax);

      // Prepare payment type and remarks
      String paymentType = _selectedPaymentType?.name ?? 'Cash';
      String remarks = paymentType; // Set remarks to payment type name

      // Calculate isReceipt value based on checkbox
      int isReceiptValue = isChecked ? 1 : 0;

      // Call API to save the transaction
      int posId = await saveTransaction(
        customerId: 0,
        total: total,
        taxId: _selectedPaymentTax!.id,
        custEmail: custEmailController.text,
        tax: tax,
        discId: null,
        discount: 0,
        subtotal: subtotal,
        paymentType: _selectedPaymentType!.id,
        remarks: remarks,
        isReceipt: isReceiptValue, // Use the calculated isReceiptValue
        searchResults: searchResults,
      );

      print('POS ID: $posId'); // Print the posId

      // Navigate to the InvoicePage using the retrieved posId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvoiceScreen(posId: posId),
        ),
      );
    } catch (e) {
      // Handle errors
      print('Error during checkout: $e');
      print('Error type: ${e.runtimeType}');
      if (e is http.Response) {
        print('Response status code: ${e.statusCode}');
        print('Response body: ${e.body}');
      }
    }
  }

// Function to save the transaction
  Future<int> saveTransaction({
    required int customerId,
    required double total,
    required int taxId,
    required String custEmail,
    required double tax,
    required int? discId,
    required double discount,
    required double subtotal,
    required int paymentType,
    required String remarks,
    required int isReceipt,
    required List<ItemsArray> searchResults,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse(Constants.apiPosIndex);

    final requestBody = PosRequestBody(
      customerId: customerId,
      grossPrice: total,
      taxId: taxId,
      custEmail: custEmail,
      taxAmount: tax,
      discId: discId,
      discAmount: discount,
      netPrice: subtotal,
      paymentType: paymentType,
      remarks: remarks,
      isReceipt: isReceipt,
      itemsArray: searchResults,
    );
    print("Request body: ${requestBody.toJson()}");

    final http.Response response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final int posId = responseData['data']['pos_data']['id'];
      print("POS TRANSACTION SUCCESSFULLY SAVED");
      setState(() {
        isLoading = false;
      });
      return posId;
    } else {
      // Handle the error more gracefully, e.g., show an error message to the user
      final Map<String, dynamic> errorResponseData = json.decode(response.body);
      final String errorMessage =
          errorResponseData['message'] ?? 'An error occurred';
      throw Exception('Failed to save POS transaction: $errorMessage');
    }
  }

// Function to handle the checkout button press
  void _onCheckoutButtonPressed() {
    handleCheckout();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fetchPos();
    _paymentType = fetchPaymentTypes();
    _paymentTax = fetchPaymentTax();
    _user = fetchUser();
    _fetchProductList(selectedCategory);
    _prodCategory = fetchCategoryNames();
    selectedCategory = "Food & Beverages";
    quantityController.text = quantity.toString();
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
      quantityController.text = quantity.toString();
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
        quantityController.text = quantity.toString();
      }
    });
  }

  void handleDeleteProduct(ItemsArray product) {
    setState(() {
      searchResults.remove(product);
    });
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
            "CartSini POS System",
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Form(
                              child: Container(
                                height: 82.h,
                                margin: kMargin,
                                padding: kPadding,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: kRadius,
                                ),
                                child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Column(children: [
                                        Column(
                                          children: [
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
                                        GestureDetector(
                                          onTap: () {
                                            // Remove focus from TextField when tapped outside
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
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
                                                  controller: skuController,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: kTextColor,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      borderSide: BorderSide(
                                                          width: 3,
                                                          color: Colors
                                                              .greenAccent),
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
                                            ],
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
                                        IconButton(
                                          icon: FaIcon(
                                            FontAwesomeIcons.chevronUp,
                                            size: 40.0,
                                            color: Colors.black,
                                          ),
                                          onPressed: _incrementQuantity,
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        SizedBox(
                                          width: 40.w,
                                          child: TextField(
                                            controller: quantityController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: kTextColor,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: BorderSide(
                                                  width: 3,
                                                  color: Colors.greenAccent,
                                                ),
                                              ),
                                            ),
                                            style: GoogleFonts.abel(
                                              fontSize: 11.sp,
                                              color: kScaffoldColor,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1.0,
                                            ),
                                            textAlign: TextAlign.center,
                                            onChanged: (value) {
                                              setState(() {
                                                quantity = int.parse(value);
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        IconButton(
                                          icon: FaIcon(
                                            FontAwesomeIcons.chevronDown,
                                            size: 40.0,
                                            color: Colors.black,
                                          ),
                                          onPressed: _decrementQuantity,
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          "Email",
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
                                            controller: custEmailController,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: kTextColor,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: BorderSide(
                                                  width: 3,
                                                  color: Colors.greenAccent,
                                                ),
                                              ),
                                              hintText: 'Customer Email',
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical:
                                                    4.0, // Adjust this value to control vertical alignment
                                                horizontal: 16.0,
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
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                overlayColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                                    if (states.contains(
                                                        MaterialState.pressed))
                                                      return Colors.greenAccent;
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              onPressed: () => _isLoader
                                                  ? buildCircularProgressIndicator()
                                                  : searchProduct(),
                                              child: Text(
                                                "Enter",
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: kTextColor,
                                                ),
                                                width: 32.w,
                                                height: 4.h,
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 15,
                                                ),
                                                child: LayoutBuilder(builder:
                                                    (context, constraints) {
                                                  return FutureBuilder<
                                                      List<PaymentTax>>(
                                                    future: _paymentTax,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      }
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const CircularProgressIndicator();
                                                      }
                                                      return DropdownButtonHideUnderline(
                                                      child: DropdownButton<
                                                          PaymentTax>(
                                                        icon: FaIcon(
                                                          FontAwesomeIcons
                                                              .chevronDown,
                                                          size: 15,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        isExpanded: true,
                                                        hint: Text(
                                                          "Select Tax Type",
                                                          style: TextStyle(
                                                            color: kHint,
                                                            fontSize: 6.5.sp,
                                                            letterSpacing: 0.5,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        items: [
                                                          ...snapshot.data!.map(
                                                            (tax) =>
                                                                DropdownMenuItem(
                                                              value: tax,
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    '${tax.name}',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          kForm,
                                                                      fontSize:
                                                                          5.sp,
                                                                      letterSpacing:
                                                                          1.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                          onChanged: (type) {
                                                          setState(() {
                                                            _selectedPaymentTax =
                                                                type; // Update _selectedPaymentTax when a tax type is selected
                                                          });
                                                        },
                                                        value:
                                                            _selectedPaymentTax,

                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Tax Amount",
                                              style: GoogleFonts.aubrey(
                                                fontWeight: FontWeight.w600,
                                                color: kLabel,
                                                fontSize: 11.sp,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                            _selectedPaymentTax != null
                                                ? Text(
                                                    "${_selectedPaymentTax!.taxPercentage}%", // Access taxPercentage from _selectedPaymentTax
                                                    style:
                                                        GoogleFonts.breeSerif(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: kTextColor,
                                                      fontSize: 11.sp,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  )
                                                : Text(
                                                    "0", // Show this when no tax type is selected
                                                    style:
                                                        GoogleFonts.breeSerif(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: kTextColor,
                                                      fontSize: 8.sp,
                                                      letterSpacing: 1.0,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: kTextColor,
                                                ),
                                                width: 32.w,
                                                height: 4.h,
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 15,
                                                ),
                                                child: LayoutBuilder(builder:
                                                    (context, constraints) {
                                                  return FutureBuilder<
                                                      List<PaymentType>>(
                                                    future: _paymentType,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasError) {
                                                        return Text(
                                                            'Error: ${snapshot.error}');
                                                      }
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const CircularProgressIndicator();
                                                      }
                                                      return DropdownButtonHideUnderline(
                                                        child: DropdownButton<
                                                            PaymentType>(
                                                          icon: FaIcon(
                                                            FontAwesomeIcons
                                                                .chevronDown,
                                                            size: 15,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          isExpanded: true,
                                                          hint: Text(
                                                            "Select Payment Type",
                                                            style: TextStyle(
                                                              color: kHint,
                                                              fontSize: 6.5.sp,
                                                              letterSpacing:
                                                                  0.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          items: [
                                                            ...snapshot.data!
                                                                .map(
                                                              (type) =>
                                                                  DropdownMenuItem(
                                                                value: type,
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      '${type.name}',
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            kForm,
                                                                        fontSize:
                                                                            5.sp,
                                                                        letterSpacing:
                                                                            1.0,
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
                                                              _selectedPaymentType =
                                                                  type;
                                                            });
                                                          },
                                                          value:
                                                              _selectedPaymentType,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }),
                                                ),
                                          ],
                                        ),
                                        SizedBox(
                                        height: 1.h,
                                      ),
                                        Row(
                                          mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Receipt",
                                            style: GoogleFonts.aubrey(
                                              fontWeight: FontWeight.w600,
                                              color: kLabel,
                                              fontSize: 11.sp,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                          MSHCheckbox(
                                            size: 35,
                                            value: isChecked, 
                                            isDisabled: isDisabled,
                                            colorConfig: MSHColorConfig
                                                  .fromCheckedUncheckedDisabled(
                                                checkedColor: Colors.greenAccent,
                                              ),
                                              style: style,
                                            onChanged: (isReceipt) {
                                              setState(() {
                                                isChecked = isReceipt;
                                              });
                                            },
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (searchResults.isNotEmpty) {
                                                _onCheckoutButtonPressed();
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("No Items"),
                                                      content: Text(
                                                          "You must add items before proceeding."),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("OK"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "CHECKOUT",
                                              style: GoogleFonts.ubuntu(
                                                fontSize: 14.sp,
                                                letterSpacing: 1.0,
                                                fontWeight: FontWeight.w500,
                                              ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 82.h,
                                  margin: kMargin,
                                  padding: kPadding,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: kRadius,
                                  ),
                                    child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 63.h,
                                        margin: kMargin,
                                        padding: kPadding,
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: kRadius,
                                        ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Table(
                                                  defaultVerticalAlignment:
                                                      TableCellVerticalAlignment.middle,
                                                  border: TableBorder.all(
                                                      color: Colors.transparent),
                                                  columnWidths: {
                                                    // 0: FlexColumnWidth(1),
                                                    0: FlexColumnWidth(4),
                                                    1: FlexColumnWidth(2),
                                                    2: FlexColumnWidth(1),
                                                    3: FlexColumnWidth(2),
                                                    4: FlexColumnWidth(1),
                                                  },
                                                  children: [
                                                    TableRow(
                                                      children: [
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(6),
                                                            child: Text(
                                                              "Name",
                                                              style: GoogleFonts.aubrey(
                                                                fontWeight: FontWeight.w600,
                                                                color: kLabel,
                                                                fontSize: 9.sp,
                                                                letterSpacing: 1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(6),
                                                            child: Text(
                                                              "Price (MYR)",
                                                              style: GoogleFonts.aubrey(
                                                                fontWeight: FontWeight.w600,
                                                                color: kLabel,
                                                                fontSize: 9.sp,
                                                                letterSpacing: 1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(6),
                                                            child: Text(
                                                              "QTY",
                                                              style: GoogleFonts.aubrey(
                                                                fontWeight: FontWeight.w600,
                                                                color: kLabel,
                                                                fontSize: 9.sp,
                                                                letterSpacing: 1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(6),
                                                            child: Text(
                                                              "Subtotal (MYR)",
                                                              style: GoogleFonts.aubrey(
                                                                fontWeight: FontWeight.w600,
                                                                color: kLabel,
                                                                fontSize: 9.sp,
                                                                letterSpacing: 1.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        TableCell(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  6),
                                                          child: Text(
                                                            "Del",
                                                            style:
                                                                GoogleFonts.aubrey(
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: kLabel,
                                                              fontSize: 9.sp,
                                                              letterSpacing: 1.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      ],
                                                    ),
                                                    for (final result in searchResults)
                                                      TableRow(
                                                        children: [
                                                          
                                                          TableCell(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(6.0),
                                                              child: Text(
                                                                result.name,
                                                                style:
                                                                    GoogleFonts.breeSerif(
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                  color: kTextColor,
                                                                  fontSize: 10.sp,
                                                                  letterSpacing: 1.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(6.0),
                                                              child: Text(
                                                                result.price,
                                                                style:
                                                                    GoogleFonts.breeSerif(
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                  color: kTextColor,
                                                                  fontSize: 10.sp,
                                                                  letterSpacing: 1.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(6.0),
                                                              child: Text(
                                                                result.quantity as String,
                                                                style:
                                                                    GoogleFonts.breeSerif(
                                                                  fontWeight:
                                                                      FontWeight.w500,
                                                                  color: kTextColor,
                                                                  fontSize: 10.sp,
                                                                  letterSpacing: 1.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(6.0),
                                                              child: Text(
                                                                '${(double.parse(result.quantity ?? '0') * double.parse(result.price)).toStringAsFixed(2)}',
                                                                style:
                                                                    GoogleFonts.breeSerif(
                                                                  fontWeight:
                                                                      FontWeight.w500,
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
                                                              child: GestureDetector(
                                                                onTap:() {
                                                                  handleDeleteProduct(result);
                                                                },
                                                                child: FaIcon(
                                                                  FontAwesomeIcons.trash,
                                                                  color: Colors.redAccent,
                                                                  size: 30
                                                                  ),
                                                              ),
                                                              ),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.red,
                                          thickness: 2.0,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                calculateTotal().toStringAsFixed(2),
                                                style: GoogleFonts.breeSerif(
                                                  fontWeight: FontWeight.w500,
                                                  color: kTextColor,
                                                  fontSize: 11.sp,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<String>>(
                      future: fetchCategoryNames(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error fetching categories: ${snapshot.error}',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          // Check if data is available
                          List<String> categoryList = snapshot
                              .data!; // Data is not null, use ! to access
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedButtonBar(
                                foregroundColor: Colors.blueGrey.shade400,
                                radius: 8.0,
                                padding: const EdgeInsets.all(16.0),
                                invertedSelection: true,
                                children: [
                                  for (var categoryName in categoryList)
                                    ButtonBarEntry(
                                      child: Text(
                                        categoryName,
                                        style: GoogleFonts.breeSerif(
                                          fontWeight: FontWeight.w400,
                                          color: kTextColor,
                                          fontSize: 8.sp,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = categoryName;
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          // Handle the case when snapshot.data is null
                          return Center(
                            child: Text(
                              'No categories available',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Container(
                      height: 54.h,
                      width: 200.w,
                      margin: kMargin,
                      padding: kPadding,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: kRadius,
                      ),
                      child: FutureBuilder<List<Product>>(
                        future: fetchProductsForCategory(selectedCategory),
                        builder: (context, snapshot) {
                          if (isLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error fetching products: ${snapshot.error}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: kTextColor,
                                ),
                              ),
                            );
                          } else {
                            List<Product> productList = snapshot.data ?? [];
                            if (productList.isEmpty) {
                              return Center(
                                child: Text(
                                  'No products available',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: kTextColor,
                                  ),
                                ),
                              );
                            } else {
                              return Wrap(
                                alignment: WrapAlignment.start,
                                children: productList
                                    .map(
                                      (product) => GestureDetector(
                                        onTap: () {
                                          addSelectedProduct(product);
                                        },
                                        child: Container(
                                          width: 29.w,
                                          height: 8.h,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.all(10.0),
                                          padding: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10.0),
                                              Text(
                                                product.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              SizedBox(height: 5.0),
                                              Text(
                                                '\RM${product.price}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              // SizedBox(height: 10.0),
                                              // Text(
                                              //   product.summary,
                                              //   style: TextStyle(
                                              //     fontSize: 14.0,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                          }
                        },
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        );
  }
}