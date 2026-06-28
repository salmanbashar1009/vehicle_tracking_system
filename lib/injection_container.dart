import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicle_tracking_system/core/network/network_info.dart';
import 'package:vehicle_tracking_system/core/services/location_service.dart';
import 'package:vehicle_tracking_system/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:vehicle_tracking_system/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:vehicle_tracking_system/features/authentication/domain/repositories/auth_repository.dart';
import 'package:vehicle_tracking_system/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:vehicle_tracking_system/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:vehicle_tracking_system/features/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:vehicle_tracking_system/features/authentication/presentation/bloc/auth_bloc.dart';

import 'features/driver/data/datasources/driver_remote_datasource.dart';
import 'features/driver/data/repositories/driver_repository_impl.dart';
import 'features/driver/domain/repositories/driver_repository.dart';
import 'features/driver/domain/usecases/get_driver_usecase.dart';
import 'features/driver/domain/usecases/register_driver_usecase.dart';
import 'features/driver/domain/usecases/update_driver_usecase.dart';
import 'features/driver/presentation/bloc/driver_bloc.dart';
import 'features/map/data/repositories/map_repository_impl.dart';
import 'features/map/domain/repositories/map_repository.dart';
import 'features/map/presentation/bloc/map_bloc.dart';
import 'features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'features/tracking/data/repositories/tracking_repository_impl.dart';
import 'features/tracking/domain/repositories/tracking_repository.dart';
import 'features/tracking/domain/usecases/get_live_locations_usecase.dart';
import 'features/tracking/domain/usecases/start_tracking_usecase.dart';
import 'features/tracking/domain/usecases/stop_tracking_usecase.dart';
import 'features/tracking/domain/usecases/update_location_usecase.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';
import 'features/vehicle/data/datasources/vehicle_remote_datasource.dart';
import 'features/vehicle/data/repositories/vehicle_repository_impl.dart';
import 'features/vehicle/domain/repositories/vehicle_repository.dart';
import 'features/vehicle/domain/usecases/add_vehicle_usecase.dart';
import 'features/vehicle/domain/usecases/get_vehicle_usecase.dart';
import 'features/vehicle/domain/usecases/get_vehicles_usecase.dart';
import 'features/vehicle/domain/usecases/update_vehicle_usecase.dart';
import 'features/vehicle/presentation/bloc/vehicle_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // --- External ---
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Connectivity());

  // --- Core ---
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<LocationService>(() => SimulatedLocationService());

  // --- Data Sources ---
  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl(firebaseAuth: sl()));
  sl.registerLazySingleton<DriverRemoteDatasource>(() => DriverRemoteDatasourceImpl(firestore: sl()));
  sl.registerLazySingleton<VehicleRemoteDatasource>(() => VehicleRemoteDatasourceImpl(firestore: sl()));
  sl.registerLazySingleton<TrackingRemoteDatasource>(() => TrackingRemoteDatasourceImpl(firestore: sl()));

  // --- Repositories ---
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDatasource: sl()));
  sl.registerLazySingleton<DriverRepository>(() => DriverRepositoryImpl(remoteDatasource: sl()));
  sl.registerLazySingleton<VehicleRepository>(() => VehicleRepositoryImpl(remoteDatasource: sl()));
  sl.registerLazySingleton<TrackingRepository>(() => TrackingRepositoryImpl(remoteDatasource: sl()));
  sl.registerLazySingleton<MapRepository>(() => MapRepositoryImpl(
    vehicleDatasource: sl(),
    driverDatasource: sl(),
    trackingDatasource: sl(),
  ));

  // --- Use Cases ---
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl()));

  sl.registerLazySingleton(() => RegisterDriverUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetDriverUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateDriverUseCase(repository: sl()));

  sl.registerLazySingleton(() => AddVehicleUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateVehicleUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetVehicleUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetVehiclesUseCase(repository: sl()));

  sl.registerLazySingleton(() => StartTrackingUseCase(repository: sl()));
  sl.registerLazySingleton(() => StopTrackingUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateLocationUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetLiveLocationsUseCase(repository: sl()));

  // --- BLoCs ---
  sl.registerFactory(() => AuthBloc(
    signInUseCase: sl(),
    signUpUseCase: sl(),
    signOutUseCase: sl(),
    // signUpUseCase: SignUpUseCase(repository: sl()),     // temporary
    // signOutUseCase: SignOutUseCase(repository: sl()),   // temporary
  ));

  sl.registerFactory(() => DriverBloc(
    registerDriverUseCase: sl(),
    getDriverUseCase: sl(),
    updateDriverUseCase: sl(),
  ));

  sl.registerFactory(() => VehicleBloc(
    addVehicleUseCase: sl(),
    updateVehicleUseCase: sl(),
    getVehicleUseCase: sl(),
    getVehiclesUseCase: sl(),
  ));

  sl.registerFactory(() => TrackingBloc(
    startTrackingUseCase: sl(),
    stopTrackingUseCase: sl(),
    updateLocationUseCase: sl(),
    getLiveLocationsUseCase: sl(),
    locationService: sl(),
  ));

  sl.registerFactory(() => MapBloc(mapRepository: sl()));
}