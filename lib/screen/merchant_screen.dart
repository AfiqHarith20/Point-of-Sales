// ignore_for_file: unused_label, unnecessary_statements

import 'dart:convert' as JSON;
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
  bool isLoader = false;
  bool isLoading = true;

  late int userId, state, city;
  late String companyName, contactNo, contactEmail, officeAddress, postcode;
  late dynamic companyNo, website;
  //     businessOwnership,
  //     gstNo,
  //     businessDuration,
  //     logoUrl,
  //     posPrefix,
  //     brandName,
  //     businessNature,
  //     contactName,
  //     facebook,
  //     instagram,
  //     referrer,
  //     shopUrl;
  int getState() {return state;}
  int getCity() {return city;}

  String getCompanyNo() {return companyNo;}
  String getContactNo() {return contactNo;}
  String getContactEmail() {return contactEmail;}
  String getOfficeAddress() {return officeAddress;}
  String getPostcode() {return postcode;}

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
        // print(prefs.getString('token').toString());

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
              website: res['data']['website'].toString(),
              // businessOwnership: res['data']['businessOwnership'],
              // businessDuration: res['data']['businessDuration'],
              // brandName: res['data']['brandName'],
              // businessNature: res['data']['businessNature'],
              // contactName: res['data']['contactName'].toString(),

              
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
            website = data.website;
            companyNo = data.companyNo;
            // businessOwnership = data.businessOwnership;
            // brandName = data.brandName;
            // businessNature = data.businessNature;
            // contactName = data.contactName;
            
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

  

  
  ///////////////////////////// Initialize ///////////////////////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////// build /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
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
          body: Form(
            child: Container(
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
                      enabled: false,
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
                      onTap: (){
                        _viewForm(1,"Edit Company Number");
                      },
                      decoration: InputDecoration(
                        labelText: "Company Number",
                        labelStyle: GoogleFonts.abel(
                          fontSize: 14.sp,
                          color: kTextColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                        ),
                      ),
                      initialValue: companyNo,
                     
                      style: GoogleFonts.atma(
                        fontSize: 14.sp,
                        color: kTextColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    TextFormField(
                      // enabled: false,
                      onTap: () {
                        _viewForm(2, "Edit Contact Number");
                      },
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
                      // enabled: false,
                      onTap: () {
                        _viewForm(3, "Edit Contact Email");
                      },
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
                      // enabled: false,
                      onTap: () {
                        _viewForm(4, "Edit Office Address");
                      },
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
                      // enabled: false,
                      onTap: () {
                        _viewForm(5, "Edit Postcode");
                      },
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
                      // enabled: false,
                      onTap: () {
                        _viewForm(6, "Edit State");
                      },
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
                      // enabled: false,
                      onTap: () {
                        _viewForm(7, "Edit City");
                      },
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
                    TextFormField(
                      // enabled: false,
                      onTap: () {
                        _viewForm(8, "Edit Website");
                      },
                      decoration: InputDecoration(
                        labelText: "Website",
                        labelStyle: GoogleFonts.abel(
                          fontSize: 14.sp,
                          color: kTextColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                        ),
                      ),
                      initialValue: website,
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
          ),
        );
        
      } else {
        return buildNoMerchantText();
      }
    }
  }

  _viewForm(int type, String title) {
    return showModalBottomSheet<void>(
      context: context, 
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          color: Colors.transparent,
          child: GestureDetector(onTap: () {
            Navigator.pop(context);
            
          },
          child: DraggableScrollableSheet(
            initialChildSize: 0.55,
            minChildSize: 0.25,
            maxChildSize: 0.55,
            builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15.0),
                      topRight: const Radius.circular(15.0),
                    ),
                  ),
                  child: Stack(children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(padding: EdgeInsets.all(16),
                          child: Text(
                            title, 
                            style: 
                              GoogleFonts.ubuntu(
                                fontSize: 16.sp,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w500,
                                color: kPrimaryColor,
                                height: 1.5,
                            ),
                          ),
                          ),
                          Padding(padding: EdgeInsets.all(16),),
                      ]),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        //padding: EdgeInsets.only(left: 16, bottom: 5),
                        child: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.red[600],
                        ),
                      ),
                    )
                    
                  ]),
                );
              },
          ),),
          
        );
  },);
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

class MyCustomFormState extends StatefulWidget {
  int ftype, state, city;
  String contcNo, contcEmail, officeAddrs, postcode;
  dynamic website, compNo;
  MyCustomFormState({
    required this.ftype,
    required this.state, 
    required this.city,
    required this.compNo,
    required this.contcEmail,
    required this.contcNo,
    required this.officeAddrs,
    required this.postcode,
    required this.website,
    });

  @override
  State<MyCustomFormState> createState() => _MyCustomFormStateState();
}

class _MyCustomFormStateState extends State<MyCustomFormState> {
  bool isLoading = false;
  bool _displayNameValid = true;

  TextEditingController companyNoController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController contactEmailController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController postcodeController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  

  CompanyState? _selectedState;
  CompanyCity? _selectedCity;

  late int _userId;

  // late dynamic selectedState;
  late StateComp state = StateComp(data: []);
  late CityComp city = CityComp(data: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    companyNoController = TextEditingController(text: widget.compNo ?? '');
    contactNoController = TextEditingController(text: widget.contcNo);
    contactEmailController = TextEditingController(text: widget.contcEmail);
    officeAddressController = TextEditingController(text: widget.officeAddrs);
    postcodeController = TextEditingController(text: widget.postcode);
    websiteController = TextEditingController(text: widget.website ?? '');

    _userId = _submitForm(userId: _userId);
  }

  ///////////////////////////////////////////////// Update Merchant ///////////////////////////////////////////////////////////////////////////////

  _submitForm({required int userId,}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final http.Response response = await http.put(
          Uri.parse(
              "http://template.gosini.xyz:8880/cspos/public/api/merchant/$userId"),
          headers: ({
            'Authorization': 'Bearer ' + prefs.getString('token').toString(),
            'Content-Type': 'application/json'
          }),
          body: JSON.jsonEncode({
            "company_no": companyNoController.text,
            "contact_no": contactNoController.text,
            "contact_email": contactEmailController.text,
            "office_address": officeAddressController.text,
            "postcode": postcodeController.text,
            "state": state.toString(),
            "city": city.toString(),
            "website": websiteController.text,
          }));

          print(response.statusCode.toString());

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String message = "Something went wrong!";
        bool hasError = true;
        print(responseData);
        if(responseData['message'] == 'success') {
          print('success >>>>>'+responseData['data']['company_no']);
          message = 'Update merchant successfully.';
        }else{
          message = responseData['message'];
          print('failed >>>>' + responseData['message']);
        }
        final Map<String, dynamic> successInformation = {
          'success': !hasError,
          'message': message
        };
        if (successInformation['success']) {
          // model._getIndexCompany();
          Navigator.pop(context, true);
          print("Profile info successfuly updated.");
        } else {
          print("Failed to update profile info.");
        }
      } else {
        print('Server error code >>>>' + response.statusCode.toString());
      }
    } catch (e) {
      print(e);
    }
    //////////////////////////////////////////////////////////////// Update State //////////////////////////////////////////////////////////////////
    Future<List<CompanyState>> _getUpdateStateList() async {
      Uri uri = Uri.parse(
          "http://template.gosini.xyz:8880/cspos/public/api/lookup/state");
      var response = await http.get(uri);
      Map<String, dynamic> json = jsonDecode(response.body);
      final stateComp = StateComp.fromJson(json);
      return stateComp.data;
    }

    ///////////////////////////////////////////////////////////////// Update City ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Future<List<CompanyCity>> _getUpdateCityList({required int stateId}) async {
      Uri uri = Uri.parse(
          "http://template.gosini.xyz:8880/cspos/public/api/lookup/city/$stateId");
      var response = await http.get(uri);
      print(response.body);
      Map<String, dynamic> json = jsonDecode(response.body);
      final cityComp = CityComp.fromJson(json);
      return cityComp.data;
    }

    setState(() {
      isLoading = false;
    });

    
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        height: MediaQuery.of(context).size.height / 2.35, 
        child: Stack(children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            widget.ftype == 1 ? buildCompanyNoField(): 
            widget.ftype == 2 ? buildContactNoField() : 
            widget.ftype == 3 ? buildContactEmailField() : 
            widget.ftype == 4 ? buildOfficeAddressField() : 
            widget.ftype == 5 ? buildPostCode() : 
            widget.ftype == 6 ? buildState() : 
            widget.ftype == 7 ? buildCity() : buildWebsite(),],),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Color(0xffcb3124),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4),),),
                ),
                onPressed: () =>  _submitForm(userId: _userId), 
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text("Submit", 
                  style: GoogleFonts.abel(
                      fontSize: 14.sp,
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),),
            ),)
        ]),
        ),
    );
  }

  TextFormField buildCompanyNoField() {
    return TextFormField(
      validator: (value) {
        if(value == null || value.isEmpty) {
          return "Please enter new Company Number";
        }
        return null;
      },
      controller: companyNoController,
      decoration: InputDecoration(labelText: "Company Number", 
      labelStyle: GoogleFonts.abel(
          fontSize: 14.sp,
          color: kTextColor,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
        ),
        errorText: _displayNameValid ? null : "Company Number missing.",
      ),
    );
  }

  TextFormField buildContactNoField() {
    return TextFormField();
  }

  TextFormField buildContactEmailField() {
    return TextFormField();
  }
  TextFormField buildOfficeAddressField() {
    return TextFormField();
  }
  TextFormField buildPostCode() {
    return TextFormField();
  }
  TextFormField buildState() {
    return TextFormField();
  }
  TextFormField buildCity() {
    return TextFormField();
  }
  TextFormField buildWebsite() {
    return TextFormField();
  }
}


