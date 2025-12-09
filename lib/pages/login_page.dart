import 'package:haha/widgets/input_field.dart';
import 'package:haha/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes.dart'; // Add this import

// ignore: use_key_in_widget_constructors
class LoginPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  bool _loading = false;

  void _login() async {
    setState(() => _loading = true);
    try {
      await _auth.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, Routes.home); // Use Routes constant
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/tic-computer.png", height: 80),
                SizedBox(height: 50),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 18),
                InputField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 12),
                InputField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: 16),
                PrimaryButton(
                  text: 'Login',
                  onPressed: _login,
                  loading: _loading,
                ),
                SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, Routes.signup), // Use Routes constant
                  child: Text('Create account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}