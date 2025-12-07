import 'package:control_cash/main.dart';
import 'package:control_cash/services/auth_service.dart';
import 'package:control_cash/utils/email_validator.dart';
import 'package:control_cash/utils/password_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/standard_button.dart';
import '../widgets/standard_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final authService = AuthService();

  bool isLoading = false;

  String? emailError;
  String? passwordError;
  String? confirmError;
  String? globalError;

  Future<void> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    setState(() {
      emailError = null;
      passwordError = null;
      confirmError = null;
      globalError = null;
    });

    bool hasError = false;

    if (!validateEmail(email)) {
      emailError = "Invalid email format";
      hasError = true;
    }

    if (!validatePassword(password)) {
      passwordError = "Minimum 6 characters";
      hasError = true;
    }

    if (confirm != password) {
      confirmError = "Passwords do not match";
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    setState(() => isLoading = true);

    try {
      await authService.signUp(email, password);
      Navigator.push(context, MaterialPageRoute(builder: (_) => MyApp()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        globalError = "Authentication error: ${e.message}";
      });
    } catch (e) {
      setState(() {
        globalError = "Unexpected error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 300,
            ),
            const SizedBox(height: 10),

            if (globalError != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        globalError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            StandardInput(
              isObscureText: false,
              labelText: 'Email',
              controller: emailController,
              errorText: emailError,
            ),
            const SizedBox(height: 10),

            StandardInput(
              isObscureText: true,
              labelText: 'Password',
              controller: passwordController,
              errorText: passwordError,
            ),
            const SizedBox(height: 10),

            StandardInput(
              isObscureText: true,
              labelText: 'Confirm password',
              controller: confirmController,
              errorText: confirmError,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: StandardButton(
                    textInfo: 'Sign Up',
                    isAccent: true,
                    onClick: signUp,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Sign In', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
