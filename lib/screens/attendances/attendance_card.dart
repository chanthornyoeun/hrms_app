import 'package:flutter/material.dart';
import 'package:humanize_duration/humanize_duration.dart';
import 'package:intl/intl.dart';

import '../../models/attendance.dart';

class AttendanceCard extends StatelessWidget {
  final Attendance attendance;
  final TextStyle _style =
      const TextStyle(fontWeight: FontWeight.w500, fontSize: 14);

  const AttendanceCard({Key? key, required this.attendance}) : super(key: key);

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
            _getHeaderText(),
            space,
            _getCheckInText(),
            space,
            _getCheckOutText(),
            if (attendance.totalWorkingMinutes != 0 &&
                attendance.totalWorkingMinutes != null)
              _getWorkingHoursText(),
          ],
        ),
      ),
    );
  }

  Row _getHeaderText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('EEEE dd MMM, yyyy')
              .format(DateTime.parse(attendance.checkIn!))
              .toString(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ],
    );
  }

  Row _getCheckInText() {
    return Row(
      children: [
        const Icon(Icons.check),
        Text(
          'Check-In Time: ',
          style: _style,
        ),
        const SizedBox(width: 2),
        Text(
          '${_formatDate(DateTime.parse(attendance.checkIn!))} (${attendance.statusCheckIn})',
          style: _style,
        )
      ],
    );
  }

  Row _getCheckOutText() {
    return Row(
      children: [
        _getCheckOutIcon(attendance),
        Text(
          'Check-Out Time: ',
          style: _style,
        ),
        const SizedBox(width: 2),
        if (attendance.checkOut != null)
          Text(
            '${_formatDate(DateTime.parse(attendance.checkOut!))} (${attendance.statusCheckOut})',
            style: _style,
          ),
        if (attendance.checkOut == null)
          Text('Not yet checkout',
              style:
                  _style.apply(color: Colors.red, fontStyle: FontStyle.italic))
      ],
    );
  }

  Widget _getWorkingHoursText() {
    return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          children: [
            const Icon(Icons.alarm_on),
            Text(
                'Working Time: ${humanizeDuration(Duration(minutes: attendance.totalWorkingMinutes!))}',
                style: _style),
          ],
        ));
  }

  Icon _getCheckOutIcon(Attendance attendance) {
    return Icon(attendance.checkOut != null ? Icons.check : Icons.close);
  }

  String _formatDate(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }
}
