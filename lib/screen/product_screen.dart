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

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLoading = true;
  List<Products> productList = [];

  int? id, quantity, status, categoryId;
  String? name, summary, sku, details;
  double? price;
  dynamic? isSearch, ispromo, promoPrice, promoStartdate, promoEnddate, stock, mainImage;

  Future<void> _getIndexProduct() async{
    try{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(Uri.parse(Constants.apiProductIndex),
    headers: {
          'Authorization': 'Bearer ' + prefs.getString('token').toString(),
          'Content-Type': 'application/json'
        }
    );
    print(response.body);
    final Map<String, dynamic> prod = json.decode(response.body);
    if (response.statusCode == 200) {
      print("PRODUCT LIST >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      setState(() {
        isLoading = false;

        if(prod['data'] != null){
          var data = ProductDetail(
            id: prod['data']['products']['id'],
            sku: prod['data']['products']['sku'],
            name: prod['data']['products']['name'],
            summary: prod['data']['products']['summary'],
            details: prod['data']['products']['details'],
            categoryId: prod['data']['products']['categoryId'],
            price: prod['data']['products']['price'],
            quantity: prod['data']['products']['quantity'],
            isSearch: prod['data']['products']['isSearch'],
            ispromo: prod['data']['products']['ispromo'],
            promoPrice: prod['data']['products']['promoPrice'],
            promoStartdate: prod['data']['products']['promoStart'],
            promoEnddate: prod['data']['products']['promoEnd'],
            status: prod['data']['products']['status'],
            stock: prod['data']['products']['stock'],
            productCategory: prod['data']['products']['productCategory'],
          );
            id = data.id;
            sku = data.sku;
            name = data.name;
            summary = data.summary;
            details = data.details;
            categoryId = data.categoryId;
            price = data.price;
            quantity = data.quantity;
            isSearch = data.isSearch;
            ispromo = data.ispromo;
            promoPrice = data.promoPrice;
            promoStartdate = data.promoStartdate;
            promoEnddate = data.promoEnddate;
            stock = data.stock;
            status = data.status;
            mainImage = data.mainImage;
            
        } 
      });
    }} catch (e) {
      print(e);
      isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
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
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              var producst = productList[index];
              return ListTile(
                leading: Image.network(products.mainImage), // Assuming imageUrl is the URL of the product image
                title: Text(products.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'), // Assuming price is a double value
              );
            },
          ),
    );
  }
}
