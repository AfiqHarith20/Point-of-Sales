import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pointofsales/api/api.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/product_model.dart';
import 'package:pointofsales/screen/home_screen.dart';
import 'package:pointofsales/screen/invoice_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:getwidget/getwidget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLoading = true;
  late List<ProductDetail> products = [];

  Future<List<ProductDetail>> fetchProduct() async {
    final url = Uri.parse(Constants.apiProductIndex);
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
      final prod = Products.fromJson(json);
      return prod.products;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  void _getIndexProduct() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.get(
        Uri.parse(Constants.apiProductIndex),
        headers: {
          'Authorization': 'Bearer ' + prefs.getString('token').toString(),
          'Content-Type': 'application/json'
        },
      );
      print(response.body);
      final Map<String, dynamic> prod = json.decode(response.body);
      if (response.statusCode == 200) {
        print("PRODUCT LIST >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        setState(() {
          isLoading = false;

          if (prod['data'] != null && prod['data'].isNotEmpty) {
            var productsJson = prod['data'][0]['products'] as List<dynamic>?;
            if (productsJson != null) {
              products = productsJson
                  .map((productJson) => ProductDetail.fromJson(productJson))
                  .toList();

              Future<List<ProductDetail>> _productDetail = fetchProduct();

              print(products);

              _productDetail.then((productDetail) {
                setState(() {
                  
                  products = productDetail.map((productJson) {
                    return ProductDetail(
                      id: productJson.id,
                      sku: productJson.sku,
                      name: productJson.name,
                      summary: productJson.summary,
                      details: productJson.details,
                      categoryId: productJson.categoryId,
                      price: productJson.price,
                      quantity: productJson.quantity,
                      isSearch: productJson.isSearch,
                      ispromo: productJson.ispromo,
                      promoPrice: productJson.promoPrice,
                      promoStartdate: productJson.promoStartdate,
                      promoEnddate: productJson.promoEnddate,
                      status: productJson.status,
                      stock: productJson.stock,
                      mainImage: productJson.mainImage,
                      productCategory:
                          ProductCategory.fromJson(productJson.productCategory as Map<String, dynamic>),
                    );
                    
                  }).toList();
                  
                });
              });
            }
          }
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getIndexProduct();
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
          "Product",
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
              FontAwesomeIcons.cartFlatbed,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceScreen(),
                ),
              );
            },
            tooltip: "Invoice",
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: GFLoader(type: GFLoaderType.ios),
            )
          : products.isEmpty
              ? Center(
                  child: Text(
                    'No products available',
                    style: GoogleFonts.ubuntu(
                      fontSize: 16.sp,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w500,
                      color: kTextColor,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: products
                        .map(
                          (product) => Container(
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
                                product.mainImage != null &&
                                        product.mainImage.isNotEmpty
                                    ? Image.network(
                                        product.mainImage!,
                                        height: 100.0,
                                        width: 100.0,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        'assets/apple.png',
                                        height: 100.0,
                                        width: 100.0,
                                        fit: BoxFit.contain,
                                      ),
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
                                  '\RM${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  product.summary,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
    );
  }
}
