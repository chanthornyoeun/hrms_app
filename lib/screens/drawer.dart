import 'package:firebase_messaging/firebase_messaging.dart';
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
  late Future<String> _profilePhoto;

  @override
  void initState() {
    super.initState();
    _profilePhoto = CredentialsService().getProfilePhoto();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      opacity: 0.1,
      child: _buildWidget(context),
    );
  }

  Widget _buildWidget(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Column(
        children: [
          Expanded(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    padding: EdgeInsets.zero,
                    child: FutureBuilder(
                      future: _profilePhoto,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return AspectRatio(
                            aspectRatio: 2 / 1.2,
                            child: Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                        return Container();
                      },
                    )),
                ListTile(
                  title: const Text('PROFILE'),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    _showMessage('Feture is coming soon. Stay tuned!');
                  },
                ),
                ListTile(
                  title: const Text('NOTIFICATION'),
                  leading: const Icon(Icons.notifications),
                  onTap: () {
                    GoRouter.of(context).push('/notifications');
                  },
                ),
                ListTile(
                  title: const Text('SETTING'),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    _showMessage('Feture is coming soon. Stay tuned!');
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: Text('Log out'.toUpperCase()),
            leading: const Icon(Icons.exit_to_app),
            onTap: () async {
              await _logout(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    AuthService authService = AuthService();
    CredentialsService credentialsService = CredentialsService();
    String? token = await FirebaseMessaging.instance.getToken();

    setState(() {
      isLoading = true;
    });

    await authService.logout(token);
    await credentialsService.remove();

    if (!context.mounted) return;
    setState(() {
      isLoading = false;
    });

    GoRouter.of(context).go('/');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
