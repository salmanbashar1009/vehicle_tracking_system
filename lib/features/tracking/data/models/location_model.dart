import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.vehicleId,
    required super.latitude,
    required super.longitude,
    required super.timestamp,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      vehicleId: json['vehicleId'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  factory LocationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LocationModel(
      vehicleId: data['vehicleId'] as String? ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'vehicleId': vehicleId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      vehicleId: entity.vehicleId,
      latitude: entity.latitude,
      longitude: entity.longitude,
      timestamp: entity.timestamp,
    );
  }

  LocationEntity toEntity() {
    return LocationEntity(
      vehicleId: vehicleId,
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
    );
  }
}