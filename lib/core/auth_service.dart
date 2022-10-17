import 'dart:convert';
import 'dart:io';
import 'package:hrms_app/core/credentials_service.dart';

import '/models/response_dto.dart';
import 'package:http/http.dart';

class AuthService {
  final String basedURL = 'https://hr-ocean.com:8090';
  static const String X_API_KEY = 'aHJtcy1wcm9qZWN0LXhhcGlrZXktc2Vj';
  final CredentialsService credentailsService = CredentialsService();

  Future<ResponseDTO> login(String username, String password) async {
    final url = '$basedURL/api/auth/login';
    final Map<String, String> credential = {
      'username': username,
      'password': password
    };
    Response res = await post(Uri.parse(url),
        headers: {
          'X-API-KEY': X_API_KEY,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(credential));

    if (res.statusCode == 200) {
      return ResponseDTO.fromJson(jsonDecode(res.body));
    } else {
      throw 'Unable to login';
    }
  }

  Future<ResponseDTO> logout() async {
    final url = '$basedURL/api/auth/logout';
    String token = await credentailsService.getCredentials();
    Response res = await post(Uri.parse(url), headers: {
      'X-API-KEY': X_API_KEY,
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });

    if (res.statusCode == 200) {
      return ResponseDTO.fromJson(jsonDecode(res.body));
    } else {
      throw 'Unable to logout';
    }
  }
}
