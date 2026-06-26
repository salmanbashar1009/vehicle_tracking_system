import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String vehicleId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const LocationEntity({
    required this.vehicleId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [vehicleId, latitude, longitude, timestamp];
}
