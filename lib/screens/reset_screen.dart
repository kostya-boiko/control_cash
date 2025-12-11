import 'package:control_cash/services/auth_service.dart';
import 'package:control_cash/utils/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/standard_input.dart';
import 'sign_in_screen.dart';
import '../widgets/standard_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailController = TextEditingController();
  bool isEmailSend = false;
  bool isLoading = false;
  String? emailError;

  final authService = AuthService();

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (!validateEmail(email)) {
      setState(() {
        emailError = "Please enter a valid email";
      });
      return;
    }

    setState(() {
      isLoading = true;
      isEmailSend = false;
      emailError = null;
    });

    try {
      await authService.resetPassword(email);

      setState(() {
        isEmailSend = true;
      });
    } on FirebaseAuthException catch(e) {
      setState(() {
        emailError = e.message;
      });
    } catch (e) {
      setState(() {
        emailError = "Unexpected error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: isEmailSend
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle,
                          size: 60, color: Colors.green),
                      const SizedBox(height: 12),
                      const Text(
                        'Email has been sent!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Follow the instructions in the email to reset your password.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: StandardButton(
                        textInfo: 'Sign in',
                        isAccent: true,
                        onClick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        isLoading: isLoading,
                      ),
                    ),
                  ],
                ),
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 300,
                ),
                const SizedBox(height: 10),
                StandardInput(
                  isObscureText: false,
                  labelText: 'Email',
                  controller: emailController,
                  errorText: emailError,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: StandardButton(
                        textInfo: 'Reset password',
                        isAccent: true,
                        onClick: resetPassword,
                        isLoading: isLoading,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  ),
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
