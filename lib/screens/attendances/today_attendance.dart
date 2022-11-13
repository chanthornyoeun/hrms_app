import 'package:flutter/material.dart';
import 'package:hrms_app/services/employee_service.dart';

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
  final EmployeeService _employeeService = EmployeeService();
  Future<Attendance>? _attendance;
  late Future<Map<String, dynamic>> _todayCalendar;

  @override
  void initState() {
    super.initState();
    _todayCalendar = _getCurrentEmployee();
  }

  Future<Map<String, dynamic>> _getCurrentEmployee() async {
    ResponseDTO res = await _employeeService.getCurrentEmployee();
    return res.data['employee']['workingCalendarToday'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: FutureBuilder(
        future: _todayCalendar,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _determineScreen(snapshot.data!);
          }
          if (snapshot.hasError) {
            return const Text("Something went wrong!");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _determineScreen(Map<String, dynamic> todayCalendar) {
    if (todayCalendar['isWorking'] == 1) {
      _attendance = _getTodayAttendace();
      return _working();
    }
    return _weekend();
  }

  Column _working() {
    return Column(
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
              return Container();
            },
          ),
        ),
        const AttendanceChecker(),
      ],
    );
  }

  Center _weekend() {
    return const Center(
      child: Text('Happy weekend!'),
    );
  }

  Future<Attendance> _getTodayAttendace() async {
    final int employeeId = await CredentialsService().getCurrentEmployee();
    ResponseDTO res = await _attendanceService.getTodayAttendance(employeeId);
    return Attendance.fromJson(res.data[0]);
  }
}
