import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:live_gps_tracking/features/tracking/domain/entities/location_entity.dart';
import 'package:live_gps_tracking/features/tracking/domain/repositories/tracking_repository.dart';

@LazySingleton(as: TrackingRepository)
class TrackingRepositoryImpl implements TrackingRepository {
  final FirebaseFirestore firestore;
  Timer? _simulationTimer;

  TrackingRepositoryImpl(this.firestore);

  @override
  Future<void> updateLocation(LocationEntity location) async {
    await firestore.collection('locations').doc(location.vehicleId).set({
      'vehicleId': location.vehicleId,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'timestamp': Timestamp.fromDate(location.timestamp),
    });
  }

  @override
  Stream<List<LocationEntity>> getLiveLocations() {
    return firestore.collection('locations').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => _fromSnapshot(doc)).toList());
  }

  @override
  Future<void> startTracking(String vehicleId) async {
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final random = Random();
      final lat = 23.8103 + (random.nextDouble() - 0.5) * 0.001;
      final lng = 90.4125 + (random.nextDouble() - 0.5) * 0.001;

      final location = LocationEntity(
        vehicleId: vehicleId,
        latitude: lat,
        longitude: lng,
        timestamp: DateTime.now(),
      );
      updateLocation(location);
    });
  }

  @override
  Future<void> stopTracking(String vehicleId) async {
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }

  LocationEntity _fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LocationEntity(
      vehicleId: data['vehicleId'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
