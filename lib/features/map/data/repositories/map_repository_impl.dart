import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/exceptions.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/driver/data/datasources/driver_remote_datasource.dart';
import 'package:vehicle_tracking_system/features/driver/data/models/driver_model.dart';
import 'package:vehicle_tracking_system/features/map/domain/repositories/map_repository.dart';
import 'package:vehicle_tracking_system/features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:vehicle_tracking_system/features/vehicle/data/datasources/vehicle_remote_datasource.dart';

class MapRepositoryImpl implements MapRepository {
  final VehicleRemoteDatasource vehicleDatasource;
  final DriverRemoteDatasource driverDatasource;
  final TrackingRemoteDatasource trackingDatasource;

  MapRepositoryImpl({
    required this.vehicleDatasource,
    required this.driverDatasource,
    required this.trackingDatasource,
  });

  @override
  Future<Either<Failure, List<VehicleWithLocation>>> getAllVehiclesWithLocations() async {
    try {
      final vehicles = await vehicleDatasource.getVehicles();
      final drivers = await driverDatasource.getAllDrivers();
      final driverMap = {for (var d in drivers) d.id: d};

      final result = <VehicleWithLocation>[];
      for (final vehicle in vehicles) {
        final location = await trackingDatasource.getLatestLocation(vehicle.id);
        final driver = driverMap[vehicle.driverId];
        result.add(VehicleWithLocation(
          vehicle: vehicle.toEntity(),
          location: location?.toEntity(),
          driver: driver?.toEntity(),
        ));
      }

      return Right(result);
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<List<VehicleWithLocation>> getVehiclesWithLocationsStream() {
    final controller = StreamController<List<VehicleWithLocation>>();
    final vehiclesWithLocations = <VehicleWithLocation>[];
    final driverCache = <String, DriverModel>{};

    // Load drivers once
    driverDatasource.getAllDrivers().then((drivers) {
      for (final driver in drivers) {
        driverCache[driver.id] = driver;
      }
    });

    // Listen to vehicle changes
    vehicleDatasource.vehiclesStream.listen((vehicles) async {
      vehiclesWithLocations.clear();

      for (final vehicle in vehicles) {
        final driver = driverCache[vehicle.driverId];
        vehiclesWithLocations.add(VehicleWithLocation(
          vehicle: vehicle.toEntity(),
          driver: driver?.toEntity(),
        ));
      }

      controller.add(vehiclesWithLocations);
    });

    // Listen to location changes
    trackingDatasource.getAllLiveLocations().listen((locations) {
      for (var i = 0; i < vehiclesWithLocations.length; i++) {
        final vehicleId = vehiclesWithLocations[i].vehicle.id;
        final locationModel = locations[vehicleId];
        vehiclesWithLocations[i] = VehicleWithLocation(
          vehicle: vehiclesWithLocations[i].vehicle,
          location: locationModel?.toEntity(),
          driver: vehiclesWithLocations[i].driver,
        );
      }
      controller.add(List.from(vehiclesWithLocations));
    });

    return controller.stream;
  }
}

