import 'package:flutter/material.dart';
import 'attendance_list.dart';
import 'today_attendance.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  late List<Tab> _tabs;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabs = [
      Tab(
        child: Row(
          children: const [
            Icon(Icons.qr_code),
            Text(
              'Check-In/Check-Out',
            )
          ],
        ),
      ),
      Tab(
        child: Row(
          children: const [
            Icon(Icons.fact_check),
            Text(
              'Your Attendances',
            )
          ],
        ),
      )
    ];
    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        centerTitle: true,
        bottom: TabBar(
          tabs: _tabs,
          controller: _tabController,
          isScrollable: true,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TodayAttendance(),
          AttendanceList(),
        ],
      ),
    );
  }
}
