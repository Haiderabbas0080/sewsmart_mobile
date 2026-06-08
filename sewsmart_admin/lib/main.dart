import 'package:flutter/material.dart';
import 'core/theme/admin_theme.dart';
import 'modules/auth/admin_login_screen.dart';

void main() {
  runApp(const SewSmartAdminApp());
}

class SewSmartAdminApp extends StatelessWidget {
  const SewSmartAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SewSmart Admin',
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.light,
      home: const AdminLoginScreen(),
    );
  }
}
