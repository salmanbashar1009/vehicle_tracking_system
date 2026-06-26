import 'dart:math';
import 'package:vehicle_tracking_system/core/constants/app_constants.dart';

class GpsSimulator {
  GpsSimulator._();

  static final Random _random = Random();

  static double _initialLatitude = AppConstants.initialLatitude;
  static double _initialLongitude = AppConstants.initialLongitude;

  static void reset() {
    _initialLatitude = AppConstants.initialLatitude;
    _initialLongitude = AppConstants.initialLongitude;
  }

  static void setInitialPosition(double latitude, double longitude) {
    _initialLatitude = latitude;
    _initialLongitude = longitude;
  }

  static double get currentLatitude => _initialLatitude;
  static double get currentLongitude => _initialLongitude;

  /// Generates a new coordinate near the current position
  static ({double latitude, double longitude}) generateNextCoordinate() {
    final latitudeDelta = (_random.nextDouble() * 2 - 1) * AppConstants.gpsVariance;
    final longitudeDelta = (_random.nextDouble() * 2 - 1) * AppConstants.gpsVariance;

    _initialLatitude += latitudeDelta;
    _initialLongitude += longitudeDelta;

    // Keep within reasonable bounds (Dhaka area)
    _initialLatitude = _initialLatitude.clamp(23.7000, 23.9000);
    _initialLongitude = _initialLongitude.clamp(90.3000, 90.5000);

    return (latitude: _initialLatitude, longitude: _initialLongitude);
  }

  /// Generates a random initial position for a new vehicle
  static ({double latitude, double longitude}) generateRandomStartPosition() {
    final latitude = AppConstants.initialLatitude +
        (Random().nextDouble() * 0.04 - 0.02);
    final longitude = AppConstants.initialLongitude +
        (Random().nextDouble() * 0.04 - 0.02);

    return (
    latitude: latitude.clamp(23.7000, 23.9000),
    longitude: longitude.clamp(90.3000, 90.5000),
    );
  }
}