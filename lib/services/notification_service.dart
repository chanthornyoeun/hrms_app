import 'dart:convert';
import 'dart:io';

import 'package:hrms_app/core/http_service.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:http/http.dart' as http;

class NotificationService extends HttpService {
  @override
  String getUrl() {
    return '/api/notification';
  }

  Future<ResponseDTO> getBadgeCount() async {
    final token = await credentialsService.getCredentials();
    http.Response res =
        await http.get(Uri.parse('$basedURL/api/user-badge-count'), headers: {
      'X-API-KEY': HttpService.X_API_KEY,
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
    return ResponseDTO.fromJson(jsonDecode(res.body));
  }
}
