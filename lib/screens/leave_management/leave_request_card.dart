import 'package:flutter/material.dart';
import 'package:hrms_app/models/leave_request.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/services/leave_request_service.dart';
import 'package:intl/intl.dart';

class LeaveRequestCard extends StatefulWidget {
  const LeaveRequestCard({super.key, required this.leaveRequest});

  final LeaveRequest leaveRequest;

  @override
  State<StatefulWidget> createState() => _LeaveRequestCardState();
}

class _LeaveRequestCardState extends State<LeaveRequestCard> {
  late LeaveRequest _leaveRequest;
  final LeaveRequestService _leaveRequestService = LeaveRequestService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _leaveRequest = widget.leaveRequest;
  }

  @override
  Widget build(BuildContext context) {
    const SizedBox space = SizedBox(height: 6);
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_leaveRequest.employee?.name}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(_leaveRequest.status)
              ],
            ),
            space,
            Text('Type: ${_leaveRequest.leaveType?.type}'),
            space,
            Text(
                'Leave Date: ${DateFormat('dd-MMM-yyyy').format(_leaveRequest.fromDate)} -> ${DateFormat('dd-MMM-yyyy').format(_leaveRequest.toDate)}'),
            space,
            Text('Day Taken: ${_leaveRequest.day}'),
            space,
            Text('Leave Reason: ${_leaveRequest.reason}'),
            if (_leaveRequest.status == 'Pending') _cancelLeaveButton()
          ],
        ),
      ),
    );
  }

  Container _cancelLeaveButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            _handleCancelLeave(_leaveRequest.id!);
          },
          child: _isLoading
              ? const CircularProgressIndicator()
              : const Text('Cancel')),
    );
  }

  void _handleCancelLeave(int leaveRequestId) async {
    setState(() {
      _isLoading = true;
    });
    ResponseDTO res = await _leaveRequestService.cancel(leaveRequestId);

    if (res.statusCode == 200) {
      _showMessage('Your leave request has been cancelled.');
      _leaveRequest.status = 'Canceled';
    }

    if (res.statusCode == 400 || res.statusCode == 500) {
      _showMessage(res.message);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
