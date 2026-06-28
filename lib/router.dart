import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_tracking_system/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:vehicle_tracking_system/features/authentication/presentation/screens/login_screen.dart';

import 'features/authentication/presentation/bloc/auth_state.dart';
import 'features/authentication/presentation/screens/splash_screen.dart';
import 'injection_container.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final authState = sl<AuthBloc>().state;
    final isLoggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/splash';

    // If not authenticated and not on login/register, go to login
    if (authState is AuthUnauthenticated && !isLoggingIn) {
      return '/login';
    }

    // If authenticated and on login/register, go to appropriate dashboard
    if (authState is AuthAuthenticated && isLoggingIn) {
      return authState.user.role == 'driver' ? '/driver/dashboard' : '/user/dashboard';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // GoRoute(
    //   path: '/register',
    //   builder: (context, state) => const RegisterScreen(),
    // ),

    // User Routes
    // GoRoute(
    //   path: '/user/dashboard',
    //   builder: (context, state) => const UserDashboardScreen(),
    // ),
    // GoRoute(
    //   path: '/user/map',
    //   builder: (context, state) => const LiveMapScreen(),
    // ),
    // GoRoute(
    //   path: '/user/vehicles',
    //   builder: (context, state) => const VehicleListScreen(isDriverView: false),
    // ),
    //
    // // Driver Routes
    // GoRoute(
    //   path: '/driver/dashboard',
    //   builder: (context, state) => const DriverDashboardScreen(),
    // ),
    // GoRoute(
    //   path: '/driver/registration',
    //   builder: (context, state) => const DriverRegistrationScreen(),
    // ),
    // GoRoute(
    //   path: '/driver/vehicle/register',
    //   builder: (context, state) => const VehicleRegistrationScreen(),
    // ),
    // GoRoute(
    //   path: '/driver/vehicles',
    //   builder: (context, state) => const VehicleListScreen(isDriverView: true),
    // ),
  ],
);