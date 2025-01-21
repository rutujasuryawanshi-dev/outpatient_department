/// sCode : 200
/// sMessage : "Staff clinics fetched successfully"
/// sData : {"sAttachedClinics":[{"iClinicID":"479","iClinicCode":"TH-A01","iClinicName":"Chavan","iRegistrationNo":null,"iClinicAddress":"Pune,Maharashtra,India","iClinicCity":"Pune","iClinicState":"Maharashtra","iClinicCountry":"India","iClinicPincode":"","iClinicMobile":"","iClinicEmail":"","iClinicUPIID":null,"iClinicLogo":"CLINIC_TH-A01_LOGO_a334aaacf9ec679164247dae014e3cc2.jpeg","iHFRID":null,"iHIPID":null,"iHIUID":null,"iAddedOn":"2024-12-27 05:52:21"}]}

class SelectStaffResponse {
  SelectStaffResponse({
      num? sCode, 
      String? sMessage, 
      SData? sData,}){
    _sCode = sCode;
    _sMessage = sMessage;
    _sData = sData;
}

  SelectStaffResponse.fromJson(dynamic json) {
    _sCode = json['sCode'];
    _sMessage = json['sMessage'];
    _sData = json['sData'] != null ? SData.fromJson(json['sData']) : null;
  }
  num? _sCode;
  String? _sMessage;
  SData? _sData;
SelectStaffResponse copyWith({  num? sCode,
  String? sMessage,
  SData? sData,
}) => SelectStaffResponse(  sCode: sCode ?? _sCode,
  sMessage: sMessage ?? _sMessage,
  sData: sData ?? _sData,
);
  num? get sCode => _sCode;
  String? get sMessage => _sMessage;
  SData? get sData => _sData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sCode'] = _sCode;
    map['sMessage'] = _sMessage;
    if (_sData != null) {
      map['sData'] = _sData?.toJson();
    }
    return map;
  }

}

/// sAttachedClinics : [{"iClinicID":"479","iClinicCode":"TH-A01","iClinicName":"Chavan","iRegistrationNo":null,"iClinicAddress":"Pune,Maharashtra,India","iClinicCity":"Pune","iClinicState":"Maharashtra","iClinicCountry":"India","iClinicPincode":"","iClinicMobile":"","iClinicEmail":"","iClinicUPIID":null,"iClinicLogo":"CLINIC_TH-A01_LOGO_a334aaacf9ec679164247dae014e3cc2.jpeg","iHFRID":null,"iHIPID":null,"iHIUID":null,"iAddedOn":"2024-12-27 05:52:21"}]

class SData {
  SData({
      List<SAttachedClinics>? sAttachedClinics,}){
    _sAttachedClinics = sAttachedClinics;
}

  SData.fromJson(dynamic json) {
    if (json['sAttachedClinics'] != null) {
      _sAttachedClinics = [];
      json['sAttachedClinics'].forEach((v) {
        _sAttachedClinics?.add(SAttachedClinics.fromJson(v));
      });
    }
  }
  List<SAttachedClinics>? _sAttachedClinics;
SData copyWith({  List<SAttachedClinics>? sAttachedClinics,
}) => SData(  sAttachedClinics: sAttachedClinics ?? _sAttachedClinics,
);
  List<SAttachedClinics>? get sAttachedClinics => _sAttachedClinics;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_sAttachedClinics != null) {
      map['sAttachedClinics'] = _sAttachedClinics?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// iClinicID : "479"
/// iClinicCode : "TH-A01"
/// iClinicName : "Chavan"
/// iRegistrationNo : null
/// iClinicAddress : "Pune,Maharashtra,India"
/// iClinicCity : "Pune"
/// iClinicState : "Maharashtra"
/// iClinicCountry : "India"
/// iClinicPincode : ""
/// iClinicMobile : ""
/// iClinicEmail : ""
/// iClinicUPIID : null
/// iClinicLogo : "CLINIC_TH-A01_LOGO_a334aaacf9ec679164247dae014e3cc2.jpeg"
/// iHFRID : null
/// iHIPID : null
/// iHIUID : null
/// iAddedOn : "2024-12-27 05:52:21"

class SAttachedClinics {
  SAttachedClinics({
      String? iClinicID, 
      String? iClinicCode, 
      String? iClinicName, 
      dynamic iRegistrationNo, 
      String? iClinicAddress, 
      String? iClinicCity, 
      String? iClinicState, 
      String? iClinicCountry, 
      String? iClinicPincode, 
      String? iClinicMobile, 
      String? iClinicEmail, 
      dynamic iClinicUPIID, 
      String? iClinicLogo, 
      dynamic iHFRID, 
      dynamic iHIPID, 
      dynamic iHIUID, 
      String? iAddedOn,}){
    _iClinicID = iClinicID;
    _iClinicCode = iClinicCode;
    _iClinicName = iClinicName;
    _iRegistrationNo = iRegistrationNo;
    _iClinicAddress = iClinicAddress;
    _iClinicCity = iClinicCity;
    _iClinicState = iClinicState;
    _iClinicCountry = iClinicCountry;
    _iClinicPincode = iClinicPincode;
    _iClinicMobile = iClinicMobile;
    _iClinicEmail = iClinicEmail;
    _iClinicUPIID = iClinicUPIID;
    _iClinicLogo = iClinicLogo;
    _iHFRID = iHFRID;
    _iHIPID = iHIPID;
    _iHIUID = iHIUID;
    _iAddedOn = iAddedOn;
}

  SAttachedClinics.fromJson(dynamic json) {
    _iClinicID = json['iClinicID'];
    _iClinicCode = json['iClinicCode'];
    _iClinicName = json['iClinicName'];
    _iRegistrationNo = json['iRegistrationNo'];
    _iClinicAddress = json['iClinicAddress'];
    _iClinicCity = json['iClinicCity'];
    _iClinicState = json['iClinicState'];
    _iClinicCountry = json['iClinicCountry'];
    _iClinicPincode = json['iClinicPincode'];
    _iClinicMobile = json['iClinicMobile'];
    _iClinicEmail = json['iClinicEmail'];
    _iClinicUPIID = json['iClinicUPIID'];
    _iClinicLogo = json['iClinicLogo'];
    _iHFRID = json['iHFRID'];
    _iHIPID = json['iHIPID'];
    _iHIUID = json['iHIUID'];
    _iAddedOn = json['iAddedOn'];
  }
  String? _iClinicID;
  String? _iClinicCode;
  String? _iClinicName;
  dynamic _iRegistrationNo;
  String? _iClinicAddress;
  String? _iClinicCity;
  String? _iClinicState;
  String? _iClinicCountry;
  String? _iClinicPincode;
  String? _iClinicMobile;
  String? _iClinicEmail;
  dynamic _iClinicUPIID;
  String? _iClinicLogo;
  dynamic _iHFRID;
  dynamic _iHIPID;
  dynamic _iHIUID;
  String? _iAddedOn;
SAttachedClinics copyWith({  String? iClinicID,
  String? iClinicCode,
  String? iClinicName,
  dynamic iRegistrationNo,
  String? iClinicAddress,
  String? iClinicCity,
  String? iClinicState,
  String? iClinicCountry,
  String? iClinicPincode,
  String? iClinicMobile,
  String? iClinicEmail,
  dynamic iClinicUPIID,
  String? iClinicLogo,
  dynamic iHFRID,
  dynamic iHIPID,
  dynamic iHIUID,
  String? iAddedOn,
}) => SAttachedClinics(  iClinicID: iClinicID ?? _iClinicID,
  iClinicCode: iClinicCode ?? _iClinicCode,
  iClinicName: iClinicName ?? _iClinicName,
  iRegistrationNo: iRegistrationNo ?? _iRegistrationNo,
  iClinicAddress: iClinicAddress ?? _iClinicAddress,
  iClinicCity: iClinicCity ?? _iClinicCity,
  iClinicState: iClinicState ?? _iClinicState,
  iClinicCountry: iClinicCountry ?? _iClinicCountry,
  iClinicPincode: iClinicPincode ?? _iClinicPincode,
  iClinicMobile: iClinicMobile ?? _iClinicMobile,
  iClinicEmail: iClinicEmail ?? _iClinicEmail,
  iClinicUPIID: iClinicUPIID ?? _iClinicUPIID,
  iClinicLogo: iClinicLogo ?? _iClinicLogo,
  iHFRID: iHFRID ?? _iHFRID,
  iHIPID: iHIPID ?? _iHIPID,
  iHIUID: iHIUID ?? _iHIUID,
  iAddedOn: iAddedOn ?? _iAddedOn,
);
  String? get iClinicID => _iClinicID;
  String? get iClinicCode => _iClinicCode;
  String? get iClinicName => _iClinicName;
  dynamic get iRegistrationNo => _iRegistrationNo;
  String? get iClinicAddress => _iClinicAddress;
  String? get iClinicCity => _iClinicCity;
  String? get iClinicState => _iClinicState;
  String? get iClinicCountry => _iClinicCountry;
  String? get iClinicPincode => _iClinicPincode;
  String? get iClinicMobile => _iClinicMobile;
  String? get iClinicEmail => _iClinicEmail;
  dynamic get iClinicUPIID => _iClinicUPIID;
  String? get iClinicLogo => _iClinicLogo;
  dynamic get iHFRID => _iHFRID;
  dynamic get iHIPID => _iHIPID;
  dynamic get iHIUID => _iHIUID;
  String? get iAddedOn => _iAddedOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['iClinicID'] = _iClinicID;
    map['iClinicCode'] = _iClinicCode;
    map['iClinicName'] = _iClinicName;
    map['iRegistrationNo'] = _iRegistrationNo;
    map['iClinicAddress'] = _iClinicAddress;
    map['iClinicCity'] = _iClinicCity;
    map['iClinicState'] = _iClinicState;
    map['iClinicCountry'] = _iClinicCountry;
    map['iClinicPincode'] = _iClinicPincode;
    map['iClinicMobile'] = _iClinicMobile;
    map['iClinicEmail'] = _iClinicEmail;
    map['iClinicUPIID'] = _iClinicUPIID;
    map['iClinicLogo'] = _iClinicLogo;
    map['iHFRID'] = _iHFRID;
    map['iHIPID'] = _iHIPID;
    map['iHIUID'] = _iHIUID;
    map['iAddedOn'] = _iAddedOn;
    return map;
  }

}