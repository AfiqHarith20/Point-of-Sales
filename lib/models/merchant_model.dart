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
  String message;
  List<StateComp> data;

  StateComp({
    required this.message,
    required this.data,
  });
}

class Datum {
  int id;
  String stateName;
  dynamic countryId;

  Datum({
    required this.id,
    required this.stateName,
    this.countryId,
  });
}
