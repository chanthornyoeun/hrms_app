import 'package:flutter/material.dart';
import 'package:hrms_app/core/credentials_service.dart';
import 'package:hrms_app/screens/home.dart';
import 'package:hrms_app/screens/login.dart';
import 'package:go_router/go_router.dart';

final GoRouter routerConfig =  GoRouter(
    routes: <GoRoute>[
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
          }
      ),
      GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          }
      ),
    ]
);