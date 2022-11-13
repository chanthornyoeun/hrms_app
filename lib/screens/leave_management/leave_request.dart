import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_app/models/leave_request.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/screens/leave_management/leave_request_card.dart';
import 'package:hrms_app/services/leave_request_service.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen(
      {Key? key,
      required this.selfLeave,
      required this.title,
      required this.isManager})
      : super(key: key);
  final int selfLeave;
  final String title;
  final bool isManager;

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
      if (clearData) {
        _leaveRequests.clear();
      }
    });
    widget.selfLeave == 1 ? params['selfLeave'] = 1 : params['reportToMe'] = 1;
    ResponseDTO res = await _leaveRequestService.list(param: params);

    if (res.statusCode == 200) {
      for (var leaveRequest in res.data) {
        _leaveRequests.add(LeaveRequest.fromJson(leaveRequest));
      }
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
        title: Text(widget.title),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.2,
        child: Scrollbar(
          controller: _scrollController,
          child: RefreshIndicator(
            onRefresh: _pullRefresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _leaveRequests.length,
              itemBuilder: (context, index) => LeaveRequestCard(
                leaveRequest: _leaveRequests[index],
                selfLeave: widget.selfLeave,
                isManager: widget.isManager,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: widget.selfLeave == 1,
        child: FloatingActionButton(
          onPressed: () =>
              {GoRouter.of(context).push('/leave-request/request-form')},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
