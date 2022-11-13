import 'package:shared_preferences/shared_preferences.dart';

class CredentialsService {
  void save(Map<String, dynamic> credential) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> roles = (credential['roles'] as List<dynamic>)
        .map<String>((role) => role['roleName'])
        .toList(growable: false);
    prefs.setString('token', credential['token']);
    prefs.setInt('employeeId', credential['employee']['id']);
    prefs.setStringList('roles', roles);
  }

  Future<void> remove() async {
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

  Future<List<String>> getRoles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('roles') ?? [];
  }
}
