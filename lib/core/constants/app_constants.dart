class AppConstants {
  AppConstants._();

  static const String appName = 'Vehicle Tracker';
  static const String appVersion = '1.0.0';

  // Initial GPS coordinates (Dhaka, Bangladesh)
  static const double initialLatitude = 23.8103;
  static const double initialLongitude = 90.4125;

  // Tracking settings
  static const int trackingIntervalSeconds = 3;
  static const double gpsVariance = 0.0005;
  static const double defaultMapZoom = 13.0;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // Pagination
  static const int defaultPageSize = 20;

  // Validation
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  static const int minRegistrationLength = 5;
  static const int maxRegistrationLength = 20;
}