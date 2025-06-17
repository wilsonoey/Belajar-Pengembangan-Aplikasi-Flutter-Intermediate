import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  void _login() async {
    final response = await _apiService.login(_emailController.text, _passwordController.text);
    print(response);
    if (!response['error']) {
      if (response.containsKey('loginResult') && response['loginResult'].containsKey('token')) {
        // Save the token (e.g., using SharedPreferences)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['loginResult']['token']);
        // Navigate to the home page
        context.go('/home');
      } else {
        // Handle the case where the token is not present
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: Token not found')));
      }
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response['message'] ?? 'Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              key: const ValueKey("email_field"),
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              key: const ValueKey("password_field"),
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: TextButton(
                onPressed: () {
                  context.go('/register');
                },
                child: Text(
                  "Anda belum punya akun? Register di sini",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            ElevatedButton(key: const ValueKey("login_button"), onPressed: _login, child: Text('Login')),
          ],
        ),
      ),
    );
  }
}
