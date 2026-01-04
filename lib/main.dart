import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/register_page.dart';
import 'pages/architect_dashboard_page.dart';

void main() {
  runApp(const TemanArsitekApp());
}

class TemanArsitekApp extends StatelessWidget {
  const TemanArsitekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teman Arsitek',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme, // Optional: Enable dark mode
      // themeMode: ThemeMode.system,
      initialRoute: '/dashboard',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/architect_dashboard': (context) => const ArchitectDashboardPage(),
      },
    );
  }
}
