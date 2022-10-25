import 'dart:convert';
import 'dart:io';

import 'package:hrms_app/core/http_service.dart';

import '/models/response_dto.dart';
import 'package:http/http.dart' as http;

class LeaveRequestService extends HttpService {
  @override
  String getUrl() {
    return '/api/leave-request';
  }

  Future<ResponseDTO> cancel(int leaveRequestId) async {
    final token = await credentialsService.getCredentials();
    http.Response res = await http.post(
      Uri.parse('$basedURL/api/leave-request-cancel/$leaveRequestId'),
      headers: {
        'X-API-KEY': HttpService.X_API_KEY,
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json'
      },
    );
    return ResponseDTO.fromJson(jsonDecode(res.body));
  }
}
