import 'dart:convert' as JSON;
import 'dart:io';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsform/gs_form/widget/form.dart';
import 'package:pointofsales/api/api.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/data.dart';
import 'package:pointofsales/screen/home_screen.dart';
import 'package:pointofsales/screen/product_screen.dart';
import 'package:pointofsales/widget/progressIndicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({Key? key}) : super(key: key);

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late GSForm form;
  bool _isLoader = false;
  String errorMessage = '';
  final prodSkuController = TextEditingController();
  final prodNameController = TextEditingController();
  final prodSummaryController = TextEditingController();
  final prodDetailsController = TextEditingController();
  final prodCategoryController = TextEditingController();
  final prodPriceController = TextEditingController();
  final prodQuantityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize the TextEditingController instances
    prodSkuController.text = '';
    prodNameController.text = '';
    prodSummaryController.text = '';
    prodDetailsController.text = '';
    prodCategoryController.text = '';
    prodPriceController.text = '';
    prodQuantityController.text = '';
  }

  //Submit Product//
void _submitProd() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoader = true;
    });

    if (_formKey.currentState == null) {
      setState(() {
        _isLoader = false;
      });
      return;
    }

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoader = false;
      });
      return;
    }

    _formKey.currentState!.save();

    final http.Response response = await http.post(
      Uri.parse(Constants.apiProductIndex),
      body: JSON.jsonEncode({
        "sku": prodSkuController.text,
        "name": prodNameController.text,
        "summary": prodSummaryController.text,
        "details": prodDetailsController.text,
        "category_id": prodCategoryController.text,
        "price": prodPriceController.text,
        "quantity": prodQuantityController.text,
      }),
      headers: {
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      print(response);
      print("Success Register Merchant");

      prodSkuController.clear();
      prodNameController.clear();
      prodSummaryController.clear();
      prodDetailsController.clear();
      prodCategoryController.clear();
      prodPriceController.clear();
      prodQuantityController.clear();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ProductScreen(),
        ),
      );
      
    } else {
      print(response.reasonPhrase);
    }

    setState(() {
      _isLoader = false;
    });

    if (response.statusCode == 201) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ProductScreen(),
        ),
      );
    } else {
      setState(() {
        errorMessage =
            'Failed to create products: ${response.statusCode}: ${response.body}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Builder(
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
                    builder: (context) => ProductScreen(),
                  ),
                );
              },
            );
          },
        ),
        title: Text(
          "Create Product",
          style: GoogleFonts.ubuntu(
            fontSize: 16.sp,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w500,
            color: kTextColor,
          ),
        ),
        actions: <Widget>[
          IconButton(
            iconSize: 35,
            icon: FaIcon(
              FontAwesomeIcons.floppyDisk,
              color: Colors.white,
              
            ),
            onPressed: () =>
                _isLoader ? buildCircularProgressIndicator() : _submitProd(),
            tooltip: "Add Product",
          ),
        ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "SKU:",
                            style: GoogleFonts.ubuntu(
                              fontSize: 14.sp,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: prodSkuController,
                      style: TextStyle(
                        color: kForm,
                        fontSize: 10.sp,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        filled: true,
                        fillColor: kTextColor,
                      ),
                    ),
                    SizedBox(height: 1.h,),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Name:",
                            style: GoogleFonts.ubuntu(
                              fontSize: 14.sp,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: prodNameController,
                      style: TextStyle(
                        color: kForm,
                        fontSize: 10.sp,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        filled: true,
                        fillColor: kTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Summary:",
                            style: GoogleFonts.ubuntu(
                              fontSize: 14.sp,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: prodSummaryController,
                      style: TextStyle(
                        color: kForm,
                        fontSize: 10.sp,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        filled: true,
                        fillColor: kTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Details:",
                            style: GoogleFonts.ubuntu(
                              fontSize: 14.sp,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: prodDetailsController,
                      style: TextStyle(
                        color: kForm,
                        fontSize: 10.sp,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        filled: true,
                        fillColor: kTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Price:",
                            style: GoogleFonts.ubuntu(
                              fontSize: 14.sp,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: prodPriceController,
                      style: TextStyle(
                        color: kForm,
                        fontSize: 10.sp,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        filled: true,
                        fillColor: kTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Quantity:",
                            style: GoogleFonts.ubuntu(
                              fontSize: 14.sp,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: prodQuantityController,
                      style: TextStyle(
                        color: kForm,
                        fontSize: 10.sp,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        filled: true,
                        fillColor: kTextColor,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Category:",
                            style: GoogleFonts.ubuntu(
                              fontSize: 14.sp,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: prodCategoryController,
                      style: TextStyle(
                        color: kForm,
                        fontSize: 10.sp,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        filled: true,
                        fillColor: kTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}