import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vehicle_tracking_system/core/constants/firebase_constants.dart';

/// Run this function once to populate Firestore with dummy data for testing.
/// You can call this from a debug screen or a CLI script.
Future<void> seedDummyData() async {
  final firestore = FirebaseFirestore.instance;

  final batch = firestore.batch();

  // 1. Seed Drivers
  final driver1Ref = firestore.collection(FirebaseConstants.driversCollection).doc();
  final driver2Ref = firestore.collection(FirebaseConstants.driversCollection).doc();
  final driver3Ref = firestore.collection(FirebaseConstants.driversCollection).doc();

  batch.set(driver1Ref, {
    'name': 'John Doe',
    'email': 'john@email.com',
    'phone': '01711223344',
    'createdAt': FieldValue.serverTimestamp(),
  });

  batch.set(driver2Ref, {
    'name': 'Jane Smith',
    'email': 'jane@email.com',
    'phone': '01822334455',
    'createdAt': FieldValue.serverTimestamp(),
  });

  batch.set(driver3Ref, {
    'name': 'Hamid Hossain',
    'email': 'hamid@email.com',
    'phone': '01933445566',
    'createdAt': FieldValue.serverTimestamp(),
  });

  // 2. Seed Vehicles
  final vehicle1Ref = firestore.collection(FirebaseConstants.vehiclesCollection).doc();
  final vehicle2Ref = firestore.collection(FirebaseConstants.vehiclesCollection).doc();
  final vehicle3Ref = firestore.collection(FirebaseConstants.vehiclesCollection).doc();
  final vehicle4Ref = firestore.collection(FirebaseConstants.vehiclesCollection).doc();

  batch.set(vehicle1Ref, {
    'driverId': driver1Ref.id,
    'vehicleType': 'car',
    'vehicleName': 'Toyota Corolla',
    'registrationNo': 'DHAKA-12345',
    'isTracking': true,
    'createdAt': FieldValue.serverTimestamp(),
  });

  batch.set(vehicle2Ref, {
    'driverId': driver1Ref.id,
    'vehicleType': 'motorcycle',
    'vehicleName': 'Honda CBR',
    'registrationNo': 'DHAKA-54321',
    'isTracking': false,
    'createdAt': FieldValue.serverTimestamp(),
  });

  batch.set(vehicle3Ref, {
    'driverId': driver2Ref.id,
    'vehicleType': 'cng',
    'vehicleName': 'Green CNG Auto',
    'registrationNo': 'DHAKA-67890',
    'isTracking': true,
    'createdAt': FieldValue.serverTimestamp(),
  });

  batch.set(vehicle4Ref, {
    'driverId': driver3Ref.id,
    'vehicleType': 'deliveryVehicle',
    'vehicleName': 'Pathao Parcel Van',
    'registrationNo': 'DHAKA-98765',
    'isTracking': true,
    'createdAt': FieldValue.serverTimestamp(),
  });

  // 3. Seed Initial Locations
  final location1Ref = firestore.collection(FirebaseConstants.locationsCollection).doc();
  final location2Ref = firestore.collection(FirebaseConstants.locationsCollection).doc();
  final location3Ref = firestore.collection(FirebaseConstants.locationsCollection).doc();

  batch.set(location1Ref, {
    'vehicleId': vehicle1Ref.id,
    'latitude': 23.8103,
    'longitude': 90.4125,
    'timestamp': FieldValue.serverTimestamp(),
  });

  batch.set(location2Ref, {
    'vehicleId': vehicle3Ref.id,
    'latitude': 23.7935,
    'longitude': 90.4064,
    'timestamp': FieldValue.serverTimestamp(),
  });

  batch.set(location3Ref, {
    'vehicleId': vehicle4Ref.id,
    'latitude': 23.8225,
    'longitude': 90.4250,
    'timestamp': FieldValue.serverTimestamp(),
  });

  await batch.commit();
  if (kDebugMode) {
    print('✅ Dummy data seeded successfully!');
  }
}