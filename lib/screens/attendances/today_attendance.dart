import 'package:flutter/material.dart';

import '../../core/credentials_service.dart';
import '../../models/attendance.dart';
import '../../models/response_dto.dart';
import '../../services/attendance_service.dart';
import 'attendance_card.dart';
import 'attendance_checker.dart';

class TodayAttendance extends StatefulWidget {
  const TodayAttendance({Key? key}) : super(key: key);

  @override
  _TodayAttendanceState createState() => _TodayAttendanceState();
}

class _TodayAttendanceState extends State<TodayAttendance> {
  final AttendanceService _attendanceService = AttendanceService();
  Future<Attendance>? _attendance;

  @override
  void initState() {
    super.initState();
    _attendance = _getTodayAttendace();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: FutureBuilder(
              future: _attendance,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return AttendanceCard(attendance: snapshot.data!);
                }
                if (snapshot.hasError) {
                  return const Text("You haven't check-in yet today.");
                }
                return const CircularProgressIndicator();
              },
            ),
          ),
          const AttendanceChecker(),
        ],
      ),
    );
  }

  Future<Attendance> _getTodayAttendace() async {
    final int employeeId = await CredentialsService().getCurrentEmployee();
    ResponseDTO res = await _attendanceService.getTodayAttendance(employeeId);
    return Attendance.fromJson(res.data[0]);
  }
}
