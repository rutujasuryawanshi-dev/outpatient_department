/// sCode : 200
/// sMessage : "OTP verified successfully"
/// sData : {"aClinics":[{"clinic_id":"479","clinic_name":"Chavan"}],"iStaffDetails":{"iStaffType":"Doctor","iStaffTypeID":"3","iStaffName":"Rohit ","iStaffNo":"THA01-12538-Q"},"aAuthToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MzYzNDM0NzQsImV4cCI6MTczNjM0NDM3NCwiaVN0YWZmSUQiOiIxMjUzOSJ9.lqH9WGstJnaY6MY4oRZNTrOmotMe7Pd49lz4Xh3ggak"}

class VerifyOtpResponse {
  VerifyOtpResponse({
      num? sCode, 
      String? sMessage, 
      SData? sData,}){
    _sCode = sCode;
    _sMessage = sMessage;
    _sData = sData;
}

  VerifyOtpResponse.fromJson(dynamic json) {
    _sCode = json['sCode'];
    _sMessage = json['sMessage'];
    _sData = json['sData'] != null ? SData.fromJson(json['sData']) : null;
  }
  num? _sCode;
  String? _sMessage;
  SData? _sData;
VerifyOtpResponse copyWith({  num? sCode,
  String? sMessage,
  SData? sData,
}) => VerifyOtpResponse(  sCode: sCode ?? _sCode,
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

/// aClinics : [{"clinic_id":"479","clinic_name":"Chavan"}]
/// iStaffDetails : {"iStaffType":"Doctor","iStaffTypeID":"3","iStaffName":"Rohit ","iStaffNo":"THA01-12538-Q"}
/// aAuthToken : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MzYzNDM0NzQsImV4cCI6MTczNjM0NDM3NCwiaVN0YWZmSUQiOiIxMjUzOSJ9.lqH9WGstJnaY6MY4oRZNTrOmotMe7Pd49lz4Xh3ggak"

class SData {
  SData({
      List<AClinics>? aClinics, 
      IStaffDetails? iStaffDetails, 
      String? aAuthToken,}){
    _aClinics = aClinics;
    _iStaffDetails = iStaffDetails;
    _aAuthToken = aAuthToken;
}

  SData.fromJson(dynamic json) {
    if (json['aClinics'] != null) {
      _aClinics = [];
      json['aClinics'].forEach((v) {
        _aClinics?.add(AClinics.fromJson(v));
      });
    }
    _iStaffDetails = json['iStaffDetails'] != null ? IStaffDetails.fromJson(json['iStaffDetails']) : null;
    _aAuthToken = json['aAuthToken'];
  }
  List<AClinics>? _aClinics;
  IStaffDetails? _iStaffDetails;
  String? _aAuthToken;
SData copyWith({  List<AClinics>? aClinics,
  IStaffDetails? iStaffDetails,
  String? aAuthToken,
}) => SData(  aClinics: aClinics ?? _aClinics,
  iStaffDetails: iStaffDetails ?? _iStaffDetails,
  aAuthToken: aAuthToken ?? _aAuthToken,
);
  List<AClinics>? get aClinics => _aClinics;
  IStaffDetails? get iStaffDetails => _iStaffDetails;
  String? get aAuthToken => _aAuthToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_aClinics != null) {
      map['aClinics'] = _aClinics?.map((v) => v.toJson()).toList();
    }
    if (_iStaffDetails != null) {
      map['iStaffDetails'] = _iStaffDetails?.toJson();
    }
    map['aAuthToken'] = _aAuthToken;
    return map;
  }

}

/// iStaffType : "Doctor"
/// iStaffTypeID : "3"
/// iStaffName : "Rohit "
/// iStaffNo : "THA01-12538-Q"

class IStaffDetails {
  IStaffDetails({
      String? iStaffType, 
      String? iStaffTypeID, 
      String? iStaffName, 
      String? iStaffNo,}){
    _iStaffType = iStaffType;
    _iStaffTypeID = iStaffTypeID;
    _iStaffName = iStaffName;
    _iStaffNo = iStaffNo;
}

  IStaffDetails.fromJson(dynamic json) {
    _iStaffType = json['iStaffType'];
    _iStaffTypeID = json['iStaffTypeID'];
    _iStaffName = json['iStaffName'];
    _iStaffNo = json['iStaffNo'];
  }
  String? _iStaffType;
  String? _iStaffTypeID;
  String? _iStaffName;
  String? _iStaffNo;
IStaffDetails copyWith({  String? iStaffType,
  String? iStaffTypeID,
  String? iStaffName,
  String? iStaffNo,
}) => IStaffDetails(  iStaffType: iStaffType ?? _iStaffType,
  iStaffTypeID: iStaffTypeID ?? _iStaffTypeID,
  iStaffName: iStaffName ?? _iStaffName,
  iStaffNo: iStaffNo ?? _iStaffNo,
);
  String? get iStaffType => _iStaffType;
  String? get iStaffTypeID => _iStaffTypeID;
  String? get iStaffName => _iStaffName;
  String? get iStaffNo => _iStaffNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['iStaffType'] = _iStaffType;
    map['iStaffTypeID'] = _iStaffTypeID;
    map['iStaffName'] = _iStaffName;
    map['iStaffNo'] = _iStaffNo;
    return map;
  }

}

/// clinic_id : "479"
/// clinic_name : "Chavan"

class AClinics {
  AClinics({
      String? clinicId, 
      String? clinicName,}){
    _clinicId = clinicId;
    _clinicName = clinicName;
}

  AClinics.fromJson(dynamic json) {
    _clinicId = json['clinic_id'];
    _clinicName = json['clinic_name'];
  }
  String? _clinicId;
  String? _clinicName;
AClinics copyWith({  String? clinicId,
  String? clinicName,
}) => AClinics(  clinicId: clinicId ?? _clinicId,
  clinicName: clinicName ?? _clinicName,
);
  String? get clinicId => _clinicId;
  String? get clinicName => _clinicName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['clinic_id'] = _clinicId;
    map['clinic_name'] = _clinicName;
    return map;
  }

}