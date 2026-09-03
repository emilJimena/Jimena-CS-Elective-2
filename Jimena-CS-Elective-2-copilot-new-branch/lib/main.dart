import 'package:flutter/material.dart';

import 'pages/dashboard_page.dart';
import 'theme/app_theme.dart';

// Starts the Flutter application.
void main() => runApp(const MerchantDashboardApp());

// Stateful because the light/dark theme can change while the app is running.
class MerchantDashboardApp extends StatefulWidget {
  const MerchantDashboardApp({super.key});

  @override
  State<MerchantDashboardApp> createState() => _MerchantDashboardAppState();
}

class _MerchantDashboardAppState extends State<MerchantDashboardApp> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Merchant dashboard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        // MaterialApp applies the selected theme to every screen and widget.
        themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
        home: DashboardPage(
          onThemeToggle: () => setState(() => darkMode = !darkMode),
        ),
      );
}
