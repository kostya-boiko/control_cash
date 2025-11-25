import 'package:control_cash/layout/home_layaut.dart';
import 'package:control_cash/screens/reset_screen.dart';
import 'package:control_cash/screens/sign_in_screen.dart';
import 'package:control_cash/screens/sign_up_screen.dart';
import 'package:control_cash/screens/stats_screen.dart';
import 'package:control_cash/screens/transactions_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes: {
        '/transactions': (_) => TransactionsScreen(),
        '/stats': (_) => StatsScreen(),
        '/signin': (_) => const SignInScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/reset-password': (_) => const ResetPasswordScreen(),
      },

      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const SignInScreen();
        }

        return const HomeLayout();
      },
    );
  }
}
