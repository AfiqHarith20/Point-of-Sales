import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/enums/field_status.dart';
import 'package:gsform/gs_form/model/data_model/spinner_data_model.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';
import 'package:pointofsales/constant.dart';

import 'package:pointofsales/screen/merchant_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class CreateMerchant extends StatefulWidget {
  const CreateMerchant({Key? key}) : super(key: key);

  @override
  State<CreateMerchant> createState() => _CreateMerchantState();
}

class _CreateMerchantState extends State<CreateMerchant> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late GSForm form;
  final companyNameController = TextEditingController();
  final contactNoController = TextEditingController();
  final contactEmailController = TextEditingController();
  final officeAddressController = TextEditingController();
  final postcodeController = TextEditingController();

  List statesList = [];
  List citiesList = [];

  bool _isLoader = false;
  late String _state;
  late String _city;

  // Future<void> createMerchant() async {
  //   final http.Response response = await http.post(
  //     Uri.parse("http://template.gosini.xyz:8880/cspos/public/api/merchant"),
  //     body: JSON.jsonEncode({
  //       "company_name": companyNameController.text,
  //       "contact_no": contactNoController.text,
  //       "contact_email": contactEmailController.text,
  //       "office_address": officeAddressController.text,
  //       "postcode": postcodeController.text,
  //       "state": _state.toString(),
  //       "city": _city.toString(),
  //     }),
  //     headers: {
  //       'Authorization': 'Bearer ' + prefs.getString('token'),
  //       'Content-Type': 'application/json'
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     print(response);
  //     print("Success Register Merchant");
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  //   return createMerchant();
  // }

  Future<void> _getStateList() async {
    await http
        .get(
      Uri.parse(
          "http://template.gosini.xyz:8880/cspos/public/api/lookup/state"),
    )
        .then((response) {
      var data = json.decode(response.body);
      setState(() {
        statesList = data;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getCityList() async {
    await http
        .get(Uri.parse(
            "http://template.gosini.xyz:8880/cspos/public/api/lookup/city/" +
                _state))
        .then((response) {
      var data = json.decode(response.body);
      setState(() {
        citiesList = data;
      });
    }).catchError((e) {
      debugPrint(e);
    });
    ;
  }

  void _submitForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoader = true;
    });
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoader = false;
      });
      return;
    }

    _formKey.currentState!.save();

    final http.Response response = await http.post(
      Uri.parse("http://template.gosini.xyz:8880/cspos/public/api/merchant"),
      body: JSON.jsonEncode({
        "company_name": companyNameController.text,
        "contact_no": contactNoController.text,
        "contact_email": contactEmailController.text,
        "office_address": officeAddressController.text,
        "postcode": postcodeController.text,
        "state": _state.toString(),
        "city": _city.toString(),
      }),
      headers: {
        'Authorization': 'Bearer ' + prefs.getString('token').toString(),
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      print(response);
      print("Success Register Merchant");
    } else {
      print(response.reasonPhrase);
    }
    return;
  }

  @override
  void initState() {
    _getStateList();
    super.initState();
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
                    builder: (context) => MerchantScreen(),
                  ),
                );
              },
            );
          },
        ),
        title: Text(
          "Create Merchant",
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
              FontAwesomeIcons.floppyDisk,
              color: Colors.white,
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => CreateMerchant(),
              //   ),
              // );
            },
            tooltip: "Add Merchant",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: form = GSForm.singleSection(context,
                style: GSFormStyle(
                  backgroundSectionColor: kScaffoldColor,
                  backgroundFieldColor: kTextColor,
                  fieldTextStyle: TextStyle(
                    color: kForm,
                    fontSize: 12.sp,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                  ),
                  fieldHintStyle: TextStyle(
                    color: kHint,
                    fontSize: 10.sp,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w500,
                  ),
                  titleStyle: TextStyle(
                    color: kTextColor,
                    fontSize: 14.sp,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                fields: [
                  GSField.text(
                    tag: 'companyName',
                    title: 'Company Name',
                    minLine: 2,
                    maxLine: 2,
                    weight: 12,
                    required: true,
                    maxLength: 100,
                    errorMessage: 'The fill is empty',
                    hint: 'Digital Dagang',
                    // helpMessage: 'help message',
                    // validateRegEx: regX,
                    // postfixWidget: widget,
                    // prefixWidget: widget,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  GSField.mobile(
                    tag: 'contactNo',
                    title: 'Contact Number',
                    hint: '03-2394284',
                    // helpMessage: 'help message',
                    errorMessage: 'Do not use space',
                    maxLength: 11,
                    // postfixWidget: widget,
                    // prefixWidget: widget,
                    // validateRegEx: regex,
                    weight: 12,
                    required: true,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  GSField.email(
                    tag: 'contactEmail',
                    title: 'Email',
                    hint: 'afiq@digitaldagang.com',
                    errorMessage: 'Email does not valid',
                    // helpMessage: 'help message',
                    maxLength: 11,
                    // postfixWidget: widget,
                    // prefixWidget: widget,
                    // validateRegEx: regex,
                    weight: 12,
                    required: true,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  GSField.textPlain(
                    tag: 'officeAddress',
                    title: 'Office Address',
                    weight: 12,
                    required: true,
                    errorMessage: 'error message',
                    hint: 'D-07 Business Suite, Setiawangsa',
                    // helpMessage: 'help message',
                    maxLength: 100,
                    maxLine: 2,
                    minLine: 1,
                    // postfixWidget: widget,
                    // prefixWidget: widget,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  GSField.number(
                    tag: 'postcode',
                    title: 'PostCode',
                    hint: '335500',
                    weight: 12,
                    maxLength: 11,
                    required: true,
                    errorMessage: 'Wrong post code',
                    // helpMessage: 'help message',
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  GSField.spinner(
                    errorMessage: 'Please select state',
                    hint: 'Select State',
                    // helpMessage: 'help message',
                    tag: 'state',
                    required: true,
                    weight: 12,
                    title: 'State',
                    items: [
                      SpinnerDataModel(
                        name: 'None',
                        id: 0,
                        isSelected: true,
                      ),
                      SpinnerDataModel(
                        name: 'Selangor',
                        id: 1,
                      ),
                      SpinnerDataModel(
                        name: 'Johor',
                        id: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  GSField.spinner(
                    errorMessage: 'Please select city',
                    hint: 'Select City',
                    // helpMessage: 'help message',
                    tag: 'city',
                    required: true,
                    weight: 12,
                    title: 'City',
                    items: [
                      SpinnerDataModel(
                        name: 'None',
                        id: 0,
                        isSelected: true,
                      ),
                      SpinnerDataModel(
                        name: 'Kuala Lumpur',
                        id: 1,
                      ),
                      SpinnerDataModel(
                        name: 'Johor Bharu',
                        id: 2,
                      ),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
