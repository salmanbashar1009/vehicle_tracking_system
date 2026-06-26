class FirebaseConstants {
  FirebaseConstants._();

  // Collection names
  static const String driversCollection = 'drivers';
  static const String vehiclesCollection = 'vehicles';
  static const String locationsCollection = 'locations';
  static const String usersCollection = 'users';

  // Field names - Drivers
  static const String driverIdField = 'id';
  static const String driverNameField = 'name';
  static const String driverEmailField = 'email';
  static const String driverPhoneField = 'phone';

  // Field names - Vehicles
  static const String vehicleIdField = 'id';
  static const String vehicleDriverIdField = 'driverId';
  static const String vehicleTypeField = 'vehicleType';
  static const String vehicleNameField = 'vehicleName';
  static const String vehicleRegistrationNoField = 'registrationNo';
  static const String vehicleIsTrackingField = 'isTracking';

  // Field names - Locations
  static const String locationVehicleIdField = 'vehicleId';
  static const String locationLatitudeField = 'latitude';
  static const String locationLongitudeField = 'longitude';
  static const String locationTimestampField = 'timestamp';
}