import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_gps_tracking/core/theme/app_theme.dart';
import 'package:live_gps_tracking/presentation/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Live GPS Tracking',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
