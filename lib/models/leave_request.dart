import 'package:hrms_app/models/employee.dart';
import 'package:hrms_app/models/leave_type.dart';
import 'package:hrms_app/utils/date_time_extension.dart';

class LeaveRequest {
  int? id;
  late int employeeId;
  late int leaveTypeId;
  late DateTime fromDate;
  late DateTime toDate;
  late dynamic day;
  late String reason;
  late int isFullDay;
  late int? reportToId;
  late String status;
  int? apporvedById;
  DateTime? approvedDate;
  int? rejectedById;
  DateTime? rejectedDate;
  int? canceledById;
  DateTime? canceledDate;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  Employee? employee;
  Employee? reportTo;
  LeaveType? leaveType;
  Employee? approvedBy;
  Employee? rejectedBy;
  Employee? canceledBy;

  LeaveRequest(
      {required this.id,
      required this.employeeId,
      required this.leaveTypeId,
      required this.fromDate,
      required this.toDate,
      required this.day,
      required this.reason,
      required this.isFullDay,
      required this.reportToId,
      required this.status,
      this.apporvedById,
      this.approvedDate,
      this.rejectedById,
      this.rejectedDate,
      this.canceledById,
      this.canceledDate,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.employee,
      this.reportTo,
      this.leaveType,
      this.approvedBy,
      this.rejectedBy,
      this.canceledBy});

  LeaveRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    leaveTypeId = json['leaveTypeId'];
    fromDate = DateTimeExtension.parseUtc(json['fromDate']);
    toDate = DateTimeExtension.parseUtc(json['toDate']);
    day = json['day'];
    reason = json['reason'];
    isFullDay = json['isFullDay'];
    reportToId = json['reportToId'];
    status = json['status'];
    apporvedById = json['apporvedById'];
    approvedDate = DateTimeExtension.tryParseUtc(json['approvedDate']);
    rejectedById = json['rejectedById'];
    rejectedDate = DateTimeExtension.tryParseUtc(json['rejectedDate']);
    canceledById = json['canceledById'];
    canceledDate = DateTimeExtension.tryParseUtc(json['canceledDate']);
    comment = json['comment'];
    createdAt = DateTimeExtension.tryParseUtc(json['createdAt']);
    updatedAt = DateTimeExtension.tryParseUtc(json['updatedAt']);
    employee =
        json['employee'] != null ? Employee.fromJson(json['employee']) : null;
    reportTo =
        json['reportTo'] != null ? Employee.fromJson(json['reportTo']) : null;
    leaveType = json['leaveType'] != null
        ? LeaveType.fromJson(json['leaveType'])
        : null;
    approvedBy = json['approvedBy'] != null
        ? Employee.fromJson(json['approvedBy'])
        : null;
    rejectedBy = json['rejectedBy'] != null
        ? Employee.fromJson(json['rejectedBy'])
        : null;
    canceledBy = json['canceledBy'] != null
        ? Employee.fromJson(json['canceledBy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['leaveTypeId'] = leaveTypeId;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['day'] = day;
    data['reason'] = reason;
    data['isFullDay'] = isFullDay;
    data['reportToId'] = reportToId;
    data['status'] = status;
    data['apporvedById'] = apporvedById;
    data['approvedDate'] = approvedDate;
    data['rejectedById'] = rejectedById;
    data['rejectedDate'] = rejectedDate;
    data['canceledById'] = canceledById;
    data['canceledDate'] = canceledDate;
    data['comment'] = comment;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['employee'] = employee?.toJson();
    data['reportTo'] = reportTo?.toJson();
    data['leaveType'] = leaveType?.toJson();
    data['approvedBy'] = approvedBy?.toJson();
    data['rejectedBy'] = rejectedBy?.toJson();
    data['canceledBy'] = canceledBy?.toJson();
    return data;
  }
}
