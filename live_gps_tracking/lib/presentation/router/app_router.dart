import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/map/presentation/screens/live_map_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/driver/presentation/screens/driver_dashboard.dart';
import '../../features/vehicle/presentation/screens/vehicle_list_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/live-map',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/driver-dashboard', builder: (context, state) => const DriverDashboard()),
    GoRoute(path: '/live-map', builder: (context, state) => const LiveMapScreen()),
    GoRoute(path: '/vehicle-list', builder: (context, state) => const VehicleListScreen()),
  ],
);
