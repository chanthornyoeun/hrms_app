import 'package:flutter/material.dart';
import 'package:hrms_app/models/leave_request.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/services/leave_request_service.dart';
import 'package:intl/intl.dart';

class LeaveRequestCard extends StatefulWidget {
  const LeaveRequestCard(
      {super.key,
      required this.leaveRequest,
      required this.selfLeave,
      required this.isManager});

  final LeaveRequest leaveRequest;
  final int selfLeave;
  final bool isManager;

  @override
  State<StatefulWidget> createState() => _LeaveRequestCardState();
}

class _LeaveRequestCardState extends State<LeaveRequestCard> {
  late LeaveRequest _leaveRequest;
  final LeaveRequestService _leaveRequestService = LeaveRequestService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle _buttonStyle =
      ElevatedButton.styleFrom(fixedSize: const Size.fromHeight(40));
  bool _isLoading = false;
  bool _isManager = false;

  @override
  void initState() {
    super.initState();
    _leaveRequest = widget.leaveRequest;
    _isManager = widget.isManager;
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
            if (_leaveRequest.status == 'Pending' && widget.selfLeave == 1)
              _cancelLeaveButton(),
            if (_leaveRequest.status == 'Pending' &&
                _isManager &&
                widget.selfLeave == 0)
              _approvalWidget()
          ],
        ),
      ),
    );
  }

  Container _approvalWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Expanded(
              child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(
                width: double.infinity, height: 40),
            child: ElevatedButton(
                onPressed: () =>
                    _showApproveModalBottom(context, _leaveRequest.id!),
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4)))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Icon(Icons.check), Text('Approve')])),
          )),
          Expanded(
              child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(
                width: double.infinity, height: 40),
            child: ElevatedButton(
                onPressed: () =>
                    _showRejectModalBottom(context, _leaveRequest.id!),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            bottomLeft: Radius.zero,
                            topRight: Radius.circular(4),
                            bottomRight: Radius.circular(4)))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Icon(Icons.close), Text('Reject')])),
          )),
        ],
      ),
    );
  }

  Container _cancelLeaveButton() {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _handleCancelLeave(_leaveRequest.id!);
        },
        style: _buttonStyle,
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Cancel'),
      ),
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

  Future _showApproveModalBottom(BuildContext context, int leaveRequestId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  minLines: 3,
                  maxLines: null,
                  controller: _inputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Comment',
                    hintText: 'Write your comment...',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _approveLeave(leaveRequestId, context),
                  style: _buttonStyle,
                  child: Text('Approve'.toUpperCase()),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _approveLeave(int leaveRequestId, BuildContext context) async {
    final ResponseDTO res = await _leaveRequestService.reject(
        leaveRequestId, _inputController.text);
    if (res.statusCode == 200) {
      _showMessage('Leave request has been approved.');
      setState(() {
        _leaveRequest.status = 'Approved';
        _inputController.text = '';
      });
      if (!context.mounted) return;
      Navigator.pop(context);
    }

    if (res.statusCode == 400 || res.statusCode == 500) {
      _showMessage(res.message);
    }
  }

  Future _showRejectModalBottom(BuildContext context, int leaveRequestId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    minLines: 3,
                    maxLines: null,
                    controller: _inputController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      suffixText: '*',
                      suffixStyle: TextStyle(
                        color: Colors.red,
                      ),
                      labelText: 'Reason',
                      hintText: 'Write your reason...',
                      alignLabelWithHint: true,
                    ),
                    validator: (String? value) {
                      return value == null || value.isEmpty
                          ? 'Reason is required.'
                          : null;
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _rejectLeave(leaveRequestId, context);
                      }
                    },
                    style: _buttonStyle.copyWith(
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.red)),
                    child: Text('Reject'.toUpperCase()),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _rejectLeave(int leaveRequestId, BuildContext context) async {
    final ResponseDTO res = await _leaveRequestService.reject(
        leaveRequestId, _inputController.text);
    if (res.statusCode == 200) {
      _showMessage('Leave request has been rejected.');
      setState(() {
        _leaveRequest.status = 'Rejected';
        _inputController.text = '';
      });
      if (!context.mounted) return;
      Navigator.pop(context);
    }

    if (res.statusCode == 400 || res.statusCode == 500) {
      _showMessage(res.message);
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}
