/// sCode : 200
/// sMessage : "Appointment cancelled successfully"
/// sData : {}

class CancelAppointment {
  CancelAppointment({
      num? sCode, 
      String? sMessage, 
      dynamic sData,}){
    _sCode = sCode;
    _sMessage = sMessage;
    _sData = sData;
}

  CancelAppointment.fromJson(dynamic json) {
    _sCode = json['sCode'];
    _sMessage = json['sMessage'];
    _sData = json['sData'];
  }
  num? _sCode;
  String? _sMessage;
  dynamic _sData;
CancelAppointment copyWith({  num? sCode,
  String? sMessage,
  dynamic sData,
}) => CancelAppointment(  sCode: sCode ?? _sCode,
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