import 'dart:convert';
import 'dart:io';

import 'package:hrms_app/core/credentials_service.dart';

import '../models/response_dto.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String X_API_KEY = 'aHJtcy1wcm9qZWN0LXhhcGlrZXktc2Vj';
  final CredentialsService credentialsService = CredentialsService();

  Future<ResponseDTO> updateDeviceToken(String? deviceToken) async {
    final token = await credentialsService.getCredentials();
    Map<String, dynamic> body = {'deviceToken': deviceToken};
    http.Response res = await http.put(
        Uri.parse(
            'https://hr-ocean.com:8090/api/auth/current-user-device-token'),
        headers: {
          'X-API-KEY': X_API_KEY,
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(body));
    return ResponseDTO.fromJson(jsonDecode(res.body));
  }

  Future<ResponseDTO> removeDeviceToken(String deviceToken) async {
    final token = await credentialsService.getCredentials();
    Map<String, dynamic> body = {'deviceToken': deviceToken};
    http.Response res = await http.put(
        Uri.parse(
            'https://hr-ocean.com:8090/api/auth/current-user-device-token'),
        headers: {
          'X-API-KEY': X_API_KEY,
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(body));
    return ResponseDTO.fromJson(jsonDecode(res.body));
  }
}
