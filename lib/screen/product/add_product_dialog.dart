import 'dart:convert';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/api/api.dart';
import 'package:pointofsales/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../../models/product_model.dart';
class AddPoductDialogContent extends StatefulWidget {
  final int posId;
  const AddPoductDialogContent({required this.posId});

  @override
  State<AddPoductDialogContent> createState() => _AddPoductDialogContentState();
}

class _AddPoductDialogContentState extends State<AddPoductDialogContent> {
  late String selectedCategory = "Food & Beverages";
  List<Product> productListState = [];
  bool isLoading = true;

  ////////////////////////////// Fetch Product Category ////////////////////////////////////////

  Future<List<String>> fetchCategoryProductName() async {
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
  

  @override
  void initState() {
    super.initState();
    _fetchProductList(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FutureBuilder<List<String>>(
              future: fetchCategoryProductName(),
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
                  List<String> categoryList =
                      snapshot.data!; // Data is not null, use ! to access
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
                      List<ProductElement> productList =
                          (snapshot.data as List<ProductElement>);
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
                                    // addSelectedProduct(product);
                                  },
                                  child: Container(
                                    width: 29.w,
                                    height: 10.h,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10.0),
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
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
                )),
          ],
          ),
        ),
    );
  }
}