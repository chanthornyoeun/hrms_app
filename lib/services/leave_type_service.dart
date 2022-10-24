import 'package:hrms_app/core/http_service.dart';

class LeaveTypeService extends HttpService {
  @override
  String getUrl() {
    return '/api/leave-type';
  }
}
