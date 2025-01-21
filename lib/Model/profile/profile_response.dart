/// sCode : 200
/// sMessage : "Profile details fetched successfully"
/// sData : {"sUserProfileDetails":{"iStaffID":"12391","iStaffNo":"NAA64-12390-P","iStaffName":"Sukrut Hindlekar","iStaffAddress":"","iStaffMobile":"9552045547","iStaffEmail":"sukrut.hindlekar@plus91.in","iStaffGender":"Male","iStaffDob":"06-01-2005","iStaffType":"Doctor","iClinicID":"380","iAddedOn":"2024-09-26 12:18:01","iTimeslot":"20","iProfileImage":"images/male-thumbnail.png","iQualification":"MBBS","iDesignation":"Manager"},"sClinicDetails":{"iClinicID":"380","iClinicCode":"PU-B92","iClinicName":"Lifewave Health","iRegistrationNo":"AB-8748-09","iClinicAddress":"601/A, East Court, Next to Phoenix Market City, Off, Nagar Rd, Viman Nagar, Pune, Maharashtra 411014","iClinicCity":"viman nagar Pune","iClinicState":"Maharashtra","iClinicCountry":"India","iClinicPincode":"411014","iClinicMobile":"9589874858","iClinicEmail":"clinic@gmail.com","iClinicUPIID":"sukruthindlekar93@okhdfcbank","iClinicLogo":"CLINIC__LOGO_045c3c7402afe013fa6f36a1e84d188d..png","iHFRID":"IN2710029203","iHIPID":"IN2710029203","iHIUID":"IN2710029203","iAddedOn":"2024-03-19 06:18:35"}}

class ProfileResponse {
  ProfileResponse({
    num? sCode,
    String? sMessage,
    SData? sData,}){
    _sCode = sCode;
    _sMessage = sMessage;
    _sData = sData;
  }

  ProfileResponse.fromJson(dynamic json) {
    _sCode = json['sCode'];
    _sMessage = json['sMessage'];
    _sData = json['sData'] != null ? SData.fromJson(json['sData']) : null;
  }
  num? _sCode;
  String? _sMessage;
  SData? _sData;
  ProfileResponse copyWith({  num? sCode,
    String? sMessage,
    SData? sData,
  }) => ProfileResponse(  sCode: sCode ?? _sCode,
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

/// sUserProfileDetails : {"iStaffID":"12391","iStaffNo":"NAA64-12390-P","iStaffName":"Sukrut Hindlekar","iStaffAddress":"","iStaffMobile":"9552045547","iStaffEmail":"sukrut.hindlekar@plus91.in","iStaffGender":"Male","iStaffDob":"06-01-2005","iStaffType":"Doctor","iClinicID":"380","iAddedOn":"2024-09-26 12:18:01","iTimeslot":"20","iProfileImage":"images/male-thumbnail.png","iQualification":"MBBS","iDesignation":"Manager"}
/// sClinicDetails : {"iClinicID":"380","iClinicCode":"PU-B92","iClinicName":"Lifewave Health","iRegistrationNo":"AB-8748-09","iClinicAddress":"601/A, East Court, Next to Phoenix Market City, Off, Nagar Rd, Viman Nagar, Pune, Maharashtra 411014","iClinicCity":"viman nagar Pune","iClinicState":"Maharashtra","iClinicCountry":"India","iClinicPincode":"411014","iClinicMobile":"9589874858","iClinicEmail":"clinic@gmail.com","iClinicUPIID":"sukruthindlekar93@okhdfcbank","iClinicLogo":"CLINIC__LOGO_045c3c7402afe013fa6f36a1e84d188d..png","iHFRID":"IN2710029203","iHIPID":"IN2710029203","iHIUID":"IN2710029203","iAddedOn":"2024-03-19 06:18:35"}

class SData {
  SData({
    SUserProfileDetails? sUserProfileDetails,
    SClinicDetails? sClinicDetails,}){
    _sUserProfileDetails = sUserProfileDetails;
    _sClinicDetails = sClinicDetails;
  }

  SData.fromJson(dynamic json) {
    _sUserProfileDetails = json['sUserProfileDetails'] != null ? SUserProfileDetails.fromJson(json['sUserProfileDetails']) : null;
    _sClinicDetails = json['sClinicDetails'] != null ? SClinicDetails.fromJson(json['sClinicDetails']) : null;
  }
  SUserProfileDetails? _sUserProfileDetails;
  SClinicDetails? _sClinicDetails;
  SData copyWith({  SUserProfileDetails? sUserProfileDetails,
    SClinicDetails? sClinicDetails,
  }) => SData(  sUserProfileDetails: sUserProfileDetails ?? _sUserProfileDetails,
    sClinicDetails: sClinicDetails ?? _sClinicDetails,
  );
  SUserProfileDetails? get sUserProfileDetails => _sUserProfileDetails;
  SClinicDetails? get sClinicDetails => _sClinicDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_sUserProfileDetails != null) {
      map['sUserProfileDetails'] = _sUserProfileDetails?.toJson();
    }
    if (_sClinicDetails != null) {
      map['sClinicDetails'] = _sClinicDetails?.toJson();
    }
    return map;
  }

}

/// iClinicID : "380"
/// iClinicCode : "PU-B92"
/// iClinicName : "Lifewave Health"
/// iRegistrationNo : "AB-8748-09"
/// iClinicAddress : "601/A, East Court, Next to Phoenix Market City, Off, Nagar Rd, Viman Nagar, Pune, Maharashtra 411014"
/// iClinicCity : "viman nagar Pune"
/// iClinicState : "Maharashtra"
/// iClinicCountry : "India"
/// iClinicPincode : "411014"
/// iClinicMobile : "9589874858"
/// iClinicEmail : "clinic@gmail.com"
/// iClinicUPIID : "sukruthindlekar93@okhdfcbank"
/// iClinicLogo : "CLINIC__LOGO_045c3c7402afe013fa6f36a1e84d188d..png"
/// iHFRID : "IN2710029203"
/// iHIPID : "IN2710029203"
/// iHIUID : "IN2710029203"
/// iAddedOn : "2024-03-19 06:18:35"

class SClinicDetails {
  SClinicDetails({
    String? iClinicID,
    String? iClinicCode,
    String? iClinicName,
    String? iRegistrationNo,
    String? iClinicAddress,
    String? iClinicCity,
    String? iClinicState,
    String? iClinicCountry,
    String? iClinicPincode,
    String? iClinicMobile,
    String? iClinicEmail,
    String? iClinicUPIID,
    String? iClinicLogo,
    String? iHFRID,
    String? iHIPID,
    String? iHIUID,
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

  SClinicDetails.fromJson(dynamic json) {
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
  String? _iRegistrationNo;
  String? _iClinicAddress;
  String? _iClinicCity;
  String? _iClinicState;
  String? _iClinicCountry;
  String? _iClinicPincode;
  String? _iClinicMobile;
  String? _iClinicEmail;
  String? _iClinicUPIID;
  String? _iClinicLogo;
  String? _iHFRID;
  String? _iHIPID;
  String? _iHIUID;
  String? _iAddedOn;
  SClinicDetails copyWith({  String? iClinicID,
    String? iClinicCode,
    String? iClinicName,
    String? iRegistrationNo,
    String? iClinicAddress,
    String? iClinicCity,
    String? iClinicState,
    String? iClinicCountry,
    String? iClinicPincode,
    String? iClinicMobile,
    String? iClinicEmail,
    String? iClinicUPIID,
    String? iClinicLogo,
    String? iHFRID,
    String? iHIPID,
    String? iHIUID,
    String? iAddedOn,
  }) => SClinicDetails(  iClinicID: iClinicID ?? _iClinicID,
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
  String? get iRegistrationNo => _iRegistrationNo;
  String? get iClinicAddress => _iClinicAddress;
  String? get iClinicCity => _iClinicCity;
  String? get iClinicState => _iClinicState;
  String? get iClinicCountry => _iClinicCountry;
  String? get iClinicPincode => _iClinicPincode;
  String? get iClinicMobile => _iClinicMobile;
  String? get iClinicEmail => _iClinicEmail;
  String? get iClinicUPIID => _iClinicUPIID;
  String? get iClinicLogo => _iClinicLogo;
  String? get iHFRID => _iHFRID;
  String? get iHIPID => _iHIPID;
  String? get iHIUID => _iHIUID;
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

/// iStaffID : "12391"
/// iStaffNo : "NAA64-12390-P"
/// iStaffName : "Sukrut Hindlekar"
/// iStaffAddress : ""
/// iStaffMobile : "9552045547"
/// iStaffEmail : "sukrut.hindlekar@plus91.in"
/// iStaffGender : "Male"
/// iStaffDob : "06-01-2005"
/// iStaffType : "Doctor"
/// iClinicID : "380"
/// iAddedOn : "2024-09-26 12:18:01"
/// iTimeslot : "20"
/// iProfileImage : "images/male-thumbnail.png"
/// iQualification : "MBBS"
/// iDesignation : "Manager"

class SUserProfileDetails {
  SUserProfileDetails({
    String? iStaffID,
    String? iStaffNo,
    String? iStaffName,
    String? iStaffAddress,
    String? iStaffMobile,
    String? iStaffEmail,
    String? iStaffGender,
    String? iStaffDob,
    String? iStaffType,
    String? iClinicID,
    String? iAddedOn,
    String? iTimeslot,
    String? iProfileImage,
    String? iQualification,
    String? iDesignation,}){
    _iStaffID = iStaffID;
    _iStaffNo = iStaffNo;
    _iStaffName = iStaffName;
    _iStaffAddress = iStaffAddress;
    _iStaffMobile = iStaffMobile;
    _iStaffEmail = iStaffEmail;
    _iStaffGender = iStaffGender;
    _iStaffDob = iStaffDob;
    _iStaffType = iStaffType;
    _iClinicID = iClinicID;
    _iAddedOn = iAddedOn;
    _iTimeslot = iTimeslot;
    _iProfileImage = iProfileImage;
    _iQualification = iQualification;
    _iDesignation = iDesignation;
  }

  SUserProfileDetails.fromJson(dynamic json) {
    _iStaffID = json['iStaffID'];
    _iStaffNo = json['iStaffNo'];
    _iStaffName = json['iStaffName'];
    _iStaffAddress = json['iStaffAddress'];
    _iStaffMobile = json['iStaffMobile'];
    _iStaffEmail = json['iStaffEmail'];
    _iStaffGender = json['iStaffGender'];
    _iStaffDob = json['iStaffDob'];
    _iStaffType = json['iStaffType'];
    _iClinicID = json['iClinicID'];
    _iAddedOn = json['iAddedOn'];
    _iTimeslot = json['iTimeslot'];
    _iProfileImage = json['iProfileImage'];
    _iQualification = json['iQualification'];
    _iDesignation = json['iDesignation'];
  }

  String? _iStaffID;
  String? _iStaffNo;
  String? _iStaffName;
  String? _iStaffAddress;
  String? _iStaffMobile;
  String? _iStaffEmail;
  String? _iStaffGender;
  String? _iStaffDob;
  String? _iStaffType;
  String? _iClinicID;
  String? _iAddedOn;
  String? _iTimeslot;
  String? _iProfileImage;
  String? _iQualification;
  String? _iDesignation;
  SUserProfileDetails copyWith({  String? iStaffID,
    String? iStaffNo,
    String? iStaffName,
    String? iStaffAddress,
    String? iStaffMobile,
    String? iStaffEmail,
    String? iStaffGender,
    String? iStaffDob,
    String? iStaffType,
    String? iClinicID,
    String? iAddedOn,
    String? iTimeslot,
    String? iProfileImage,
    String? iQualification,
    String? iDesignation,
  }) => SUserProfileDetails(  iStaffID: iStaffID ?? _iStaffID,
    iStaffNo: iStaffNo ?? _iStaffNo,
    iStaffName: iStaffName ?? _iStaffName,
    iStaffAddress: iStaffAddress ?? _iStaffAddress,
    iStaffMobile: iStaffMobile ?? _iStaffMobile,
    iStaffEmail: iStaffEmail ?? _iStaffEmail,
    iStaffGender: iStaffGender ?? _iStaffGender,
    iStaffDob: iStaffDob ?? _iStaffDob,
    iStaffType: iStaffType ?? _iStaffType,
    iClinicID: iClinicID ?? _iClinicID,
    iAddedOn: iAddedOn ?? _iAddedOn,
    iTimeslot: iTimeslot ?? _iTimeslot,
    iProfileImage: iProfileImage ?? _iProfileImage,
    iQualification: iQualification ?? _iQualification,
    iDesignation: iDesignation ?? _iDesignation,
  );
  String? get iStaffID => _iStaffID;
  String? get iStaffNo => _iStaffNo;
  String? get iStaffName => _iStaffName;
  String? get iStaffAddress => _iStaffAddress;
  String? get iStaffMobile => _iStaffMobile;
  String? get iStaffEmail => _iStaffEmail;
  String? get iStaffGender => _iStaffGender;
  String? get iStaffDob => _iStaffDob;
  String? get iStaffType => _iStaffType;
  String? get iClinicID => _iClinicID;
  String? get iAddedOn => _iAddedOn;
  String? get iTimeslot => _iTimeslot;
  String? get iProfileImage => _iProfileImage;
  String? get iQualification => _iQualification;
  String? get iDesignation => _iDesignation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['iStaffID'] = _iStaffID;
    map['iStaffNo'] = _iStaffNo;
    map['iStaffName'] = _iStaffName;
    map['iStaffAddress'] = _iStaffAddress;
    map['iStaffMobile'] = _iStaffMobile;
    map['iStaffEmail'] = _iStaffEmail;
    map['iStaffGender'] = _iStaffGender;
    map['iStaffDob'] = _iStaffDob;
    map['iStaffType'] = _iStaffType;
    map['iClinicID'] = _iClinicID;
    map['iAddedOn'] = _iAddedOn;
    map['iTimeslot'] = _iTimeslot;
    map['iProfileImage'] = _iProfileImage;
    map['iQualification'] = _iQualification;
    map['iDesignation'] = _iDesignation;
    return map;
  }

}