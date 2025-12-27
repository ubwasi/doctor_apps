import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Theme/Theme.dart';
import '../../Widget/TextEdtingField.dart';
import '../../domain/requests/auth_requests.dart';
import 'RegScreen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result['success'] == true &&
        result['data'] != null &&
        result['data']['token'] != null) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'user',
        jsonEncode(result['data']['user']),
      );

      await prefs.setString(
        'token',
        result['data']['token'],
      );

      if (!mounted) return;
      context.go('/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text("Welcome Back!",
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              const Text("Login to continue your health journey."),
              const SizedBox(height: 40),

              TextEditingField(
                controller: _emailController,
                title: 'Email',
                hintText: 'Enter your email',
                icon: const Icon(Icons.email_outlined),
                validator: (v) =>
                v == null || !v.contains('@') ? 'Invalid email' : null,
              ),

              const SizedBox(height: 20),

              TextEditingField(
                controller: _passwordController,
                title: 'Password',
                hintText: 'Enter password',
                icon: const Icon(Icons.lock_outline),
                obscureText: true,
                validator: (v) =>
                v == null || v.isEmpty ? 'Password required' : null,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LightTheme.primaryColors,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegScreen(),
                        ),
                      );
                    },
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
