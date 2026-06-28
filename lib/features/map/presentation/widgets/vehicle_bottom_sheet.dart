import 'package:flutter/material.dart';
import 'package:vehicle_tracking_system/features/driver/domain/entities/driver_entity.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/entities/location_entity.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';

class VehicleBottomSheet extends StatelessWidget {
  final VehicleEntity vehicle;
  final DriverEntity? driver;
  final LocationEntity? location;
  final VoidCallback onCenterMap;

  const VehicleBottomSheet({
    super.key,
    required this.vehicle,
    this.driver,
    this.location,
    required this.onCenterMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Row(
            children: [
              Text(
                vehicle.vehicleType.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vehicle.vehicleName, style: Theme.of(context).textTheme.titleLarge),
                    Text(vehicle.registrationNo, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: vehicle.isTracking ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  vehicle.isTracking ? Icons.gps_fixed : Icons.gps_off,
                  color: vehicle.isTracking ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),

          const Divider(height: 32),

          // Details
          _DetailRow(icon: Icons.category, title: 'Type', value: vehicle.vehicleType.displayName),
          if (driver != null) ...[
            const SizedBox(height: 16),
            _DetailRow(icon: Icons.person, title: 'Driver', value: driver!.name),
            const SizedBox(height: 16),
            _DetailRow(icon: Icons.phone, title: 'Phone', value: driver!.phone),
          ],
          if (location != null) ...[
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.my_location,
              title: 'Location',
              value: '${location!.latitude.toStringAsFixed(4)}, ${location!.longitude.toStringAsFixed(4)}',
            ),
          ],

          const SizedBox(height: 24),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onCenterMap,
              icon: const Icon(Icons.center_focus_strong),
              label: const Text('Center on Map'),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text('$title:', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }
}