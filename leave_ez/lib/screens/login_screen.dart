import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:leave_ez/providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  final _usernameController = TextEditingController(text: "Kedibone");
  final _passwordController = TextEditingController(text: "Kedibone@24");

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      try {
                        await authProvider.login(
                          _usernameController.text,
                          _passwordController.text,
                        );
                        if (authProvider.user!.role == 'Manager') {
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/admin');
                          }
                        } else {
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                                context, '/leave-requests');
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Login failed. Please try again.')),
                          );
                        }
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
