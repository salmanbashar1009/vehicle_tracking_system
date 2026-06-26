import 'dart:async';
import 'package:vehicle_tracking_system/core/utils/gps_simulator.dart';
import 'package:vehicle_tracking_system/core/constants/app_constants.dart';

abstract class LocationService {
  Stream<({double latitude, double longitude})> get locationStream;
  void startTracking();
  void stopTracking();
  bool get isTracking;
  ({double latitude, double longitude}) get currentPosition;
}

class SimulatedLocationService implements LocationService {
  StreamController<({double latitude, double longitude})>? _controller;
  Timer? _timer;
  bool _isTracking = false;
  ({double latitude, double longitude}) _currentPosition = (
  latitude: AppConstants.initialLatitude,
  longitude: AppConstants.initialLongitude,
  );

  @override
  Stream<({double latitude, double longitude})> get locationStream {
    _controller ??= StreamController<({double latitude, double longitude})>.broadcast();
    return _controller!.stream;
  }

  @override
  void startTracking() {
    if (_isTracking) return;

    _isTracking = true;
    _controller ??= StreamController<({double latitude, double longitude})>.broadcast();

    // Emit initial position
    _currentPosition = GpsSimulator.generateNextCoordinate();
    _controller!.add(_currentPosition);

    _timer = Timer.periodic(
      Duration(seconds: AppConstants.trackingIntervalSeconds),
          (_) {
        _currentPosition = GpsSimulator.generateNextCoordinate();
        _controller!.add(_currentPosition);
      },
    );
  }

  @override
  void stopTracking() {
    _timer?.cancel();
    _timer = null;
    _isTracking = false;
  }

  @override
  bool get isTracking => _isTracking;

  @override
  ({double latitude, double longitude}) get currentPosition => _currentPosition;

  void setInitialPosition(double latitude, double longitude) {
    GpsSimulator.setInitialPosition(latitude, longitude);
    _currentPosition = (latitude: latitude, longitude: longitude);
  }

  void dispose() {
    stopTracking();
    _controller?.close();
  }
}