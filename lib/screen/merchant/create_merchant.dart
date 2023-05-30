import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsform/gs_form/core/form_style.dart';
import 'package:gsform/gs_form/enums/field_status.dart';
import 'package:gsform/gs_form/widget/field.dart';
import 'package:gsform/gs_form/widget/form.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/screen/merchant_screen.dart';
import 'package:sizer/sizer.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class CreateMerchant extends StatefulWidget {
  const CreateMerchant({Key? key}) : super(key: key);

  @override
  State<CreateMerchant> createState() => _CreateMerchantState();
}

class _CreateMerchantState extends State<CreateMerchant> {
  late GSForm form;
  final companyNameController = TextEditingController();
  final contactNoController = TextEditingController();
  final contactEmailController = TextEditingController();
  final officeAddressController = TextEditingController();
  final postcodeController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();

  Future<void> createMerchant() async {
    final http.Response response = await http.post(
      Uri.parse("http://template.gosini.xyz:8880/cspos/public/api/merchant"),
      body: ({
        "company_name": companyNameController.text,
        "contact_no": contactNoController.text,
        "contact_email": contactEmailController.text,
        "office_address": officeAddressController.text,
        "postcode": postcodeController,
        "state": stateController.text,
        "city": cityController.text,
      }),
    );

    if (response.statusCode == 200) {
      print(response);
      print("Success Register Merchant");
    } else {
      print(response.reasonPhrase);
    }
    return createMerchant();
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
                  backgroundFieldColor: kForm,
                  fieldHintStyle: TextStyle(
                    color: kTextColor,
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
                    tag: 'compName',
                    title: 'Company Name',
                    minLine: 2,
                    maxLine: 2,
                    weight: 12,
                    required: true,
                    maxLength: 100,
                    errorMessage: 'error message',
                    hint: 'Digital Dagang',
                    helpMessage: 'help message',
                    // validateRegEx: regX,
                    // postfixWidget: widget,
                    // prefixWidget: widget,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  GSField.mobile(
                    tag: 'compNum',
                    title: 'Contact Number',
                    hint: '03-2394284',
                    helpMessage: 'help message',
                    errorMessage: 'error message',
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
                    tag: 'email',
                    title: 'Email',
                    hint: 'afiq@digitaldagang.com',
                    errorMessage: 'error message',
                    helpMessage: 'help message',
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
                    helpMessage: 'help message',
                    maxLength: 100,
                    maxLine: 2,
                    minLine: 1,
                    // postfixWidget: widget,
                    // prefixWidget: widget,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
