import 'package:haha/widgets/input_field.dart';
import 'package:haha/widgets/primary_button.dart';
import 'package:flutter/material.dart';
// Fixed import path
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes.dart'; // Add this import

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  final FirestoreService _db = FirestoreService();
  bool _loading = false;

  void _signup() async {
    setState(() => _loading = true);
    try {
      final cred = await _auth.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      final uid = cred.user!.uid;
      await _db.createUserProfile(uid, {
        'uid': uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'bio': 'Hi, I\'m new here!',
        'avatarUrl': '',
      });
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, Routes.home); // Use Routes constant
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Signup failed')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create account')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InputField(
                controller: _nameController,
                label: 'Full name',
              ),
              SizedBox(height: 10),
              InputField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              InputField(
                controller: _passwordController,
                label: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 16),
              PrimaryButton(
                text: 'Sign up',
                onPressed: _signup,
                loading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}