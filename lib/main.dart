import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'modules/auth/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Opens the app in the theme picked last time, light or dark.
  await ThemeController.load();
  runApp(const SewSmartApp());
}

class SewSmartApp extends StatelessWidget {
  const SewSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.light,
      builder: (context, light, _) => MaterialApp(
        title: 'SewSmart',
        debugShowCheckedModeBanner: false,
        theme: light ? AppTheme.light : AppTheme.dark,
        home: const SplashScreen(),
      ),
    );
  }
}
