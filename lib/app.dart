import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/routes/route.dart';
import 'package:hrms_app/services/user_service.dart';

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<StatefulWidget> createState() => _App();
}

class _App extends State<App> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _onTokenRefresh();
  }

  // Any time the token refreshes, store this in the database too.
  void _onTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => _userService.updateDeviceToken(token));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HRMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: routerConfig,
      debugShowCheckedModeBanner: false,
    );
  }
}
