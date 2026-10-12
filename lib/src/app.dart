import 'package:flutter/material.dart';
import 'package:campus_kart/src/core/router/app_router.dart';
import 'package:campus_kart/src/core/theme/app_theme.dart';

/// Root application widget for CampusKart.
/// Wires together [AppTheme] and [AppRouter] only — no page code here.
class CampusKartApp extends StatelessWidget {
  const CampusKartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CampusKart',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
