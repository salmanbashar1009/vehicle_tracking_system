import 'package:flutter/material.dart';
import '../../../tracking/domain/entities/location_entity.dart';

class TrackingStatusIndicator extends StatelessWidget {
  final bool isActive;
  final String? vehicleId;
  final LocationEntity? location;

  const TrackingStatusIndicator({
    super.key,
    required this.isActive,
    this.vehicleId,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? Colors.green.shade200 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive ? Colors.green.shade100 : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActive ? Icons.location_on : Icons.location_off,
              color: isActive ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isActive ? 'Tracking Active' : 'Tracking Inactive',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isActive ? Colors.green.shade900 : Colors.grey.shade700,
                  ),
                ),
                if (isActive && vehicleId != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Vehicle ID: $vehicleId',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
                if (isActive && location != null) ...[
                  Text(
                    'Lat: ${location!.latitude.toStringAsFixed(4)}, Lng: ${location!.longitude.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green.shade700,
                    ),
                  ),
                ] else if (!isActive) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Start tracking to see live location',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          if (isActive)
            const _LiveBadge(),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatefulWidget {
  const _LiveBadge();

  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'LIVE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
