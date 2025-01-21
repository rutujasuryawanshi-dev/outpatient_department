/// sCode : 200
/// sMessage : "Bearer token generated"
/// sData : {"sTokenType":"Bearer","sAuthToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MzU1NTczOTMsImV4cCI6MTczNTgxNjU5MywiaVN0YWZmSUQiOiIxMjUzOSIsImlDbGluaWNJRCI6NDA2fQ.iLQyVx_grZn_yIaf9_c81xDJs7fyK8Gx-DDB3lqhxXI"}

class SelectClinicResponse {
  SelectClinicResponse({
      num? sCode, 
      String? sMessage, 
      SData? sData,}){
    _sCode = sCode;
    _sMessage = sMessage;
    _sData = sData;
}

  SelectClinicResponse.fromJson(dynamic json) {
    _sCode = json['sCode'];
    _sMessage = json['sMessage'];
    _sData = json['sData'] != null ? SData.fromJson(json['sData']) : null;
  }
  num? _sCode;
  String? _sMessage;
  SData? _sData;
SelectClinicResponse copyWith({  num? sCode,
  String? sMessage,
  SData? sData,
}) => SelectClinicResponse(  sCode: sCode ?? _sCode,
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

/// sTokenType : "Bearer"
/// sAuthToken : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3MzU1NTczOTMsImV4cCI6MTczNTgxNjU5MywiaVN0YWZmSUQiOiIxMjUzOSIsImlDbGluaWNJRCI6NDA2fQ.iLQyVx_grZn_yIaf9_c81xDJs7fyK8Gx-DDB3lqhxXI"

class SData {
  SData({
      String? sTokenType, 
      String? sAuthToken,}){
    _sTokenType = sTokenType;
    _sAuthToken = sAuthToken;
}

  SData.fromJson(dynamic json) {
    _sTokenType = json['sTokenType'];
    _sAuthToken = json['sAuthToken'];
  }
  String? _sTokenType;
  String? _sAuthToken;
SData copyWith({  String? sTokenType,
  String? sAuthToken,
}) => SData(  sTokenType: sTokenType ?? _sTokenType,
  sAuthToken: sAuthToken ?? _sAuthToken,
);
  String? get sTokenType => _sTokenType;
  String? get sAuthToken => _sAuthToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sTokenType'] = _sTokenType;
    map['sAuthToken'] = _sAuthToken;
    return map;
  }

}