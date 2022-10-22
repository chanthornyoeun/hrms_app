import 'package:flutter/material.dart';
import 'package:hrms_app/core/credentials_service.dart';
import 'package:hrms_app/screens/employee.dart';
import 'package:hrms_app/screens/home.dart';
import 'package:hrms_app/screens/login.dart';
import 'package:go_router/go_router.dart';

import '../screens/attendances/attendance.dart';
import '../screens/attendances/attendance_scanner.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter routerConfig =
    GoRouter(navigatorKey: _rootNavigatorKey, initialLocation: '/', routes: [
  ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => Scaffold(body: child),
      routes: [
        GoRoute(
          path: '/',
          redirect: (context, state) async {
            final CredentialsService credentialsService = CredentialsService();
            final token = await credentialsService.getCredentials();
            if (token.isNotEmpty && token != '') {
              return '/home';
            }
            return '/login';
          },
        ),
        GoRoute(
            path: '/home',
            builder: (BuildContext context, GoRouterState state) {
              return const HomeScreen(title: 'HRMS');
            }),
        GoRoute(
            path: '/login',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginScreen();
            }),
        GoRoute(
            path: '/employee',
            builder: (BuildContext context, GoRouterState state) {
              return const EmployeeScreen();
            }),
        GoRoute(
            path: '/attendance',
            builder: (BuildContext context, GoRouterState state) {
              return const AttendanceScreen();
            },
            routes: <RouteBase>[
              GoRoute(
                  path: 'check',
                  builder: (BuildContext context, GoRouterState state) {
                    return const AttendanceScannerScreen();
                  }),
            ]),
      ]),
]);
