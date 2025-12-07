import 'package:control_cash/main.dart';
import 'package:control_cash/screens/delete_account_screen.dart';
import 'package:control_cash/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  final authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    Future<void> logOut() async {
      await authService.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyApp()),
            (_) => false,
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "ControlCash",
                    style: TextStyle(
                      color: theme.appBarTheme.foregroundColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.secondary,
                child: IconButton(
                  icon: Icon(Icons.person, color: theme.appBarTheme.foregroundColor),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: theme.scaffoldBackgroundColor,
                        title: Text("Profile", style: TextStyle(color: theme.colorScheme.primary)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email: ${authService.currentUser?.email ?? 'Unknown'}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ListTile(
                              leading: Icon(Icons.brightness_6, color: theme.iconTheme.color),
                              title: Text("Change Theme", style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                              onTap: () {
                                themeProvider.toggleTheme();
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.logout, color: theme.iconTheme.color),
                              title: Text("Logout", style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                              onTap: () => logOut(),
                            ),
                            ListTile(
                              leading: Icon(Icons.delete_forever, color: theme.colorScheme.error),
                              title: Text("Delete Account", style: TextStyle(color: theme.colorScheme.error)),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DeleteAccountScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Close", style: TextStyle(color: theme.colorScheme.primary)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
