import 'package:hrms_app/models/employee.dart';

class Attendance {
  late int id;
  late int employeeId;
  String? checkIn;
  String? checkOut;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? statusCheckIn;
  String? statusCheckOut;
  String? descriptionCheckIn;
  String? descriptionCheckOut;
  late String startTime;
  late String endTime;
  late int workingDuration;
  late Employee employee;
  late int? totalWorkingMinutes;
  int? overMinutes;
  int? lateMinutes;

  Attendance({
    required this.id,
    required this.employeeId,
    this.checkIn,
    this.checkOut,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.statusCheckIn,
    this.statusCheckOut,
    this.descriptionCheckIn,
    this.descriptionCheckOut,
    required this.startTime,
    required this.endTime,
    required this.workingDuration,
    required this.employee,
    required this.totalWorkingMinutes,
    this.overMinutes,
    this.lateMinutes,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    checkIn = json['checkIn'];
    checkOut = json['checkOut'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    statusCheckIn = json['statusCheckIn'];
    statusCheckOut = json['statusCheckOut'];
    descriptionCheckIn = json['descriptionCheckIn'];
    descriptionCheckOut = json['descriptionCheckOut'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    totalWorkingMinutes = json['totalWorkingMinutes'];
    workingDuration = json['workingDuration'];
    lateMinutes = json['lateMinutes'];
    overMinutes = json['overMinutes'];
    employee = Employee.fromJson(json['employee']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['checkIn'] = checkIn;
    data['checkOut'] = checkOut;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['statusCheckIn'] = statusCheckIn;
    data['statusCheckOut'] = statusCheckOut;
    data['descriptionCheckIn'] = descriptionCheckIn;
    data['descriptionCheckOut'] = descriptionCheckOut;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['workingDuration'] = workingDuration;
    data['totalWoringMinutes'] = totalWorkingMinutes;
    data['lateMinutes'] = lateMinutes;
    data['overMinutes'] = overMinutes;
    data['employee'] = employee.toJson();
    return data;
  }
}
