import 'package:equatable/equatable.dart';

enum VehicleType {
  car('Car', '🚗'),
  motorcycle('Motorcycle', '🏍️'),
  rickshaw('Rickshaw', '🛺'),
  cng('CNG', '🚐'),
  deliveryVehicle('Delivery Vehicle', '🚛'),
  other('Other', '🚲');

  final String displayName;
  final String emoji;
  const VehicleType(this.displayName, this.emoji);
}

class VehicleEntity extends Equatable {
  final String id;
  final String driverId;
  final VehicleType vehicleType;
  final String vehicleName;
  final String registrationNo;
  final bool isTracking;
  final DateTime? createdAt;

  const VehicleEntity({
    required this.id,
    required this.driverId,
    required this.vehicleType,
    required this.vehicleName,
    required this.registrationNo,
    this.isTracking = false,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, driverId, vehicleType, vehicleName, registrationNo, isTracking, createdAt];

  VehicleEntity copyWith({
    String? id,
    String? driverId,
    VehicleType? vehicleType,
    String? vehicleName,
    String? registrationNo,
    bool? isTracking,
    DateTime? createdAt,
  }) {
    return VehicleEntity(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleName: vehicleName ?? this.vehicleName,
      registrationNo: registrationNo ?? this.registrationNo,
      isTracking: isTracking ?? this.isTracking,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}