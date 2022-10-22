import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hrms_app/core/credentials_service.dart';
import 'package:hrms_app/models/attendance.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/screens/attendances/attendance_card.dart';
import 'package:hrms_app/services/attendance_service.dart';
import 'package:hrms_app/screens/attendances/attendance_checker.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceService _attendanceService = AttendanceService();
  Future<Attendance>? _attendance;

  @override
  void initState() {
    super.initState();
    _attendance = _getTodayAttendace();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance'), centerTitle: true),
      body: Container(
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
      ),
    );
  }

  Future<Attendance> _getTodayAttendace() async {
    final int employeeId = await CredentialsService().getCurrentEmployee();
    ResponseDTO res = await _attendanceService.getTodayAttendance(employeeId);
    return Attendance.fromJson(res.data[0]);
  }
}
