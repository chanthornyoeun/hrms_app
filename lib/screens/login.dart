import 'package:flutter/material.dart';
import 'package:hrms_app/core/credentials_service.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../models/response_dto.dart';
import '../core/auth_service.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  final AuthService authService = AuthService();
  final CredentialsService credentialsService = CredentialsService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.2,
        child: _buildWidget(),
      ),
    );
  }

  Widget _buildWidget() {
    final logo = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: const Image(
        image: AssetImage('assets/logo/baksey_logo.png'),
        width: 250,
      ),
    );
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              logo,
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  validator: (String? value) {
                    return value == null || value.isEmpty
                        ? 'Please enter username'
                        : null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: (String? value) {
                    return value == null || value.isEmpty
                        ? 'Please enter password'
                        : null;
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text(
                  'Forgot Password?',
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      setState(() {
                        _isLoading = true;
                      });
                      ResponseDTO res = await authService.login(
                          usernameController.text, passwordController.text);
                      setState(() {
                        _isLoading = false;
                      });
                      if (!context.mounted) return;
                      if (res.statusCode == 200) {
                        credentialsService.save(res.data);
                        setState(() {
                          _isLoading = false;
                        });
                        GoRouter.of(context).go('/home');
                      }

                      if (res.statusCode == 401 || res.statusCode == 500) {
                        _showErrorMessage(res.message);
                      }
                    },
                    child: const Text('Login'),
                  )),
            ],
          ),
        ));
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
