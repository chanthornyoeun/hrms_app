import 'package:flutter/material.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:hrms_app/screens/notifications/notification_item.dart';
import 'package:hrms_app/services/notification_service.dart';
import 'package:loading_overlay/loading_overlay.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationsService = NotificationService();
  final List<Map<String, dynamic>> _notifications = [];
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  int _total = 0;
  final int _limit = 20;
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    _getNotifications({'offset': _offset, 'limit': _limit});
    _handleInfiniteScroll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.1,
        child: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Scrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _notifications.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return NotificationItem(notification: _notifications[index]);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pullRefresh() async {
    _offset = 0;
    _getNotifications({
      'offset': _offset,
      'limit': _limit,
    }, clearData: true);
  }

  void _getNotifications(Map<String, dynamic> params,
      {bool clearData = false}) async {
    setState(() {
      _isLoading = true;
      if (clearData) {
        _notifications.clear();
      }
    });
    params['type'] = 'LEAVE_REQUEST';
    ResponseDTO res = await _notificationsService.list(param: params);
    if (!context.mounted) return;
    setState(() {
      for (var notification in res.data) {
        _notifications.add(notification);
      }
      _total = res.total;
      _offset = _offset + _limit;
      _isLoading = false;
    });
  }

  void _handleInfiniteScroll() {
    _scrollController.addListener(() {
      final currentPosition = _scrollController.position.pixels;
      final fetchMore = _scrollController.position.maxScrollExtent;
      if (currentPosition >= fetchMore && _total > _offset) {
        _getNotifications({
          'offset': _offset,
          'limit': _limit,
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
