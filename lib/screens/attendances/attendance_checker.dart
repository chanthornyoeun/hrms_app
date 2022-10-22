import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/services/attendance_service.dart';
import 'package:intl/intl.dart';

class AttendanceChecker extends StatefulWidget {
  const AttendanceChecker({Key? key}) : super(key: key);

  @override
  _AttendanceCheckerState createState() => _AttendanceCheckerState();
}

class _AttendanceCheckerState extends State<AttendanceChecker> {
  late Timer _timer;
  String _timeLabel = '...';
  final TextStyle _style =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  final AttendanceService _attendanceService = AttendanceService();
  late Future<Map<String, dynamic>> _status;
  late bool diabledButton = false;

  @override
  void initState() {
    super.initState();
    _digitalClock();
    _status = _getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _status,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ElevatedButton(
            onPressed: (snapshot.data?['isCheckedIn'] &&
                    snapshot.data?['isCheckedOut'])
                ? null
                : () => {GoRouter.of(context).push('/attendance/check')},
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 150),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _timeLabel,
                  style: _style,
                ),
                Text(
                  _getText(snapshot.data!),
                  style: _style,
                ),
              ],
            ),
          );
        }
        return const Text('Loading...');
      },
    );
  }

  Future<Map<String, dynamic>> _getStatus() async {
    ResponseDTO res = await _attendanceService.attendanceStatus();
    return res.data;
  }

  void _digitalClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLabel = DateFormat('hh:mm:ss a').format(DateTime.now());
      });
    });
  }

  String _getText(Map<String, dynamic> status) {
    if (status['isCheckedIn'] && status['isCheckedOut']) return 'Done';
    if (status['isCheckedIn']) return 'Check-Out';
    return 'Check-In';
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
