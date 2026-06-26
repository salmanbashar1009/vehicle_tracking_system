enum VehicleType {
  car,
  motorcycle,
  rickshaw,
  cng,
  deliveryVehicle,
  other;

  String get displayName {
    switch (this) {
      case VehicleType.car:
        return 'Car';
      case VehicleType.motorcycle:
        return 'Motorcycle';
      case VehicleType.rickshaw:
        return 'Rickshaw';
      case VehicleType.cng:
        return 'CNG';
      case VehicleType.deliveryVehicle:
        return 'Delivery Vehicle';
      case VehicleType.other:
        return 'Other';
    }
  }
}
