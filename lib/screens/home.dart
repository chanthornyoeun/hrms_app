import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hrms_app/core/credentials_service.dart';
import 'package:hrms_app/routes/route.dart';
import 'package:hrms_app/screens/drawer.dart';
import 'package:go_router/go_router.dart';

import '../services/location_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const String _title = 'HRMS';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HRMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: routerConfig,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, Color> _menuColor = {
    'leaveRequest': HexColor('EC2028'),
    'attendance': HexColor('139B48'),
    'employee': HexColor('3D97D2'),
  };
  bool _isManager = false;

  @override
  void initState() {
    super.initState();
    LocationService().requestPermission();
    CredentialsService().getRoles().then((roles) {
      setState(() =>
          {_isManager = roles.contains('ADMIN') || roles.contains('MANAGER')});
    });
  }

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: const Image(
        image: AssetImage('assets/logo/baksey_logo.png'),
        width: 300,
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [logo],
          ),
          Expanded(
            child: ListView(
              children: [
                const Divider(
                  height: 0.1,
                ),
                if (_isManager)
                  ExpansionTile(
                      title: const Text('Leave Request'),
                      subtitle: const Text(
                        'Leave request management',
                        style: TextStyle(fontSize: 11),
                      ),
                      leading: _leadingIcon(Icons.work_off),
                      collapsedIconColor: _menuColor['leaveRequest'],
                      textColor: _menuColor['leaveRequest'],
                      collapsedTextColor: _menuColor['leaveRequest'],
                      iconColor: _menuColor['leaveRequest'],
                      children: [
                        const Divider(
                          height: 0.1,
                        ),
                        ListTile(
                          title: const Text('Self Leave'),
                          subtitle: const Text(
                            'See your leave details, or make a new request',
                            style: TextStyle(fontSize: 11),
                          ),
                          dense: true,
                          leading: _leadingIcon(Icons.person_off, size: 24),
                          onTap: () {
                            GoRouter.of(context)
                                .push('/leave-request?title=Self Leave');
                          },
                        ),
                        const Divider(
                          height: 0.1,
                        ),
                        ListTile(
                          title: const Text('Employee Leave'),
                          subtitle: const Text(
                            'See all employee\'s requests, approve and/or reject leave requests.',
                            style: TextStyle(fontSize: 11),
                          ),
                          leading: _leadingIcon(Icons.group_off, size: 24),
                          dense: true,
                          isThreeLine: true,
                          onTap: () {
                            GoRouter.of(context)
                                .push('/employee-leave-request');
                          },
                        ),
                      ]),
                if (!_isManager)
                  ListTile(
                    title: const Text('Leave Request'),
                    subtitle: const Text(
                      'See your leave details, or make a new request',
                      style: TextStyle(fontSize: 11),
                    ),
                    dense: true,
                    onTap: () {
                      GoRouter.of(context)
                          .push('/leave-request?title=All Leaves');
                    },
                    leading: _leadingIcon(Icons.work_off),
                    iconColor: _menuColor['leaveRequest'],
                    textColor: _menuColor['leaveRequest'],
                  ),
                const Divider(
                  height: 0.1,
                ),
                ListTile(
                  title: const Text('Attendance'),
                  subtitle: const Text(
                      'QR Code Scanning for checking attendance',
                      style: TextStyle(fontSize: 12)),
                  onTap: () {
                    GoRouter.of(context).push('/attendance');
                  },
                  leading: _leadingIcon(Icons.lock_clock),
                  iconColor: _menuColor['attendance'],
                  textColor: _menuColor['attendance'],
                ),
                const Divider(
                  height: 0.1,
                ),
                ListTile(
                  title: const Text(
                    'Employees',
                  ),
                  subtitle: const Text('See all employees',
                      style: TextStyle(fontSize: 12)),
                  onTap: () {
                    GoRouter.of(context).push('/employee');
                  },
                  leading: _leadingIcon(Icons.group),
                  iconColor: _menuColor['employee'],
                  textColor: _menuColor['employee'],
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
    );
  }

  Column _leadingIcon(IconData icon, {double? size}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: size ?? 30,
          )
        ]);
  }
}
