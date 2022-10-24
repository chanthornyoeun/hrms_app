import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_app/core/credentials_service.dart';
import 'package:hrms_app/models/leave_request.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/screens/leave_management/leave_request_card.dart';
import 'package:hrms_app/services/leave_request_service.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({Key? key}) : super(key: key);

  @override
  _LeaveRequestScreenState createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final LeaveRequestService _leaveRequestService = LeaveRequestService();

  final List<LeaveRequest> _leaveRequests = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  int _total = 0;
  final int _limit = 20;
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    _getLeaveRequests({
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
        _getLeaveRequests({
          'offset': _offset,
          'limit': _limit,
        });
      }
    });
  }

  Future<void> _pullRefresh() async {
    _offset = 0;
    _getLeaveRequests({
      'offset': _offset,
      'limit': _limit,
    }, clearData: true);
  }

  void _getLeaveRequests(Map<String, dynamic> params,
      {bool clearData = false}) async {
    setState(() {
      _isLoading = true;
    });
    final int employeeId = await CredentialsService().getCurrentEmployee();
    params['employeeId'] = employeeId;
    ResponseDTO res = await _leaveRequestService.get(param: params);

    if (clearData) {
      _leaveRequests.clear();
    }

    if (res.statusCode == 200) {
      for (var leaveRequest in res.data) {
        _leaveRequests.add(LeaveRequest.fromJson(leaveRequest));
      }
      debugPrint("========= Leave Requst: ${_leaveRequests[0].toJson()}");
    }
    setState(() {
      _isLoading = false;
      _total = res.total;
      _offset = _offset + _limit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Request'),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.2,
        child: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              for (var leaveRequest in _leaveRequests)
                LeaveRequestCard(leaveRequest: leaveRequest)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            {GoRouter.of(context).push('/leave-request/request-form')},
        child: const Icon(Icons.add),
      ),
    );
  }
}
