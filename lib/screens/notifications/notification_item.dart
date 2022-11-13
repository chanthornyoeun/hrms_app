import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hrms_app/widgets/avatar.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key, required this.notification})
      : super(key: key);

  final Map<String, dynamic> notification;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        // color:
        //     notification['isRead'] != 1 ? Colors.blue[50] : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Avatar(
              gender: notification['data']['data']['body']['employee']
                  ['gender'],
              picture: notification['data']['notification']['image'],
              padding: const EdgeInsets.only(right: 16),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _getContent(
                          notification['data']['data']['body']['status'])
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    notification['lifeTimeStamp'],
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => {
                // TODO: go to details page
              },
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.zero,
              splashRadius: 18,
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
      ),
      onTap: () => {
        GoRouter.of(context).push(
            '/leave-request-details/${notification['data']['data']['body']['id']}')
      },
    );
  }

  Flexible _pendingContent() {
    return Flexible(
      child: RichText(
        text: TextSpan(
            text: notification['data']['data']['body']['employee']['name'],
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
            children: const [
              TextSpan(
                  text: ' sent a leave request for approval.',
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black)),
            ]),
      ),
    );
  }

  Flexible _getCancelContent() {
    return Flexible(
      child: RichText(
        text: TextSpan(
            text: notification['data']['data']['body']['canceledBy']['name'],
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
            children: const [
              TextSpan(
                text: ' canceled a leave request.',
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.black),
              ),
            ]),
      ),
    );
  }

  Flexible _getRejectContent() {
    return Flexible(
      child: RichText(
        text: TextSpan(
            text: notification['data']['data']['body']['rejectedBy']['name'],
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
            children: const [
              TextSpan(
                  text: ' rejected your leave request.',
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black)),
            ]),
      ),
    );
  }

  Flexible _approveContent() {
    return Flexible(
      child: RichText(
        text: TextSpan(
            text: notification['data']['data']['body']['approvedBy']['name'],
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
            children: const [
              TextSpan(
                  text: ' approved your leave request.',
                  style: TextStyle(
                      fontWeight: FontWeight.normal, color: Colors.black)),
            ]),
      ),
    );
  }

  dynamic _getContent(String status) {
    switch (status) {
      case 'Pending':
        return _pendingContent();
      case 'Canceled':
        return _getCancelContent();
      case 'Rejected':
        return _getRejectContent();
      case 'Approved':
        return _approveContent();
    }
  }
}
