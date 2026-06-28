import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vehicle_tracking_system/core/constants/firebase_constants.dart';
import 'package:vehicle_tracking_system/core/errors/exceptions.dart';
import 'package:vehicle_tracking_system/features/tracking/data/models/location_model.dart';

abstract class TrackingRemoteDatasource {
  Future<void> startTracking(String vehicleId);
  Future<void> stopTracking(String vehicleId);
  Future<void> updateLocation(LocationModel location);
  Future<LocationModel?> getLatestLocation(String vehicleId);
  Stream<LocationModel?> getLiveLocation(String vehicleId);
  Stream<Map<String, LocationModel>> getAllLiveLocations();
}

class TrackingRemoteDatasourceImpl implements TrackingRemoteDatasource {
  final FirebaseFirestore firestore;

  TrackingRemoteDatasourceImpl({required this.firestore});

  @override
  Future<void> startTracking(String vehicleId) async {
    try {
      // Update vehicle tracking status
      await firestore
          .collection(FirebaseConstants.vehiclesCollection)
          .doc(vehicleId)
          .update({FirebaseConstants.vehicleIsTrackingField: true});
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to start tracking', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<void> stopTracking(String vehicleId) async {
    try {
      await firestore
          .collection(FirebaseConstants.vehiclesCollection)
          .doc(vehicleId)
          .update({FirebaseConstants.vehicleIsTrackingField: false});
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to stop tracking', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<void> updateLocation(LocationModel location) async {
    try {
      await firestore
          .collection(FirebaseConstants.locationsCollection)
          .add(location.toFirestore());
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to update location', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Future<LocationModel?> getLatestLocation(String vehicleId) async {
    try {
      final snapshot = await firestore
          .collection(FirebaseConstants.locationsCollection)
          .where(FirebaseConstants.locationVehicleIdField, isEqualTo: vehicleId)
          .orderBy(FirebaseConstants.locationTimestampField, descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return LocationModel.fromFirestore(snapshot.docs.first);
    } on FirebaseException catch (e) {
      throw FirestoreException(message: e.message ?? 'Failed to get location', code: e.code);
    } catch (e) {
      throw FirestoreException(message: e.toString());
    }
  }

  @override
  Stream<LocationModel?> getLiveLocation(String vehicleId) {
    return firestore
        .collection(FirebaseConstants.locationsCollection)
        .where(FirebaseConstants.locationVehicleIdField, isEqualTo: vehicleId)
        .orderBy(FirebaseConstants.locationTimestampField, descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return LocationModel.fromFirestore(snapshot.docs.first);
    });
  }

  @override
  Stream<Map<String, LocationModel>> getAllLiveLocations() {
    final controller = StreamController<Map<String, LocationModel>>();
    final locationMap = <String, LocationModel>{};

    // Get all tracking vehicles first
    firestore
        .collection(FirebaseConstants.vehiclesCollection)
        .where(FirebaseConstants.vehicleIsTrackingField, isEqualTo: true)
        .snapshots()
        .listen((vehicleSnapshot) {
      final trackingVehicleIds = vehicleSnapshot.docs.map((doc) => doc.id).toList();

      if (trackingVehicleIds.isEmpty) {
        locationMap.clear();
        controller.add(locationMap);
        return;
      }

      // Listen to latest location for each tracking vehicle
      for (final vehicleId in trackingVehicleIds) {
        firestore
            .collection(FirebaseConstants.locationsCollection)
            .where(FirebaseConstants.locationVehicleIdField, isEqualTo: vehicleId)
            .orderBy(FirebaseConstants.locationTimestampField, descending: true)
            .limit(1)
            .snapshots()
            .listen((locationSnapshot) {
          if (locationSnapshot.docs.isNotEmpty) {
            locationMap[vehicleId] = LocationModel.fromFirestore(locationSnapshot.docs.first);
          } else {
            locationMap.remove(vehicleId);
          }
          controller.add(Map.from(locationMap));
        });
      }
    });

    return controller.stream;
  }
}