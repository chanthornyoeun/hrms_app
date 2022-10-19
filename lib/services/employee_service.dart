import 'package:hrms_app/core/http_service.dart';

class EmployeeService extends HttpService {

  @override
  String getUrl() {
    return '/api/employee';
  }

}