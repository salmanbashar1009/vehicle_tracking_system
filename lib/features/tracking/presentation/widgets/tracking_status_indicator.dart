import 'package:flutter/material.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/entities/location_entity.dart';

import 'coordinate_display.dart';

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
    return Card(
      color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isActive ? Icons.gps_fixed : Icons.gps_off,
                  color: isActive ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  isActive ? 'Tracking Active' : 'Tracking Inactive',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isActive ? Colors.green.shade800 : Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (isActive)
                  const PulseIndicator(),
              ],
            ),
            if (isActive && location != null) ...[
              const Divider(height: 24),
              CoordinateDisplay(location: location!),
            ],
          ],
        ),
      ),
    );
  }
}

class PulseIndicator extends StatefulWidget {
  const PulseIndicator({super.key});

  @override
  State<PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<PulseIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withValues(alpha: _controller.value),
          ),
        );
      },
    );
  }
}















// import 'package:flutter/material.dart';
// import '../../../tracking/domain/entities/location_entity.dart';
//
// class TrackingStatusIndicator extends StatelessWidget {
//   final bool isActive;
//   final String? vehicleId;
//   final LocationEntity? location;
//
//   const TrackingStatusIndicator({
//     super.key,
//     required this.isActive,
//     this.vehicleId,
//     this.location,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isActive
//             ? Colors.green.withValues(alpha: 0.1)
//             : Colors.grey.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isActive ? Colors.green.shade300 : Colors.grey.shade300,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: isActive
//                   ? Colors.green.withValues(alpha: 0.2)
//                   : Colors.grey.withValues(alpha: 0.2),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               isActive ? Icons.location_on : Icons.location_off,
//               color: isActive ? Colors.green : Colors.grey,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isActive ? 'Tracking Active' : 'Tracking Inactive',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: isActive ? Colors.green.shade900 : Colors.grey.shade700,
//                   ),
//                 ),
//                 if (isActive && vehicleId != null) ...[
//                   const SizedBox(height: 4),
//                   Text(
//                     'Vehicle ID: $vehicleId',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: Colors.green.shade700,
//                     ),
//                   ),
//                 ],
//                 if (isActive && location != null) ...[
//                   Text(
//                     'Lat: ${location!.latitude.toStringAsFixed(4)}, Lng: ${location!.longitude.toStringAsFixed(4)}',
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: Colors.green.shade700,
//                     ),
//                   ),
//                 ] else if (!isActive) ...[
//                   const SizedBox(height: 4),
//                   Text(
//                     'Start tracking to see live location',
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           if (isActive)
//             const _LiveBadge(),
//         ],
//       ),
//     );
//   }
// }
//
// class _LiveBadge extends StatefulWidget {
//   const _LiveBadge();
//
//   @override
//   State<_LiveBadge> createState() => _LiveBadgeState();
// }
//
// class _LiveBadgeState extends State<_LiveBadge> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     )..repeat(reverse: true);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _controller,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         decoration: BoxDecoration(
//           color: Colors.red,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const Text(
//           'LIVE',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 10,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }
