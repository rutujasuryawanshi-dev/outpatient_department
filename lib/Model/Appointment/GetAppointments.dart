/// sCode : 200
/// sMessage : "Appointments fetched successfully"
/// sData : {"appointments":[{"schedule_id":3553,"appointment_id":3640,"date":"2025-01-10","time":"13:05","name":"Sukrut Hindlekar","gender":"Male","age_string":"27 Year(s)","age_type":"Years","age":27,"mobile":"9552045547","service_type":"General Practice","service":"Consultation","status":3,"doctor_alias":"SUH","bill_id":7858,"teleconsultation_type_id":0,"pending_amount":200,"is_service_completed":1,"consultation_id":884}]}

class GetAppointments {
  GetAppointments({
      num? sCode, 
      String? sMessage, 
      SData? sData,}){
    _sCode = sCode;
    _sMessage = sMessage;
    _sData = sData;
}

  GetAppointments.fromJson(dynamic json) {
    _sCode = json['sCode'];
    _sMessage = json['sMessage'];
    _sData = json['sData'] != null ? SData.fromJson(json['sData']) : null;
  }
  num? _sCode;
  String? _sMessage;
  SData? _sData;
GetAppointments copyWith({  num? sCode,
  String? sMessage,
  SData? sData,
}) => GetAppointments(  sCode: sCode ?? _sCode,
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

/// appointments : [{"schedule_id":3553,"appointment_id":3640,"date":"2025-01-10","time":"13:05","name":"Sukrut Hindlekar","gender":"Male","age_string":"27 Year(s)","age_type":"Years","age":27,"mobile":"9552045547","service_type":"General Practice","service":"Consultation","status":3,"doctor_alias":"SUH","bill_id":7858,"teleconsultation_type_id":0,"pending_amount":200,"is_service_completed":1,"consultation_id":884}]

class SData {
  SData({
      List<Appointments>? appointments,}){
    _appointments = appointments;
}

  SData.fromJson(dynamic json) {
    if (json['appointments'] != null) {
      _appointments = [];
      json['appointments'].forEach((v) {
        _appointments?.add(Appointments.fromJson(v));
      });
    }
  }
  List<Appointments>? _appointments;
SData copyWith({  List<Appointments>? appointments,
}) => SData(  appointments: appointments ?? _appointments,
);
  List<Appointments>? get appointments => _appointments;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_appointments != null) {
      map['appointments'] = _appointments?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// schedule_id : 3553
/// appointment_id : 3640
/// date : "2025-01-10"
/// time : "13:05"
/// name : "Sukrut Hindlekar"
/// gender : "Male"
/// age_string : "27 Year(s)"
/// age_type : "Years"
/// age : 27
/// mobile : "9552045547"
/// service_type : "General Practice"
/// service : "Consultation"
/// status : 3
/// doctor_alias : "SUH"
/// bill_id : 7858
/// teleconsultation_type_id : 0
/// pending_amount : 200
/// is_service_completed : 1
/// consultation_id : 884

class Appointments {
  Appointments({
      num? scheduleId, 
      num? appointmentId, 
      String? date, 
      String? time, 
      String? name, 
      String? gender, 
      String? ageString, 
      String? ageType, 
      num? age, 
      String? mobile, 
      String? serviceType, 
      String? service, 
      num? status, 
      String? doctorAlias, 
      num? billId, 
      num? teleconsultationTypeId, 
      num? pendingAmount, 
      num? isServiceCompleted, 
      num? consultationId,}){
    _scheduleId = scheduleId;
    _appointmentId = appointmentId;
    _date = date;
    _time = time;
    _name = name;
    _gender = gender;
    _ageString = ageString;
    _ageType = ageType;
    _age = age;
    _mobile = mobile;
    _serviceType = serviceType;
    _service = service;
    _status = status;
    _doctorAlias = doctorAlias;
    _billId = billId;
    _teleconsultationTypeId = teleconsultationTypeId;
    _pendingAmount = pendingAmount;
    _isServiceCompleted = isServiceCompleted;
    _consultationId = consultationId;
}

  Appointments.fromJson(dynamic json) {
    _scheduleId = json['schedule_id'];
    _appointmentId = json['appointment_id'];
    _date = json['date'];
    _time = json['time'];
    _name = json['name'];
    _gender = json['gender'];
    _ageString = json['age_string'];
    _ageType = json['age_type'];
    _age = json['age'];
    _mobile = json['mobile'];
    _serviceType = json['service_type'];
    _service = json['service'];
    _status = json['status'];
    _doctorAlias = json['doctor_alias'];
    _billId = json['bill_id'];
    _teleconsultationTypeId = json['teleconsultation_type_id'];
    _pendingAmount = json['pending_amount'];
    _isServiceCompleted = json['is_service_completed'];
    _consultationId = json['consultation_id'];
  }
  num? _scheduleId;
  num? _appointmentId;
  String? _date;
  String? _time;
  String? _name;
  String? _gender;
  String? _ageString;
  String? _ageType;
  num? _age;
  String? _mobile;
  String? _serviceType;
  String? _service;
  num? _status;
  String? _doctorAlias;
  num? _billId;
  num? _teleconsultationTypeId;
  num? _pendingAmount;
  num? _isServiceCompleted;
  num? _consultationId;
Appointments copyWith({  num? scheduleId,
  num? appointmentId,
  String? date,
  String? time,
  String? name,
  String? gender,
  String? ageString,
  String? ageType,
  num? age,
  String? mobile,
  String? serviceType,
  String? service,
  num? status,
  String? doctorAlias,
  num? billId,
  num? teleconsultationTypeId,
  num? pendingAmount,
  num? isServiceCompleted,
  num? consultationId,
}) => Appointments(  scheduleId: scheduleId ?? _scheduleId,
  appointmentId: appointmentId ?? _appointmentId,
  date: date ?? _date,
  time: time ?? _time,
  name: name ?? _name,
  gender: gender ?? _gender,
  ageString: ageString ?? _ageString,
  ageType: ageType ?? _ageType,
  age: age ?? _age,
  mobile: mobile ?? _mobile,
  serviceType: serviceType ?? _serviceType,
  service: service ?? _service,
  status: status ?? _status,
  doctorAlias: doctorAlias ?? _doctorAlias,
  billId: billId ?? _billId,
  teleconsultationTypeId: teleconsultationTypeId ?? _teleconsultationTypeId,
  pendingAmount: pendingAmount ?? _pendingAmount,
  isServiceCompleted: isServiceCompleted ?? _isServiceCompleted,
  consultationId: consultationId ?? _consultationId,
);
  num? get scheduleId => _scheduleId;
  num? get appointmentId => _appointmentId;
  String? get date => _date;
  String? get time => _time;
  String? get name => _name;
  String? get gender => _gender;
  String? get ageString => _ageString;
  String? get ageType => _ageType;
  num? get age => _age;
  String? get mobile => _mobile;
  String? get serviceType => _serviceType;
  String? get service => _service;
  num? get status => _status;
  String? get doctorAlias => _doctorAlias;
  num? get billId => _billId;
  num? get teleconsultationTypeId => _teleconsultationTypeId;
  num? get pendingAmount => _pendingAmount;
  num? get isServiceCompleted => _isServiceCompleted;
  num? get consultationId => _consultationId;


  set name(String? value) {
    _name = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['schedule_id'] = _scheduleId;
    map['appointment_id'] = _appointmentId;
    map['date'] = _date;
    map['time'] = _time;
    map['name'] = _name;
    map['gender'] = _gender;
    map['age_string'] = _ageString;
    map['age_type'] = _ageType;
    map['age'] = _age;
    map['mobile'] = _mobile;
    map['service_type'] = _serviceType;
    map['service'] = _service;
    map['status'] = _status;
    map['doctor_alias'] = _doctorAlias;
    map['bill_id'] = _billId;
    map['teleconsultation_type_id'] = _teleconsultationTypeId;
    map['pending_amount'] = _pendingAmount;
    map['is_service_completed'] = _isServiceCompleted;
    map['consultation_id'] = _consultationId;
    return map;
  }

  set gender(String? value) {
    _gender = value;
  }

  set ageString(String? value) {
    _ageString = value;
  }

  set mobile(String? value) {
    _mobile = value;
  }

  set age(num? value) {
    _age = value;
  }
}