import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    LocationService().requestPermission();
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
                const Divider(),
                ListTile(
                  title: const Text('Leave Request'),
                  subtitle: const Text(
                    'See your leave details, or make a new request',
                    style: TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    GoRouter.of(context).push('/leave-request');
                  },
                  leading: const Icon(Icons.work_off),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Attendance'),
                  subtitle: const Text(
                      'QR Code Scanning for checking attendance',
                      style: TextStyle(fontSize: 12)),
                  onTap: () {
                    GoRouter.of(context).push('/attendance');
                  },
                  leading: const Icon(Icons.lock_clock),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Employees'),
                  subtitle: const Text('See all employees',
                      style: TextStyle(fontSize: 12)),
                  onTap: () {
                    GoRouter.of(context).push('/employee');
                  },
                  leading: const Icon(Icons.group),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
    );
  }
}
