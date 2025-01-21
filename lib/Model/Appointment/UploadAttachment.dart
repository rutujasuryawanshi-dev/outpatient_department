/// sCode : 200
/// sMessage : "Attachments uploaded successfully"
/// sData : {"attachments":[]}

class UploadAttachment {
  UploadAttachment({
      num? sCode, 
      String? sMessage, 
      SData? sData,}){
    _sCode = sCode;
    _sMessage = sMessage;
    _sData = sData;
}

  UploadAttachment.fromJson(dynamic json) {
    _sCode = json['sCode'];
    _sMessage = json['sMessage'];
    _sData = json['sData'] != null ? SData.fromJson(json['sData']) : null;
  }
  num? _sCode;
  String? _sMessage;
  SData? _sData;
UploadAttachment copyWith({  num? sCode,
  String? sMessage,
  SData? sData,
}) => UploadAttachment(  sCode: sCode ?? _sCode,
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

/// attachments : []

class SData {
  SData({
      List<dynamic>? attachments,}){
    _attachments = attachments;
}

  SData.fromJson(dynamic json) {
    if (json['attachments'] != null) {
      _attachments = [];
      /*
      json['attachments'].forEach((v) {
        _attachments?.add(Dynamic.fromJson(v));
      });

       */
    }
  }
  List<dynamic>? _attachments;
SData copyWith({  List<dynamic>? attachments,
}) => SData(  attachments: attachments ?? _attachments,
);
  List<dynamic>? get attachments => _attachments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_attachments != null) {
      map['attachments'] = _attachments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}