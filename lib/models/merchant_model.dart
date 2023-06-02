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

////////////////////////////////////////////////////////////////
///
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
