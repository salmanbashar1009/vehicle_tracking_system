// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:live_gps_tracking/features/tracking/data/repositories/tracking_repository_impl.dart'
    as _i78;
import 'package:live_gps_tracking/features/tracking/domain/repositories/tracking_repository.dart'
    as _i458;
import 'package:live_gps_tracking/features/vehicle/data/repositories/vehicle_repository_impl.dart'
    as _i549;
import 'package:live_gps_tracking/features/vehicle/domain/repositories/vehicle_repository.dart'
    as _i285;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i285.VehicleRepository>(
        () => _i549.VehicleRepositoryImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i458.TrackingRepository>(
        () => _i78.TrackingRepositoryImpl(gh<_i974.FirebaseFirestore>()));
    return this;
  }
}
