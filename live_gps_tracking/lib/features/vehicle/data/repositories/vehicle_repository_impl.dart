import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:live_gps_tracking/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:live_gps_tracking/features/vehicle/domain/entities/vehicle_type.dart';
import 'package:live_gps_tracking/features/vehicle/domain/repositories/vehicle_repository.dart';

@LazySingleton(as: VehicleRepository)
class VehicleRepositoryImpl implements VehicleRepository {
  final FirebaseFirestore firestore;

  VehicleRepositoryImpl(this.firestore);

  @override
  Future<void> addVehicle(VehicleEntity vehicle) async {
    await firestore.collection('vehicles').doc(vehicle.id).set({
      'driverId': vehicle.driverId,
      'vehicleType': vehicle.vehicleType.name,
      'vehicleName': vehicle.vehicleName,
      'registrationNo': vehicle.registrationNo,
      'isTracking': vehicle.isTracking,
    });
  }

  @override
  Future<void> updateVehicle(VehicleEntity vehicle) async {
    await firestore.collection('vehicles').doc(vehicle.id).update({
      'vehicleName': vehicle.vehicleName,
      'isTracking': vehicle.isTracking,
    });
  }

  @override
  Future<List<VehicleEntity>> getVehicles() async {
    final snapshot = await firestore.collection('vehicles').get();
    return snapshot.docs.map((doc) => _fromSnapshot(doc)).toList();
  }

  @override
  Stream<List<VehicleEntity>> getVehiclesStream() {
    return firestore.collection('vehicles').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => _fromSnapshot(doc)).toList());
  }

  VehicleEntity _fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VehicleEntity(
      id: doc.id,
      driverId: data['driverId'],
      vehicleType: VehicleType.values.byName(data['vehicleType']),
      vehicleName: data['vehicleName'],
      registrationNo: data['registrationNo'],
      isTracking: data['isTracking'] ?? false,
    );
  }
}
