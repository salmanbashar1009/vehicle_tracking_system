import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vehicle_tracking_system/features/map/domain/repositories/map_repository.dart';

class VehicleMarker {
  static Marker createMarker({
    required VehicleWithLocation vehicleWithLocation,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final vehicle = vehicleWithLocation.vehicle;
    final location = vehicleWithLocation.location;

    if (location == null) {
      return Marker(
        point: LatLng(0, 0),
        width: 0,
        height: 0,
        builder: (ctx) => const SizedBox.shrink(),
      );
    }

    return Marker(
      point: LatLng(location.latitude, location.longitude),
      width: isSelected ? 80 : 60,
      height: isSelected ? 80 : 60,
      builder: (context) => GestureDetector(
        onTap: onTap,
        child: _MarkerWidget(
          emoji: vehicle.vehicleType.emoji,
          isTracking: vehicle.isTracking,
          isSelected: isSelected,
        ),
      ),
    );
  }
}

class _MarkerWidget extends StatelessWidget {
  final String emoji;
  final bool isTracking;
  final bool isSelected;

  const _MarkerWidget({
    required this.emoji,
    required this.isTracking,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : (isTracking ? Colors.green : Colors.grey),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(75),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        if (isTracking)
          Icon(
            Icons.circle,
            size: 8,
            color: Colors.green.shade700,
          ),
      ],
    );
  }
}
