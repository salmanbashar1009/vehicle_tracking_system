import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_tracking_system/core/constants/firebase_constants.dart';
import 'package:vehicle_tracking_system/core/errors/exceptions.dart';
import 'package:vehicle_tracking_system/features/vehicle/data/models/vehicle_model.dart';

abstract class VehicleRemoteDatasource {
  Future<VehicleModel> addVehicle(VehicleModel vehicle);
  Future<VehicleModel> updateVehicle(VehicleModel vehicle);
  Future<VehicleModel> getVehicle(String id);
  Future<List<VehicleModel>> getVehicles();
  Future<List<VehicleModel>> getVehiclesByDriver(String driverId);
  Future<void> deleteVehicle(String id);
  Future<void> updateTrackingStatus(String vehicleId, bool isTracking);
  Stream<List<VehicleModel>> get vehiclesStream;
}

class VehicleRemoteDatasourceImpl implements VehicleRemoteDatasource {
  final FirebaseFirestore firestore;

  VehicleRemoteDatasourceImpl({required this.firestore});

  @override
  Future<VehicleModel> addVehicle(VehicleModel vehicle) async {
    try {
      final docRef = await firestore
          .collection(FirebaseConstants.vehiclesCollection)
          .add(vehicle.toFirestore());

      final doc = await docRef.get();
      return VehicleModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to add vehicle', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<VehicleModel> updateVehicle(VehicleModel vehicle) async {
    try {
      await firestore
          .collection(FirebaseConstants.vehiclesCollection)
          .doc(vehicle.id)
          .update({
        'driverId': vehicle.driverId,
        'vehicleType': vehicle.vehicleType.name,
        'vehicleName': vehicle.vehicleName,
        'registrationNo': vehicle.registrationNo,
        'isTracking': vehicle.isTracking,
      });

      return vehicle;
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to update vehicle', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<VehicleModel> getVehicle(String id) async {
    try {
      final doc = await firestore
          .collection(FirebaseConstants.vehiclesCollection)
          .doc(id)
          .get();

      if (!doc.exists) {
        throw const FirestoreException(message: 'Vehicle not found');
      }

      return VehicleModel.fromFirestore(doc);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<List<VehicleModel>> getVehicles() async {
    try {
      final snapshot = await firestore
          .collection(FirebaseConstants.vehiclesCollection)
          .get();

      return snapshot.docs
          .map((doc) => VehicleModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to get vehicles', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<List<VehicleModel>> getVehiclesByDriver(String driverId) async {
    try {
      final snapshot = await firestore
          .collection(FirebaseConstants.vehiclesCollection)
          .where(FirebaseConstants.vehicleDriverIdField, isEqualTo: driverId)
          .get();

      return snapshot.docs
          .map((doc) => VehicleModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to get vehicles', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<void> deleteVehicle(String id) async {
    try {
      await firestore
          .collection(FirebaseConstants.vehiclesCollection)
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to delete vehicle', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<void> updateTrackingStatus(String vehicleId, bool isTracking) async {
    try {
      await firestore
          .collection(FirebaseConstants.vehiclesCollection)
          .doc(vehicleId)
          .update({FirebaseConstants.vehicleIsTrackingField: isTracking});
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to update tracking status', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Stream<List<VehicleModel>> get vehiclesStream {
    return firestore
        .collection(FirebaseConstants.vehiclesCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => VehicleModel.fromFirestore(doc))
        .toList());
  }
}