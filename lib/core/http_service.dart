import 'dart:convert';
import 'dart:io';
import 'package:hrms_app/core/credentials_service.dart';

import '/models/response_dto.dart';
import 'package:http/http.dart' as http;

abstract class HttpService {
  final String basedURL = 'https://hr-ocean.com:8090';
  static const String X_API_KEY = 'aHJtcy1wcm9qZWN0LXhhcGlrZXktc2Vj';
  final CredentialsService credentialsService = CredentialsService();

  Future<ResponseDTO> get({Map<String, dynamic>? param}) async {
    final token = await credentialsService.getCredentials();
    http.Response res =
        await http.get(Uri.parse(getFullURL(params: param)), headers: {
      'X-API-KEY': 'aHJtcy1wcm9qZWN0LXhhcGlrZXktc2Vj',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
    if (res.statusCode == 200) {
      return ResponseDTO.fromJson(jsonDecode(res.body));
    } else {
      throw 'Unable to get data';
    }
  }

  Future<ResponseDTO> save(Map<String, dynamic> body,
      {Map<String, dynamic>? param}) async {
    final token = await credentialsService.getCredentials();
    http.Response res = await http.post(Uri.parse(getFullURL(params: param)),
        headers: {
          'X-API-KEY': X_API_KEY,
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode(body));
    if (res.statusCode == 200) {
      return ResponseDTO.fromJson(jsonDecode(res.body));
    } else {
      throw 'Unable to save';
    }
  }

  Future<ResponseDTO> update(int id, Map<String, dynamic> body,
      {Map<String, dynamic>? param}) async {
    final token = await credentialsService.getCredentials();
    final url = '${Uri.parse(getFullURL(params: param))}/$id';
    http.Response res = await http.put(Uri.parse(url),
        headers: {
          'X-API-KEY': X_API_KEY,
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode(body));
    if (res.statusCode == 200) {
      return ResponseDTO.fromJson(jsonDecode(res.body));
    } else {
      throw 'Unable to update';
    }
  }

  Future<ResponseDTO> delete(int id, {Map<String, dynamic>? param}) async {
    final token = await credentialsService.getCredentials();
    final url = '${Uri.parse(getFullURL(params: param))}/$id';
    http.Response res = await http.delete(Uri.parse(url), headers: {
      'X-API-KEY': X_API_KEY,
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
    if (res.statusCode == 200) {
      return ResponseDTO.fromJson(jsonDecode(res.body));
    } else {
      throw 'Unable to delete';
    }
  }

  String getFullURL({Map<String, dynamic>? params}) {
    String url = '$basedURL${getUrl()}';
    String queryParams = '';
    params?.entries.forEach((param) {
      queryParams += '${param.key}=${param.value}&';
    });
    url += '?$queryParams';
    return url.substring(0, url.length - 1);
  }

  String getUrl();
}
