import 'package:flutter/material.dart';
import 'package:hrms_app/core/credentials_service.dart';
import 'package:hrms_app/models/attendance.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/screens/attendances/attendance_card.dart';
import 'package:hrms_app/services/attendance_service.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({Key? key}) : super(key: key);

  @override
  _AttendanceListState createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  final AttendanceService _attendanceService = AttendanceService();
  final List<Attendance> _attendances = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  int _total = 0;
  final int _limit = 20;
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    _getAttendances({
      'offset': _offset,
      'limit': _limit,
    });
    _handleInfiniteScroll();
  }

  void _handleInfiniteScroll() {
    _scrollController.addListener(() {
      final currentPosition = _scrollController.position.pixels;
      final fetchMore = _scrollController.position.maxScrollExtent;
      if (currentPosition >= fetchMore && _total > _offset) {
        _getAttendances({
          'offset': _offset,
          'limit': _limit,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0,
      child: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          physics: const AlwaysScrollableScrollPhysics(),
          children: _generateAttendaceCards(_attendances),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    _offset = 0;
    _getAttendances({
      'offset': _offset,
      'limit': _limit,
    }, clearData: true);
  }

  void _getAttendances(Map<String, dynamic> params,
      {bool clearData = false}) async {
    setState(() {
      _isLoading = true;
    });
    final int employeeId = await CredentialsService().getCurrentEmployee();
    params['employeeId'] = employeeId;
    ResponseDTO res = await _attendanceService.get(param: params);

    if (clearData) {
      _attendances.clear();
    }

    if (res.statusCode == 200) {
      for (var attendance in res.data) {
        _attendances.add(Attendance.fromJson(attendance));
      }
    }
    setState(() {
      _isLoading = false;
      _total = res.total;
      _offset = _offset + _limit;
    });
  }

  List<AttendanceCard> _generateAttendaceCards(List<Attendance> attendances) {
    List<AttendanceCard> cards = [];
    for (Attendance attendance in attendances) {
      cards.add(AttendanceCard(attendance: attendance));
    }
    return cards;
  }
}
