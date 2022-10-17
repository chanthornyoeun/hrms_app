import 'package:flutter/material.dart';
import 'package:hrms_app/core/credentials_service.dart';
import 'package:hrms_app/screens/drawer.dart';
import 'package:hrms_app/screens/login.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const String _title = 'HRMS';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'HRMS',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/home': (context) => const HomeScreen(title: _title),
          '/login': (context) => const LoginScreen(),
        },
        home: const HomeScreen(title: _title));
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CredentialsService credentialsService = CredentialsService();

  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  void _checkLoginState() async {
    final token = await credentialsService.getCredentials();
    if (token.isEmpty || token == '') {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: const Center(child: Text('Home')),
      drawer: const AppDrawer(),
    );
  }
}
