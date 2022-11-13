import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_app/models/leave_type.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/services/leave_request_service.dart';
import 'package:hrms_app/services/leave_type_service.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({Key? key}) : super(key: key);

  @override
  _RequestFormState createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final LeaveTypeService _leaveTypeService = LeaveTypeService();
  final LeaveRequestService _leaveRequestService = LeaveRequestService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final String _dateFormatPattern = 'dd-MMM-yyyy';
  final List<LeaveType> _leaveTypes = [];
  int? _leaveTypeId;
  DateTime? _fromDate;
  DateTime? _toDate;

  final List<bool> _isSelected = [true, false];
  int selectedIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    final DateTime currentDate = DateUtils.dateOnly(DateTime.now());
    final String currentDateStr =
        DateFormat(_dateFormatPattern).format(currentDate);
    _fromDate = currentDate;
    _toDate = currentDate;
    _fromDateController.text = currentDateStr;
    _toDateController.text = currentDateStr;
    _getLeaveTypes();
  }

  void _getLeaveTypes() async {
    ResponseDTO res = await _leaveTypeService.list(param: {'limit': 20});
    setState(() {
      for (var leveType in res.data) {
        _leaveTypes.add(LeaveType.fromJson(leveType));
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const SizedBox space = SizedBox(height: 16);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Leave'),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.2,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  space,
                  _leaveTypeDropdown(),
                  space,
                  _leaveType(),
                  space,
                  TextFormField(
                    readOnly: true,
                    controller: _fromDateController,
                    decoration: const InputDecoration(
                        suffixText: '*',
                        suffixStyle: TextStyle(
                          color: Colors.red,
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'From Date',
                        hintText: 'From Date',
                        suffixIcon: IconButton(
                            onPressed: null, icon: Icon(Icons.calendar_month))),
                    validator: (String? value) {
                      return value == null || value.isEmpty
                          ? 'Please choose a date.'
                          : null;
                    },
                    onTap: () async {
                      DateTime? picked = await _showDatePicker(date: _fromDate);
                      if (picked == null) return;
                      setState(() => _fromDateController.text =
                          DateFormat(_dateFormatPattern).format(picked));
                      _fromDate = picked;
                      if (_isHaftDay()) {
                        _toDateController.text = _fromDateController.text;
                        _toDate = _fromDate;
                      }
                    },
                  ),
                  space,
                  TextFormField(
                    readOnly: true,
                    controller: _toDateController,
                    decoration: const InputDecoration(
                      suffixText: '*',
                      suffixStyle: TextStyle(
                        color: Colors.red,
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'To Date',
                      hintText: 'To Date',
                      suffixIcon: Icon(Icons.calendar_month),
                    ),
                    onTap: () async {
                      DateTime? picked = await _showDatePicker(date: _toDate);
                      if (picked == null) return;
                      setState(() => _toDateController.text =
                          DateFormat(_dateFormatPattern).format(picked));
                      _toDate = picked;

                      if (_isHaftDay()) {
                        _fromDateController.text = _toDateController.text;
                        _fromDate = _toDate;
                      }
                    },
                    validator: (String? value) {
                      return value == null || value.isEmpty
                          ? 'Please choose a date.'
                          : null;
                    },
                  ),
                  space,
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    minLines: 4,
                    maxLines: null,
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      suffixText: '*',
                      suffixStyle: TextStyle(
                        color: Colors.red,
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Reason',
                      hintText: 'Leave reason',
                      alignLabelWithHint: true,
                    ),
                    validator: (String? value) {
                      return value == null || value.isEmpty
                          ? 'Reason is required.'
                          : null;
                    },
                  ),
                  space,
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ElevatedButton(
          onPressed: _submitHandler,
          style: ElevatedButton.styleFrom(fixedSize: const Size(double.maxFinite, 48)),
          child: Text(
            'Apply Leave'.toUpperCase(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> _leaveTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        suffixText: '*',
        suffixStyle: TextStyle(
          color: Colors.red,
        ),
        border: OutlineInputBorder(),
        labelText: 'Leave Type',
        hintText: 'Select Leve Type',
      ),
      validator: (String? value) {
        return value == null || value.isEmpty
            ? 'Please select a leave type.'
            : null;
      },
      items: _leaveTypes
          .map((leaveType) => DropdownMenuItem(
              value: leaveType.id.toString(), child: Text(leaveType.type)))
          .toList(),
      onChanged: (String? value) {
        _leaveTypeId = int.parse(value.toString());
      },
    );
  }

  LayoutBuilder _leaveType() {
    return LayoutBuilder(
      builder: (context, constraints) => ToggleButtons(
          selectedColor: Colors.blue,
          color: Colors.black,
          constraints:
              BoxConstraints.expand(width: (constraints.maxWidth / 2) - 2),
          onPressed: (index) {
            if (selectedIndex == index) return;
            setState(() {
              if (index == 0) {
                _isSelected[index] = !_isSelected[index];
                _isSelected[1] = false;
              } else {
                _isSelected[0] = !_isSelected[0];
                _isSelected[index] = true;
                _toDateController.text = _fromDateController.text;
                _toDate = _fromDate;
              }
              selectedIndex = index;
            });
          },
          isSelected: _isSelected,
          children: const [Text('Full Day'), Text('Half Day')]),
    );
  }

  bool _isHaftDay() {
    return _isSelected[1];
  }

  void _submitHandler() async {
    if (!_formKey.currentState!.validate()) {
      _showMessage("Please fill all required information.");
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> body = <String, dynamic>{};
      body['leaveTypeId'] = _leaveTypeId;
      body['fromDate'] = _fromDate!.toUtc().toIso8601String();
      body['toDate'] = _toDate!.toUtc().toIso8601String();
      body['reason'] = _reasonController.text;
      body['isFullDay'] = _isSelected[0];

      ResponseDTO res = await _leaveRequestService.save(body);
      debugPrint('============== Response: ${res.toJson()}');

      if (res.statusCode == 200) {
        _showMessage('Leave request sent successfully!');
        _goBack();
        return;
      }

      if (res.statusCode == 400 || res.statusCode == 500) {
        _showMessage(res.message);
      }
    } catch (e) {
      throw "Unable to submit.";
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<DateTime?> _showDatePicker({DateTime? date}) async {
    return await showDatePicker(
        context: context,
        initialDate: date ?? DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(DateTime.now().year + 10));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    ));
  }

  void _goBack() {
    GoRouter.of(context).pop();
  }
}
