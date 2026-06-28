import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_tracking_system/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:vehicle_tracking_system/features/vehicle/presentation/bloc/vehicle_bloc.dart';

import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../vehicle/presentation/bloc/vehicle_state.dart';

class UserDashboardScreen extends StatelessWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
              context.go('/login');
            },
          ),
        ],
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          int totalVehicles = 0;
          int activeTracking = 0;
          Map<VehicleType, int> categories = {};

          if (state is VehiclesLoaded) {
            totalVehicles = state.vehicles.length;
            activeTracking = state.vehicles.where((v) => v.isTracking).length;
            for (var v in state.vehicles) {
              categories[v.vehicleType] = (categories[v.vehicleType] ?? 0) + 1;
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back!', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),

                // Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.9,
                  children: [
                    _StatCard(
                      title: 'Total Vehicles',
                      value: '$totalVehicles',
                      icon: Icons.directions_car,
                      color: Colors.blue,
                    ),
                    _StatCard(
                      title: 'Active Tracking',
                      value: '$activeTracking',
                      icon: Icons.gps_fixed,
                      color: Colors.green,
                    ),
                    _StatCard(
                      title: 'Offline',
                      value: '${totalVehicles - activeTracking}',
                      icon: Icons.gps_off,
                      color: Colors.grey,
                    ),
                    _StatCard(
                      title: 'Categories',
                      value: '${categories.length}',
                      icon: Icons.category,
                      color: Colors.orange,
                    ),
                  ],
                ),

                // const SizedBox(height: 16),
                Text('Vehicle Categories', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),

                // Categories List
                if (categories.isEmpty)
                  const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('No vehicles registered yet.')))
                else
                  ...categories.entries.map((e) => ListTile(
                    leading: Text(e.key.emoji, style: const TextStyle(fontSize: 24)),
                    title: Text(e.key.displayName),
                    trailing: Text('${e.value} vehicles', style: TextStyle(color: Colors.grey[600])),
                  )),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/user/map'),
                    icon: const Icon(Icons.map),
                    label: const Text('Open Live Map'),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => context.push('/user/vehicles'),
                  icon: const Icon(Icons.list),
                  label: const Text('View All Vehicles'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}