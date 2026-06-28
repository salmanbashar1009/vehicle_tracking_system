import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_tracking_system/features/vehicle/domain/entities/vehicle_entity.dart';

class VehicleModel extends VehicleEntity {
  const VehicleModel({
    required super.id,
    required super.driverId,
    required super.vehicleType,
    required super.vehicleName,
    required super.registrationNo,
    super.isTracking,
    super.createdAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String? ?? '',
      driverId: json['driverId'] as String? ?? '',
      vehicleType: _parseVehicleType(json['vehicleType'] as String?),
      vehicleName: json['vehicleName'] as String? ?? '',
      registrationNo: json['registrationNo'] as String? ?? '',
      isTracking: json['isTracking'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  factory VehicleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VehicleModel(
      id: doc.id,
      driverId: data['driverId'] as String? ?? '',
      vehicleType: _parseVehicleType(data['vehicleType'] as String?),
      vehicleName: data['vehicleName'] as String? ?? '',
      registrationNo: data['registrationNo'] as String? ?? '',
      isTracking: data['isTracking'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'driverId': driverId,
      'vehicleType': vehicleType.name,
      'vehicleName': vehicleName,
      'registrationNo': registrationNo,
      'isTracking': isTracking,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  static VehicleType _parseVehicleType(String? type) {
    if (type == null) return VehicleType.other;
    return VehicleType.values.firstWhere(
          (e) => e.name == type,
      orElse: () => VehicleType.other,
    );
  }

  factory VehicleModel.fromEntity(VehicleEntity entity) {
    return VehicleModel(
      id: entity.id,
      driverId: entity.driverId,
      vehicleType: entity.vehicleType,
      vehicleName: entity.vehicleName,
      registrationNo: entity.registrationNo,
      isTracking: entity.isTracking,
      createdAt: entity.createdAt,
    );
  }

  VehicleEntity toEntity() {
    return VehicleEntity(
      id: id,
      driverId: driverId,
      vehicleType: vehicleType,
      vehicleName: vehicleName,
      registrationNo: registrationNo,
      isTracking: isTracking,
      createdAt: createdAt,
    );
  }
}