import 'package:flutter/material.dart';
import 'package:hrms_app/core/credentials_service.dart';
import 'package:hrms_app/models/employee.dart';
import 'package:hrms_app/models/leave_request.dart';
import 'package:hrms_app/models/leave_type.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/services/leave_request_service.dart';
import 'package:intl/intl.dart';

class LeaveRequestDetails extends StatefulWidget {
  const LeaveRequestDetails({Key? key, required this.leaveRequestId})
      : super(key: key);
  final int leaveRequestId;

  @override
  _LeaveRequestDetailsState createState() => _LeaveRequestDetailsState();
}

class _LeaveRequestDetailsState extends State<LeaveRequestDetails> {
  final LeaveRequestService _leaveRequestService = LeaveRequestService();
  late Future<LeaveRequest> _leaveRequest;
  late LeaveRequest _leave;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle _buttonStyle =
      ElevatedButton.styleFrom(fixedSize: const Size.fromHeight(40));
  bool _isLoading = false;
  bool _isManager = false;
  bool _isPending = false;

  @override
  void initState() {
    super.initState();
    CredentialsService().getRoles().then((roles) {
      setState(() =>
          {_isManager = roles.contains('ADMIN') || roles.contains('MANAGER')});
    });
    _leaveRequest = _getLeaveRequestById(widget.leaveRequestId);
  }

  Future<LeaveRequest> _getLeaveRequestById(int leaveRequestId) async {
    ResponseDTO res = await _leaveRequestService.get(leaveRequestId);
    if (mounted) {
      if (res.statusCode == 400 || res.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.message),
            duration: const Duration(milliseconds: 2000),
          ),
        );
      }
    }
    setState(() {
      _isPending = res.data['status'] == 'Pending';
    });

    _leave = LeaveRequest.fromJson(res.data);
    return _leave;
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _leaveRequest = _getLeaveRequestById(widget.leaveRequestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Leave Reqeust')),
      body: FutureBuilder(
        future: _leaveRequest,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView(children: [_leaveCard(snapshot.data!)]),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: Visibility(
        visible: _isManager && _isPending,
        child: Container(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: _navigationButtom(),
        ),
      ),
    );
  }

  _leaveCard(LeaveRequest leaveRequest) {
    final Employee employee = leaveRequest.employee!;
    final LeaveType leaveType = leaveRequest.leaveType!;
    const space = SizedBox(height: 12);

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 1.2,
            child: Image.network(
              employee.profilePhoto!,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  space,
                  Text(
                    employee.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _leaveTypeWidget(leaveType.type),
                space,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_month),
                    Flexible(
                      child: Text(
                        '${DateFormat('EEE, MMM dd yyyy').format(leaveRequest.fromDate)} -> ${DateFormat('EEE, MMM dd yyyy').format(leaveRequest.toDate)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                space,
                const Text(
                  'Leave Reason',
                  style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
                space,
                Text(
                  leaveRequest.reason,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                space,
                if (_isPending) _cancelLeaveButton()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _leaveTypeWidget(String type) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: Colors.red[200],
      ),
      height: 50,
      child: Center(
        child: Text(
          type.toUpperCase(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

  Row _navigationButtom() {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(
              width: double.infinity,
              height: 40,
            ),
            child: ElevatedButton(
              onPressed: () => {_showApproveModalBottom(context, _leave.id!)},
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.zero,
                    bottomRight: Radius.zero,
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.check), Text('Approve')],
              ),
            ),
          ),
        ),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(
              width: double.infinity,
              height: 40,
            ),
            child: ElevatedButton(
              onPressed: () => {_showRejectModalBottom(context, _leave.id!)},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    bottomLeft: Radius.zero,
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.close), Text('Reject')],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container _cancelLeaveButton() {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _handleCancelLeave(_leave.id!);
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
      _pullRefresh();
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
    final ResponseDTO res = await _leaveRequestService.approve(
      leaveRequestId,
      comment: _inputController.text,
    );
    if (res.statusCode == 200) {
      _showMessage('Leave request has been approved.');
      _pullRefresh();
      _inputController.text = '';
      if (!mounted) return;
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
      _pullRefresh();
      _inputController.text = '';
      if (!mounted) return;
      Navigator.pop(context);
    }

    if (res.statusCode == 400 || res.statusCode == 500) {
      _showMessage(res.message);
    }
  }
}
