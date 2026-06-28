import 'package:fpdart/fpdart.dart';
import 'package:vehicle_tracking_system/core/errors/exceptions.dart';
import 'package:vehicle_tracking_system/core/errors/failures.dart';
import 'package:vehicle_tracking_system/features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:vehicle_tracking_system/features/tracking/data/models/location_model.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/entities/location_entity.dart';
import 'package:vehicle_tracking_system/features/tracking/domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDatasource remoteDatasource;

  TrackingRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, void>> startTracking(String vehicleId) async {
    try {
      await remoteDatasource.startTracking(vehicleId);
      return const Right(null);
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopTracking(String vehicleId) async {
    try {
      await remoteDatasource.stopTracking(vehicleId);
      return const Right(null);
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLocation(LocationEntity location) async {
    try {
      final model = LocationModel.fromEntity(location);
      await remoteDatasource.updateLocation(model);
      return const Right(null);
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LocationEntity?>> getLatestLocation(String vehicleId) async {
    try {
      final result = await remoteDatasource.getLatestLocation(vehicleId);
      return Right(result?.toEntity());
    } on FirestoreException catch (e) {
      return Left(FirestoreFailure(message: e.message, code: int.tryParse(e.code ?? '')));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Stream<LocationEntity?> getLiveLocation(String vehicleId) {
    return remoteDatasource.getLiveLocation(vehicleId).map(
          (model) => model?.toEntity(),
    );
  }

  @override
  Stream<Map<String, LocationEntity>> getAllLiveLocations() {
    return remoteDatasource.getAllLiveLocations().map(
          (map) => map.map((key, value) => MapEntry(key, value.toEntity())),
    );
  }
}