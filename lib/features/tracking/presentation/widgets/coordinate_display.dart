import 'package:flutter/material.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/entities/location_entity.dart';

class CoordinateDisplay extends StatelessWidget {
  final LocationEntity location;

  const CoordinateDisplay({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CoordCard(
            label: 'Latitude',
            value: location.latitude.toStringAsFixed(5),
            icon: Icons.arrow_upward,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _CoordCard(
            label: 'Longitude',
            value: location.longitude.toStringAsFixed(5),
            icon: Icons.arrow_forward,
          ),
        ),
      ],
    );
  }
}

class _CoordCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _CoordCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}