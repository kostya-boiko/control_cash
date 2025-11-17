import 'package:control_cash/screens/story_screen.dart';
import 'package:control_cash/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../widgets/standard_button.dart';
import '../widgets/standard_input.dart';
import 'reset_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  final authService = AuthService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await authService.signIn(emailController.text, passwordController.text);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/1024px-Google-flutter-logo.svg.png',
              width: 300,
            ),
            SizedBox(height: 30),
            StandardInput(
              isObscureText: false,
              labelText: 'Email',
              controller: emailController,
            ),
            SizedBox(height: 10),
            StandardInput(
              isObscureText: true,
              labelText: 'Password',
              controller: passwordController,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: StandardButton(
                    textInfo: 'Sign in',
                    isAccent: true,
                    onClick: signIn,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: StandardButton(
                    textInfo: 'Sign up',
                    onClick: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ResetPasswordScreen(),
                ),
              ),
              child: const Text(
                'Forget password?',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
