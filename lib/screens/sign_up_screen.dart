import 'package:control_cash/screens/story_screen.dart';
import 'package:control_cash/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../widgets/standard_input.dart';
import '../widgets/standard_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  bool isLoading = false;
  Future<void> signUp() async {
    setState(() => isLoading = true);
    try {
      await authService.signUp(emailController.text, passwordController.text);
    } catch (e) {
      print(e);
    } finally {
      setState(() => isLoading = false);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StoryScreen()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                    textInfo: 'Sign Up',
                    isAccent: true,
                    onClick: () => signUp(),
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Sign In', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
