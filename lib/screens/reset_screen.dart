import 'package:flutter/material.dart';
import '../widgets/standard_input.dart';
import 'sign_in_screen.dart';
import '../widgets/standard_button.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/1024px-Google-flutter-logo.svg.png', width: 300,),
            SizedBox(height: 30),
            StandardInput(isObscureText: false, labelText: 'Email'),
            SizedBox(height: 10),
            Row(children: [Expanded(child: StandardButton(textInfo: 'Reset password', isAccent: true,))],),
            TextButton(onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
            ),
                child: Text('Sign In')),
          ],
        ),
      ),
    );
  }
}
