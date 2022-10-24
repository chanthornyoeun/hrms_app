import 'package:hrms_app/utils/date_time_extension.dart';

class LeaveType {
  late int id;
  late String type;
  String? description;
  late int isActive;
  late int allowanceDay;
  late DateTime createdAt;
  DateTime? updatedAt;

  LeaveType(
      {required this.id,
      required this.type,
      this.description,
      required this.isActive,
      required this.allowanceDay,
      required this.createdAt,
      this.updatedAt});

  LeaveType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    description = json['description'];
    isActive = json['isActive'];
    allowanceDay = json['allowanceDay'];
    createdAt = DateTimeExtension.parseUtc(json['createdAt']);
    updatedAt = DateTimeExtension.tryParseUtc(json['updatedAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['description'] = description;
    data['isActive'] = isActive;
    data['allowanceDay'] = allowanceDay;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
