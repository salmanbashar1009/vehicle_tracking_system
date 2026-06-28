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

  LocationEntity copyWith({
    String? vehicleId,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
  }) {
    return LocationEntity(
      vehicleId: vehicleId ?? this.vehicleId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}