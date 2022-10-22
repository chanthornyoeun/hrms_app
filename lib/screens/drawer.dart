import 'package:flutter/material.dart';
import 'package:hrms_app/core/auth_service.dart';
import 'package:hrms_app/core/credentials_service.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AppDrawer extends StatefulWidget {

  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppDrawerState();

}

class _AppDrawerState extends State<AppDrawer> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      opacity: 0.2,
      child: _buildWidget(context),
    );
  }

  Widget _buildWidget(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('User Avatar'),
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Setting'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Log out'),
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              AuthService authService = AuthService();
              CredentialsService credentialsService = CredentialsService();
              await authService.logout();
              credentialsService.remove();
              if (!context.mounted) return;
              setState(() {
                isLoading = false;
              });
                GoRouter.of(context).go('/');
              },
          ),
        ],
      ),
    );
  }

}
