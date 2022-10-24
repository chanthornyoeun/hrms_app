import 'package:hrms_app/core/http_service.dart';

class LeaveRequestService extends HttpService {

  @override
  String getUrl() {
    return '/api/leave-request';
  }

}
