import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hrms_app/core/http_service.dart';
import 'package:hrms_app/models/response_dto.dart';
import 'package:http/http.dart' as http;

class AttendanceService extends HttpService {
  @override
  String getUrl() {
    return '/api/attendant';
  }

  Future<ResponseDTO> checkAttendance(Map<String, dynamic> body,
      {Map<String, dynamic>? param}) async {
    final token = await credentialsService.getCredentials();
    final url = '$basedURL/api/attendant-check';
    http.Response res = await http.post(Uri.parse(url),
        headers: {
          'X-API-KEY': HttpService.X_API_KEY,
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode(body));
    return ResponseDTO.fromJson(jsonDecode(res.body));
  }

  Future<ResponseDTO> attendanceStatus({Map<String, dynamic>? param}) async {
    final token = await credentialsService.getCredentials();
    final url = '$basedURL/api/check-my-attendant';
    http.Response res = await http.post(
      Uri.parse(url),
      headers: {
        'X-API-KEY': HttpService.X_API_KEY,
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    return ResponseDTO.fromJson(jsonDecode(res.body));
  }

  Future<ResponseDTO> getTodayAttendance(int employeeId) {
    final DateTime currentDate = DateUtils.dateOnly(DateTime.now());
    final String fromDate = currentDate.toUtc().toIso8601String();
    final String toDate = currentDate
        .add(const Duration(
            hours: 23, minutes: 59, seconds: 59, milliseconds: 999))
        .toUtc()
        .toIso8601String();
    Map<String, dynamic> params = {
      'employeeId': employeeId,
      'fromDate': fromDate,
      'toDate': toDate
    };
    return list(param: params);
  }
}
