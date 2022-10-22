import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class CredentialsService {
  void save(Map<String, dynamic> credential) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', credential['token']);
    prefs.setInt('employeeId', credential['employee']['id']);
  }

  void remove() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('employeeId');
  }

  Future<String> getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<int> getCurrentEmployee() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('employeeId') ?? 0;
  }
}
