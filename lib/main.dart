import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_tracking_system/core/theme/app_theme.dart';
import 'package:vehicle_tracking_system/router.dart';

import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/bloc/auth_event.dart';
import 'features/driver/presentation/bloc/driver_bloc.dart';
import 'features/map/presentation/bloc/map_bloc.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';
import 'features/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'injection_container.dart';
import 'firebase_options.dart';   // ← Make sure this is imported

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('❌ Firebase Initialization Error: $e');
    // You can rethrow or show a user-friendly error here in production
  }

  // Initialize dependencies AFTER Firebase is ready
  await configureDependencies();

  runApp(const VehicleTrackingApp());
}

class VehicleTrackingApp extends StatelessWidget {
  const VehicleTrackingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(AuthCheckRequested())),
        BlocProvider(create: (_) => sl<DriverBloc>()),
        BlocProvider(create: (_) => sl<VehicleBloc>()),
        BlocProvider(create: (_) => sl<TrackingBloc>()),
        BlocProvider(create: (_) => sl<MapBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Vehicle Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: router,
      ),
    );
  }
}