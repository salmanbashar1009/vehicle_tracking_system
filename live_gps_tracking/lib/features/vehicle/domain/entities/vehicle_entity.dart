import 'package:equatable/equatable.dart';
import 'vehicle_type.dart';

class VehicleEntity extends Equatable {
  final String id;
  final String driverId;
  final VehicleType vehicleType;
  final String vehicleName;
  final String registrationNo;
  final bool isTracking;

  const VehicleEntity({
    required this.id,
    required this.driverId,
    required this.vehicleType,
    required this.vehicleName,
    required this.registrationNo,
    this.isTracking = false,
  });

  @override
  List<Object?> get props => [id, driverId, vehicleType, vehicleName, registrationNo, isTracking];
}
