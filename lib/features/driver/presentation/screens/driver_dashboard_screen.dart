import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vehicle_tracking_system/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:vehicle_tracking_system/features/tracking/presentation/bloc/tracking_bloc.dart';
import 'package:vehicle_tracking_system/features/vehicle/presentation/bloc/vehicle_bloc.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';

import '../../../authentication/presentation/bloc/auth_event.dart';
import '../../../tracking/presentation/bloc/tracking_state.dart';
import '../../../vehicle/presentation/bloc/vehicle_event.dart';
import '../../../vehicle/presentation/bloc/vehicle_state.dart';
import '../widgets/driver_info_card.dart';
import '../widgets/tracking_status_indicator.dart';

class DriverDashboardScreen extends StatelessWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
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
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, trackingState) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<VehicleBloc>().add(LoadVehiclesEvent());
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Driver Info Card
                  const DriverInfoCard(),
                  const SizedBox(height: 24),

                  // Tracking Status
                  TrackingStatusIndicator(
                    isActive: trackingState is TrackingActive,
                    vehicleId: trackingState is TrackingActive
                        ? trackingState.vehicleId
                        : null,
                    location: trackingState is TrackingActive
                        ? trackingState.currentLocation
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _QuickActionCard(
                        icon: Icons.add_circle_outline,
                        label: 'Add Vehicle',
                        color: Colors.blue,
                        onTap: () => context.push('/driver/vehicle/register'),
                      ),
                      _QuickActionCard(
                        icon: Icons.list_alt,
                        label: 'My Vehicles',
                        color: Colors.green,
                        onTap: () => context.push('/driver/vehicles'),
                      ),
                      _QuickActionCard(
                        icon: Icons.edit,
                        label: 'Edit Profile',
                        color: Colors.orange,
                        onTap: () {
                          // Navigate to edit profile
                        },
                      ),
                      _QuickActionCard(
                        icon: Icons.history,
                        label: 'Tracking History',
                        color: Colors.purple,
                        onTap: () {
                          // Navigate to history
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Vehicles Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Vehicles',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton(
                        onPressed: () => context.push('/driver/vehicles'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<VehicleBloc, VehicleState>(
                    builder: (context, vehicleState) {
                      if (vehicleState is VehicleLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (vehicleState is VehiclesLoaded) {
                        if (vehicleState.vehicles.isEmpty) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.directions_car,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No vehicles registered',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () => context.push('/driver/vehicle/register'),
                                    child: const Text('Add Vehicle'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vehicleState.vehicles.length > 3
                              ? 3
                              : vehicleState.vehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = vehicleState.vehicles[index];
                            return _VehicleListItem(
                              vehicleName: vehicle.vehicleName,
                              vehicleType: vehicle.vehicleType,
                              registrationNo: vehicle.registrationNo,
                              isTracking: vehicle.isTracking,
                              onTap: () {
                                // Handle vehicle tap
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleListItem extends StatelessWidget {
  final String vehicleName;
  final VehicleType vehicleType;
  final String registrationNo;
  final bool isTracking;
  final VoidCallback onTap;

  const _VehicleListItem({
    required this.vehicleName,
    required this.vehicleType,
    required this.registrationNo,
    required this.isTracking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isTracking ? Colors.green.shade100 : Colors.grey.shade200,
          child: Text(
            vehicleType.emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        title: Text(vehicleName),
        subtitle: Text(registrationNo),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isTracking)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Live',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Offline',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
