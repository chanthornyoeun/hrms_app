import 'dart:convert';
import 'dart:io';

import 'package:hrms_app/core/http_service.dart';

import '/models/response_dto.dart';
import 'package:http/http.dart' as http;

class EmployeeService extends HttpService {
  @override
  String getUrl() {
    return '/api/employee';
  }

  Future<ResponseDTO> getCurrentEmployee() async {
    final token = await credentialsService.getCredentials();
    http.Response res =
        await http.post(Uri.parse('$basedURL/api/auth/current-user'), headers: {
      'X-API-KEY': HttpService.X_API_KEY,
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
    return ResponseDTO.fromJson(jsonDecode(res.body));
  }
}
