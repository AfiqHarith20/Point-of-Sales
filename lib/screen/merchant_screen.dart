// ignore_for_file: unused_label, unnecessary_statements

import 'dart:convert' as JSON;
import 'dart:convert';
import 'dart:io';

import 'package:gsform/gs_form/widget/form.dart';
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

  int getState() {
    return state;
  }

  int getCity() {
    return city;
  }

  String getCompanyNo() {
    return companyNo;
  }

  String getContactNo() {
    return contactNo;
  }

  String getContactEmail() {
    return contactEmail;
  }

  String getOfficeAddress() {
    return officeAddress;
  }

  String getPostcode() {
    return postcode;
  }

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
              
              status: res['data']['status'],
              
              feePercentage: res['data']['feePercentage'],
              feeMinimum: res['data']['feeMinimum'],
              
            );

            
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
          body: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration(seconds: 1),
              (){
                setState(() {
                  _getIndexCompany();
                });
              }
              );
            },
            child: Form(
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
                        onTap: () {
                          _viewForm(1, "Edit Company Number");
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
                          _viewForm(6, "Edit State and City");
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
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                            builder: (context) => MerchantScreen(),),);
                        },
                        child: Text("Refresh Page")
                      ),
                    ],
                  ),
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
////////////////////////////////// ViewForm //////////////////////////////////////////////////////////////////

  _viewForm(int type, String title) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
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
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              title,
                              style: GoogleFonts.ubuntu(
                                fontSize: 16.sp,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w500,
                                color: kPrimaryColor,
                                height: 1.5,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: MyCustomFormState(
                                ftype: type,
                                state: state,
                                city: city,
                                compNo: companyNo,
                                contcEmail: contactEmail,
                                contcNo: contactNo,
                                officeAddrs: officeAddress,
                                postcode: postcode,
                                website: website,
                              ),
                            ),
                          ),
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
            ),
          ),
        );
      },
    );
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


  late GSForm form;
  late Future<List<CompanyState>> _state;
  late Future<List<CompanyCity>> _city;
  int? _selectedStateId;
  CompanyState? _selectedState;
  CompanyCity? _selectedCity;

  // late dynamic selectedState;
  late StateComp state = StateComp(data: []);
  late CityComp city = CityComp(data: []);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    companyNoController = TextEditingController(text: widget.compNo ?? '');
    contactNoController = TextEditingController(text: widget.contcNo ?? '');
    contactEmailController =
        TextEditingController(text: widget.contcEmail ?? '');
    officeAddressController =
        TextEditingController(text: widget.officeAddrs ?? '');
    postcodeController = TextEditingController(text: widget.postcode ?? '');
    websiteController = TextEditingController(text: widget.website ?? '');

    _state = _getUpdateStateList();
    _state.then(
      (states) {
        if (states.isNotEmpty) {
          _selectedStateId = _selectedState?.id;
          _city = _getUpdateCityList(stateId: _selectedStateId!);
        }
      },
    ).catchError((error) {
      // Handle the error gracefully
      print('Error occurred while fetching state list: $error');
    });
    _city = _getUpdateCityList(stateId: _selectedState?.id ?? 0);
  }

  ///////////////////////////////////////////////// Update Merchant ///////////////////////////////////////////////////////////////////////////////

  _submitForm() async {
    try {
      print(companyNoController.text);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final Map<String, dynamic> companyData = {
        "company_no": companyNoController.text,
        "contact_no": contactNoController.text,
        "contact_email": contactEmailController.text,
        "office_address": officeAddressController.text,
        "postcode": postcodeController.text,
        "state": _selectedStateId,
        "city": _selectedCity!.id,
        "website": websiteController.text,
      };

      final http.Response response = await http.put(
        Uri.parse(
            "http://template.gosini.xyz:8880/cspos/public/api/merchant/3"),
        headers: {
          'Authorization': 'Bearer ' + prefs.getString('token').toString(),
          'Content-Type': 'application/json'
        },
        body: JSON.jsonEncode(companyData),
      );

      print(response.statusCode.toString());

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['message'] == 'success') {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Text("Update Successful", 
              style: GoogleFonts.ubuntu(
                    fontSize: 16.sp,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              content: Text("The form has been updated successfully", 
              style: GoogleFonts.ubuntu(
                    fontSize: 14.sp,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor,
                  ),
                ),
              actions: [
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                }, child: Text("OK"),),
              ],
            );
          },);
          
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

   @override
  void dispose() {
    companyNoController.dispose();
    contactNoController.dispose();
    contactEmailController.dispose();
    officeAddressController.dispose();
    postcodeController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////// Update State //////////////////////////////////////////////////////////////////
  Future<List<CompanyState>> _getUpdateStateList() async {
   try {
      Uri uri = Uri.parse(
          "http://template.gosini.xyz:8880/cspos/public/api/lookup/state");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        final stateComp = StateComp.fromJson(json);
        return stateComp.data;
      } else {
        // Handle the error or return a fallback value
        print(
            'Error occurred while fetching state list. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Handle the error or return a fallback value
      print('Error occurred while fetching state list: $error');
      return [];
    }
  }

  ///////////////////////////////////////////////////////////////// Update City ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<List<CompanyCity>> _getUpdateCityList({required int stateId}) async {
    try {
      Uri uri = Uri.parse(
          "http://template.gosini.xyz:8880/cspos/public/api/lookup/city/$stateId");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        final cityComp = CityComp.fromJson(json);
        return cityComp.data;
      } else {
        // Handle the error or return a fallback value
        print(
            'Error occurred while fetching city list. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Handle the error or return a fallback value
      print('Error occurred while fetching city list: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        height: MediaQuery.of(context).size.height / 2.35,
        child: Stack(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              widget.ftype == 1
                  ? buildCompanyNoField()
                  : widget.ftype == 2
                      ? buildContactNoField()
                      : widget.ftype == 3
                          ? buildContactEmailField()
                          : widget.ftype == 4
                              ? buildOfficeAddressField()
                              : widget.ftype == 5
                                  ? buildPostCode()
                                  : widget.ftype == 6
                                      ? buildStateCity()
                                      :
                                      // widget.ftype == 7 ? buildCity() :
                                      buildWebsite(),
            ],
          ),
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                ),
                onPressed: () {
                  _submitForm;
                  
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    "Submit",
                    style: GoogleFonts.abel(
                      fontSize: 14.sp,
                      color: kTextColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  TextFormField buildCompanyNoField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          setState(() {
            _displayNameValid = false;
          });
          return "Please enter new Company Number";
        }
        setState(() {
          _displayNameValid = true;
        });
        return null;
      },
      controller: companyNoController,
      decoration: InputDecoration(
        labelText: "Company Number",
        labelStyle: GoogleFonts.abel(
          fontSize: 14.sp,
          color: kScaffoldColor,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
        ),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        errorText: _displayNameValid ? null : "Company Number is missing.",
      ),
    );
  }

  TextFormField buildContactNoField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a company number.";
        }
        return null;
      },
      keyboardType: TextInputType.phone,
      controller: contactNoController,
      decoration: InputDecoration(
          labelText: "Mobile Number",
          labelStyle: GoogleFonts.abel(
            fontSize: 14.sp,
            color: kScaffoldColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
          focusColor: Colors.grey.shade500,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
          errorText: _displayNameValid ? null : "Mobile number is missing."),
    );
  }

  TextFormField buildContactEmailField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a company email address.";
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      controller: contactEmailController,
      decoration: InputDecoration(
          labelText: "E-mail",
          labelStyle: GoogleFonts.abel(
            fontSize: 14.sp,
            color: kScaffoldColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
          focusColor: Colors.grey.shade500,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
          errorText: _displayNameValid ? null : "Email address is missing."),
    );
  }

  TextFormField buildOfficeAddressField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a office address.";
        }
        return null;
      },
      controller: officeAddressController,
      decoration: InputDecoration(
          labelText: "Office Address",
          labelStyle: GoogleFonts.abel(
            fontSize: 14.sp,
            color: kScaffoldColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
          focusColor: Colors.grey.shade500,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
          errorText: _displayNameValid ? null : "Office Address is missing."),
    );
  }

  TextFormField buildPostCode() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter a postcode office.";
        }
        return null;
      },
      keyboardType: TextInputType.phone,
      controller: postcodeController,
      decoration: InputDecoration(
          labelText: "Postcode",
          labelStyle: GoogleFonts.abel(
            fontSize: 14.sp,
            color: kScaffoldColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
          focusColor: Colors.grey.shade500,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
          ),
          errorText: _displayNameValid ? null : "Postcode is missing."),
    );
  }

  Widget buildStateCity() {
    return GSForm.singleSection(
              context,
              fields: [
                Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "State",
            style: TextStyle(
              color: kScaffoldColor,
              fontSize: 14.sp,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height:0.5.h),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kTextColor,
                  ),
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: FutureBuilder<List<CompanyState>>(
                      future: _state,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.data == null) {
                          return const CircularProgressIndicator();
                        }
                        return DropdownButton<CompanyState>(
                            icon: FaIcon(
                              FontAwesomeIcons.chevronDown,
                              size: 15,
                              color: kLabel,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            isExpanded: true,
                            hint: Text(
                              "Select State",
                              style: TextStyle(
                                color: kHint,
                                fontSize: 10.sp,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onChanged: (state) {
                              setState(() {
                                _selectedState = state;
                                _selectedStateId = state!.id;
                                _selectedCity = null;
                                _city = _getUpdateCityList(
                                    stateId: _selectedStateId!);
                              });
                            },
                            value: _selectedState,
                            items: [
                              ...snapshot.data!.map(
                                (state) => DropdownMenuItem(
                                  value: state,
                                  child: Row(children: [
                                    Text('${state.stateName}',
                                        style: TextStyle(
                                          color: kForm,
                                          fontSize: 12.sp,
                                          letterSpacing: 1.0,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ]),
                                ),
                              ),
                            ]);
                      }),
                ),
                SizedBox(
                  height: 1.0.h,
                ),
                Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "City",
            style: TextStyle(
              color: kScaffoldColor,
              fontSize: 14.sp,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: 0.5.h,
        ),
                Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kTextColor,
          ),
          width: double.infinity,
          height: 50,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: FutureBuilder<List<CompanyCity>>(
              future: _city,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No cities available');
                }
                print('City data: ${snapshot.data}');
                return IgnorePointer(
                  ignoring: _selectedState == null,
                  child: Opacity(
                    opacity: _selectedState == null ? 0.5 : 1.0,
                    child: DropdownButton<CompanyCity>(
                        icon: FaIcon(
                          FontAwesomeIcons.chevronDown,
                          size: 15,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        isExpanded: true,
                        hint: Text(
                          "Select City",
                          style: TextStyle(
                            color: kHint,
                            fontSize: 10.sp,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onChanged: (city) => setState(
                              () => _selectedCity = city,
                            ),
                        value: _selectedCity,
                        items: [
                          ...snapshot.data!.map(
                            (city) => DropdownMenuItem(
                              value: city,
                              child: Row(children: [
                                Text(
                                  '${city.cityName}',
                                  style: TextStyle(
                                    color: kForm,
                                    fontSize: 12.sp,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ]),
                  ),
                );
              }),
        ),
              ],
            );
  }

  TextFormField buildWebsite() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter new Website Link";
        }
        return null;
      },
      controller: websiteController,
      decoration: InputDecoration(
        labelText: "Website",
        labelStyle: GoogleFonts.abel(
          fontSize: 14.sp,
          color: kScaffoldColor,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
        ),
        focusColor: Colors.grey.shade500,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
        ),
        errorText: _displayNameValid ? null : "Website link is missing.",
      ),
    );
  }
}
