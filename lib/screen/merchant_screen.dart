// ignore_for_file: unused_label, unnecessary_statements

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:pointofsales/constant.dart';
import 'package:pointofsales/models/merchant_model.dart';
import 'package:pointofsales/screen/drawer_screen.dart';
import 'package:pointofsales/screen/merchant/create_merchant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class MerchantScreen extends StatefulWidget {
  const MerchantScreen({Key? key}) : super(key: key);

  @override
  State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  bool isMerchantCreated = false;
  bool isLoading = true;

  late int userId, state, city;
  late String companyName, contactNo, contactEmail, officeAddress, postcode;
  // late dynamic companyNo,
  //     businessOwnership,
  //     gstNo,
  //     businessDuration,
  //     logoUrl,
  //     posPrefix,
  //     brandName,
  //     businessNature,
  //     contactName,
  //     website,
  //     facebook,
  //     instagram,
  //     referrer,
  //     shopUrl;

  //////////////////// Logo/Image Upload ////////////////////////////////////////////////////////////////

  Future<String> _postUploadLogo(File imageFile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Uri uri = Uri.parse(
        "http://template.gosini.xyz:8880/cspos/public/api/merchant/logo/upload");
    var req = http.MultipartRequest(
      'POST',
      uri,
    );
    req.headers['Authorization'] =
        'Bearer ' + prefs.getString('token').toString();
    req.headers['Content-Type'] = 'multipart/form-data';

    var mimeType = lookupMimeType(imageFile.path);
    var multipartFile = await http.MultipartFile.fromPath(
        'logo', imageFile.path,
        contentType: MediaType.parse(mimeType!));
    req.files.add(multipartFile);

    var response = await req.send();
    if (response.statusCode == 200) {
      // Image upload successful
      return _postUploadLogo(imageFile);
    } else {
      // Image upload failed
      throw Exception('Failed to upload image');
    }
  }

  //////////////////// Index Company ////////////////////////////////////////////////////////////////

  Future<void> _getIndexCompany() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final http.Response response = await http.get(
        Uri.parse("http://template.gosini.xyz:8880/cspos/public/api/merchant"),
        headers: ({
          'Authorization': 'Bearer ' + prefs.getString('token').toString(),
          'Content-Type': 'application/json'
        }),
      );
      final Map<String, dynamic> res = json.decode(response.body);
      if (response.statusCode == 200) {
        print("MERCHANT DETAILS!!!!!!!!!!!!!!!!!!!!!!!!!!");
        print(prefs.getString('token').toString());

        setState(() {
          isLoading = false;

          if (res['data'] != null) {
            isMerchantCreated = true;

            var data = MerchantDetail(
              id: res['data']['id'],
              userId: res['data']['user_id'],
              companyName: res['data']['company_name'].toString(),
              companyNo: res['data']['company_no'],
              contactEmail: res['data']['contact_email'].toString(),
              contactNo: res['data']['contact_no'].toString(),
              officeAddress: res['data']['office_address'].toString(),
              postcode: res['data']['postcode'].toString(),
              state: res['data']['state'],
              city: res['data']['city'],
              // businessOwnership: res['data']['businessOwnership'],
              // businessDuration: res['data']['businessDuration'],
              // brandName: res['data']['brandName'],
              // businessNature: res['data']['businessNature'],
              // contactName: res['data']['contactName'].toString(),

              // website: res['data']['website'],
              // facebook: res['data']['facebook'],
              // instagram: res['data']['instagram'],
              // referrer: res['data']['referrer'],
              // shopUrl: res['data']['shopUrl'],
              status: res['data']['status'],
              // gstNo: res['data']['gstNo'],
              feePercentage: res['data']['feePercentage'],
              feeMinimum: res['data']['feeMinimum'],
              // logoUrl: res['data']['logoUrl'],
            );

            // id = data.id;
            userId = data.userId;
            companyName = data.companyName.toUpperCase();
            contactNo = data.contactNo;
            contactEmail = data.contactEmail;
            officeAddress = data.officeAddress;
            postcode = data.postcode;
            state = data.state;
            city = data.city;
            // companyNo = data.companyNo;
            // businessOwnership = data.businessOwnership;
            // brandName = data.brandName;
            // businessNature = data.businessNature;
            // contactName = data.contactName;
            // website = data.website;
            // facebook = data.facebook;
            // instagram = data.instagram;
            // referrer = data.referrer;
            // shopUrl = data.shopUrl;
            // status = data.status;
            // gstNo = data.gstNo;
            // feePercentage = data.feePercentage;
            // feeMinimum = data.feeMinimum;
            // logoUrl = data.logoUrl;
          } else {
            isMerchantCreated = false;
          }
        });
      } else {
        isLoading = false;
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
      isLoading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getIndexCompany();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
            "Merchant",
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
                FontAwesomeIcons.circlePlus,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateMerchant(),
                  ),
                );
              },
              tooltip: "Add Merchant",
            ),
          ],
        ),
        body: Center(
          child: Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ),
          ),
        ),
      );
    } else {
      if (isMerchantCreated) {
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
              "Merchant",
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
                  FontAwesomeIcons.circlePlus,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateMerchant(),
                    ),
                  );
                },
                tooltip: "Add Merchant",
              ),
            ],
          ),
          body: Container(
            width: 100.w,
            height: 84.h,
            margin: kMargin,
            padding: kPadding,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: kRadius,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final pickedFile = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          // _selectedLogo = File(pickedFile.path);
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 70.0,
                      child: FaIcon(
                        FontAwesomeIcons.buildingUser,
                        size: 60,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Company Name",
                      labelStyle: GoogleFonts.abel(
                        fontSize: 14.sp,
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    initialValue: companyName,
                    style: GoogleFonts.atma(
                      fontSize: 14.sp,
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Contact Number",
                      labelStyle: GoogleFonts.abel(
                        fontSize: 14.sp,
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    initialValue: contactNo,
                    style: GoogleFonts.atma(
                      fontSize: 14.sp,
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Contact Email",
                      labelStyle: GoogleFonts.abel(
                        fontSize: 14.sp,
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    initialValue: contactEmail,
                    style: GoogleFonts.atma(
                      fontSize: 14.sp,
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Office Address",
                      labelStyle: GoogleFonts.abel(
                        fontSize: 14.sp,
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    initialValue: officeAddress,
                    style: GoogleFonts.atma(
                      fontSize: 14.sp,
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "PostCode",
                      labelStyle: GoogleFonts.abel(
                        fontSize: 14.sp,
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    initialValue: postcode,
                    style: GoogleFonts.atma(
                      fontSize: 14.sp,
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "State",
                      labelStyle: GoogleFonts.abel(
                        fontSize: 14.sp,
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    initialValue: state.toString(),
                    style: GoogleFonts.atma(
                      fontSize: 14.sp,
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "City",
                      labelStyle: GoogleFonts.abel(
                        fontSize: 14.sp,
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    initialValue: city.toString(),
                    style: GoogleFonts.atma(
                      fontSize: 14.sp,
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // ElevatedButton(
                  //   onPressed: (){}

                  // ),
                ],
              ),
            ),
          ),
        );
      } else {
        return buildNoMerchantText();
      }
    }
  }

  Widget buildNoMerchantText() {
    return Center(
      child: Text(
        "No merchant, please register first",
        style: GoogleFonts.ubuntu(
          fontSize: 16.sp,
          letterSpacing: 1.0,
          fontWeight: FontWeight.w600,
          color: kTextColor,
        ),
      ),
    );
  }
}
