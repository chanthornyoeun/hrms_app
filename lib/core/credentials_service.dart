import 'package:shared_preferences/shared_preferences.dart';

class CredentialsService {
  void save(Map<String, dynamic> credential) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', credential['token']);
  }

  void remove() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  Future<String> getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
