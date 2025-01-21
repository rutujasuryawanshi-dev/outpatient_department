/// sCode : 200
/// sMessage : "OTP sent on Email ID successfully"
/// sData : {}

class LoginResponse {
  LoginResponse({
      num? sCode, 
      String? sMessage, 
      dynamic sData,}){
    _sCode = sCode;
    _sMessage = sMessage;
    _sData = sData;
}

  LoginResponse.fromJson(dynamic json) {
    _sCode = json['sCode'];
    _sMessage = json['sMessage'];
    _sData = json['sData'];
  }
  num? _sCode;
  String? _sMessage;
  dynamic _sData;
LoginResponse copyWith({  num? sCode,
  String? sMessage,
  dynamic sData,
}) => LoginResponse(  sCode: sCode ?? _sCode,
  sMessage: sMessage ?? _sMessage,
  sData: sData ?? _sData,
);
  num? get sCode => _sCode;
  String? get sMessage => _sMessage;
  dynamic get sData => _sData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sCode'] = _sCode;
    map['sMessage'] = _sMessage;
    map['sData'] = _sData;
    return map;
  }

}