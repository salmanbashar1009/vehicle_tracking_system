import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_tracking_system/core/constants/firebase_constants.dart';
import 'package:vehicle_tracking_system/core/errors/exceptions.dart';
import 'package:vehicle_tracking_system/features/driver/data/models/driver_model.dart';

abstract class DriverRemoteDatasource {
  Future<DriverModel> registerDriver(DriverModel driver);
  Future<DriverModel> getDriver(String id);
  Future<DriverModel> updateDriver(DriverModel driver);
  Future<List<DriverModel>> getAllDrivers();
  Future<void> deleteDriver(String id);
}

class DriverRemoteDatasourceImpl implements DriverRemoteDatasource {
  final FirebaseFirestore firestore;

  DriverRemoteDatasourceImpl({required this.firestore});

  @override
  Future<DriverModel> registerDriver(DriverModel driver) async {
    try {
      final docRef = await firestore
          .collection(FirebaseConstants.driversCollection)
          .add(driver.toFirestore());

      final doc = await docRef.get();
      return DriverModel.fromFirestore(doc).copyWith(id: docRef.id);
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to register driver', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<DriverModel> getDriver(String id) async {
    try {
      final doc = await firestore
          .collection(FirebaseConstants.driversCollection)
          .doc(id)
          .get();

      if (!doc.exists) {
        throw const FirestoreException(message: 'Driver not found');
      }

      return DriverModel.fromFirestore(doc);
    } on FirestoreException {
      rethrow;
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<DriverModel> updateDriver(DriverModel driver) async {
    try {
      await firestore
          .collection(FirebaseConstants.driversCollection)
          .doc(driver.id)
          .update({
        'name': driver.name,
        'email': driver.email,
        'phone': driver.phone,
      });

      return driver;
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to update driver', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<List<DriverModel>> getAllDrivers() async {
    try {
      final snapshot = await firestore
          .collection(FirebaseConstants.driversCollection)
          .get();

      return snapshot.docs
          .map((doc) => DriverModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to get drivers', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<void> deleteDriver(String id) async {
    try {
      await firestore
          .collection(FirebaseConstants.driversCollection)
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to delete driver', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }
}