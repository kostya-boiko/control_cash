import 'package:control_cash/widgets/standard_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:control_cash/services/auth_service.dart';
import '../main.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final authService = AuthService();

  bool isLoading = false;
  String? errorText;

  Future<void> deleteAccount() async {
    setState(() {
      errorText = null;
      isLoading = true;
    });

    try {
      await authService.removeUser();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyApp()),
            (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == "requires-recent-login") {
          errorText = "Please sign in again before deleting your account.";
        } else {
          errorText = e.message ?? "Authentication error";
        }
      });
    } catch (e) {
      setState(() {
        errorText = "Unexpected error: $e";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text("Delete Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (errorText != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: errorColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: errorColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        errorText!,
                        style: TextStyle(
                          color: errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              "Are you sure you want to delete your account?",
              style: TextStyle(
                fontSize: 18,
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            StandardButton(
              textInfo: "Delete Account",
              onClick: deleteAccount,
              isLoading: isLoading,
              isAccent: true,
            ),
          ],
        ),
      ),
    );
  }
}
