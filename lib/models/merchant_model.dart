import 'dart:convert';

class Merchant {
  String companyName;
  String contactNo;
  String contactEmail;
  String officeAddress;
  String postcode;
  String state;
  String city;

  Merchant({
    required this.companyName,
    required this.contactNo,
    required this.contactEmail,
    required this.officeAddress,
    required this.postcode,
    required this.state,
    required this.city,
  });
}

/////////////////////////////////////////// State Company /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class StateComp {
  List<CompanyState> data;

  StateComp({
    required this.data,
  });

  factory StateComp.fromJson(Map<String, dynamic> json) => StateComp(
        data: List<CompanyState>.from(
          json["data"].map((x) => CompanyState.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(
          data.map((x) => x.toJson()),
        ),
      };
}

class CompanyState {
  int id;
  String stateName;
  dynamic countryId;

  CompanyState({
    required this.id,
    required this.stateName,
    this.countryId,
  });

  factory CompanyState.fromJson(Map<String, dynamic> json) => CompanyState(
        id: json['id'],
        stateName: json['state_name'],
        countryId: json['country_id'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_name": stateName,
        "country_id": countryId,
      };
}

StateComp stateModelFromJson(String str) =>
    StateComp.fromJson(json.decode(str));

String stateModelToJson(StateComp data) => json.encode(data.toJson());

////////////////////////////// City Company //////////////////////////////////////////////////////////
///
class CityComp {
  List<CompanyCity> data;

  CityComp({
    required this.data,
  });

  factory CityComp.fromJson(Map<String, dynamic> json) => CityComp(
        data: List<CompanyCity>.from(
          json["data"].map((x) => CompanyCity.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(
          data.map((x) => x.toJson()),
        ),
      };
}

class CompanyCity {
  int id;
  int stateId;
  String cityName;

  CompanyCity({
    required this.id,
    required this.stateId,
    required this.cityName,
  });

  factory CompanyCity.fromJson(Map<String, dynamic> json) => CompanyCity(
        id: json['id'],
        cityName: json['city_name'],
        stateId: json['state_id'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city_name": cityName,
        "state_id": stateId,
      };
}

CityComp cityModelFromJson(String str) => CityComp.fromJson(json.decode(str));

String cityModelToJson(CityComp data) => json.encode(data.toJson());

/////////////////////////////////////// Upload Image ////////////////////////////////////////////////////////////

class UploadLogo {
  int merchantId;
  String merchantLogo;

  UploadLogo({
    required this.merchantId,
    required this.merchantLogo,
  });
}

//////////////////////////////////// Merchant Details //////////////////////////////////////////////////////////////////////

class MerchantDetail {
  final int id;
  final int userId;
  final String companyName;
  final dynamic companyNo;
  final dynamic businessOwnership;
  final dynamic businessDuration;
  final dynamic brandName;
  final dynamic businessNature;
  final dynamic contactName;
  final String contactNo;
  final String contactEmail;
  final String officeAddress;
  final String postcode;
  final int state;
  final int city;
  final dynamic website;
  final dynamic facebook;
  final dynamic instagram;
  final dynamic referrer;
  final dynamic shopUrl;
  final int status;
  final dynamic gstNo;
  final int feePercentage;
  final int feeMinimum;
  final dynamic logoUrl;

  MerchantDetail({
    required this.id,
    required this.userId,
    required this.companyName,
    this.companyNo,
    this.businessOwnership,
    this.businessDuration,
    this.brandName,
    this.businessNature,
    this.contactName,
    required this.contactNo,
    required this.contactEmail,
    required this.officeAddress,
    required this.postcode,
    required this.state,
    required this.city,
    this.website,
    this.facebook,
    this.instagram,
    this.referrer,
    this.shopUrl,
    required this.status,
    this.gstNo,
    required this.feePercentage,
    required this.feeMinimum,
    this.logoUrl,
  });

  // factory MerchantDetail.fromJson(Map<String, dynamic> json) {
  //   return MerchantDetail(
  //     id: json['id'],
  //     userId: json['user_id'],
  //     companyName: json['company_name'],
  //     companyNo: json['company_no'],
  //     businessOwnership: json['business_ownership'],
  //     businessDuration: json['business_duration'],
  //     brandName: json['brand_name'],
  //     businessNature: json['business_nature'],
  //     contactName: json['contact_name'],
  //     contactNo: json['contact_no'],
  //     contactEmail: json['contact_email'],
  //     officeAddress: json['office_address'],
  //     postcode: json['postcode'],
  //     state: json['state'],
  //     city: json['city'],
  //     website: json['website'],
  //     facebook: json['facebook'],
  //     instagram: json['instagram'],
  //     referrer: json['referrer'],
  //     shopUrl: json['shop_url'],
  //     status: json['status'],
  //     gstNo: json['gst_no'],
  //     feePercentage: json['fee_percentage'],
  //     feeMinimum: json['fee_minimum'],
  //     logoUrl: json['logo_url'],
  //   );
  // }
}
