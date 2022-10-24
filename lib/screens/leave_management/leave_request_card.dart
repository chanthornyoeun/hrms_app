import 'package:flutter/material.dart';
import 'package:hrms_app/models/leave_request.dart';
import 'package:intl/intl.dart';

class LeaveRequestCard extends StatelessWidget {
  LeaveRequestCard({Key? key, required this.leaveRequest}) : super(key: key);

  LeaveRequest leaveRequest;

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
                  '${leaveRequest.employee?.name}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Text(leaveRequest.status)
              ],
            ),
            space,
            Text('Type: ${leaveRequest.leaveType?.type}'),
            space,
            Text(
                'Leave Date: ${DateFormat('dd-MMM-yyyy').format(leaveRequest.fromDate)} -> ${DateFormat('dd-MMM-yyyy').format(leaveRequest.toDate)}'),
            space,
            Text('Day Taken: ${leaveRequest.day}'),
            space,
            Text('Leave Reason: ${leaveRequest.reason}'),
          ],
        ),
      ),
    );
  }
}
