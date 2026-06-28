# 🚗 Live Multi-Vehicle GPS Tracking System

A Flutter-based real-time multi-vehicle GPS tracking system developed as an assessment project. The application demonstrates Clean Architecture, BLoC state management, Firebase integration, and live vehicle tracking using simulated GPS data.

---

## 📑 Table of Contents

- Overview
- Platform
- Technologies Used
- Project Setup
- Running the Project
- User Interface
- Driver Interface
- Driver-Vehicle Relationship
- Live Tracking Architecture
- Limitations

---

# 📱 Overview

This project is a prototype of a **real-time fleet management system** built with **Flutter**.

The system contains two primary applications:

- **User App**
    - Monitor all vehicles
    - View live locations
    - Search and filter vehicles
    - View driver information

- **Driver App**
    - Register driver profile
    - Register vehicles
    - Start/Stop tracking
    - Publish live location updates

GPS movement is simulated mathematically and synchronized through Firebase Firestore in real time.

---

# 📱 Platform

This project is a **Flutter Mobile Application**.

Supported platforms:

- Android
- iOS

Although Flutter supports Web, this project is specifically designed for mobile devices because it relies on GPS tracking concepts and mobile-oriented UI patterns.

---

# 🛠 Technologies Used

## Framework

- Flutter (Dart)
- Clean Architecture
- SOLID Principles

---

## State Management

- flutter_bloc
- equatable

---

## Navigation & Dependency Injection

- go_router
- get_it

---

## Backend

- Firebase Core
- Cloud Firestore
- Firebase Authentication

---

## Maps

- flutter_map
- latlong2
- OpenStreetMap

---

## Utilities

- dartz
- uuid
- intl

---

# ⚙️ Project Setup

## Prerequisites

- Flutter SDK >=3.2.0 <4.0.0
- Android Studio or VS Code
- Firebase Project
- Android Emulator / iOS Simulator / Physical Device

---

## Firebase Configuration

### 1. Create Firebase Project

Create a new Firebase project.

Example:

```
vehicle-tracker-prototype
```

---

### 2. Enable Firestore

```
Build
    └── Firestore Database
            └── Create Database
                    └── Test Mode
```

---

### 3. Enable Authentication

```
Build
    └── Authentication
            └── Sign-in Method
                    └── Email/Password
```

---

### 4. Register Flutter App

Download

```
google-services.json
```

Copy it into

```
android/app/
```

---

## Install Dependencies

```bash
flutter pub get
```

---

# ▶️ Running the Project

## Step 1

Seed dummy data.

Inside

```
lib/main.dart
```

temporarily add:

```dart
import 'package:vehicle_tracking_system/core/utils/seed_data.dart';

await configureDependencies();
await seedDummyData();

runApp(const VehicleTrackingApp());
```

Run the application once.

After seeing:

```
✅ Dummy data seeded successfully!
```

remove

```dart
await seedDummyData();
```

---

## Step 2

Run the application

```bash
flutter run
```

For the prototype, you can simply click

```
Skip Login (Demo)
```

to enter the dashboard.

---

# 👤 User Interface

The User application is designed for fleet managers and normal users.

## Dashboard

Displays

- Total Vehicles
- Active Tracking
- Offline Vehicles
- Vehicle Categories

Provides quick navigation to

- Live Map
- Vehicle List

---

## Live Map

Features

- OpenStreetMap
- Live vehicle markers
- Vehicle status colors
- Interactive bottom sheet

Marker colors

| Status | Color |
|---------|-------|
| Online | 🟢 Green |
| Offline | ⚪ Grey |

Bottom Sheet displays

- Vehicle Name
- Vehicle Type
- Registration Number
- Driver Name
- Driver Phone
- GPS Coordinates
- Center on Map

---

## Vehicle List

Features

- Search by Driver Name
- Filter by Vehicle Type
- Scrollable vehicle cards

---

# 🚚 Driver Interface

Designed for drivers to manage vehicles and publish live GPS data.

---

## Driver Registration

Collects

- Name
- Email
- Phone Number

Stores information inside

```
drivers
```

Firestore collection.

---

## Driver Dashboard

Displays

- Driver Profile
- Assigned Vehicles
- Tracking Status
- Live Coordinates
- Quick Actions

Tracking status updates every

```
3 seconds
```

---

## Vehicle Management

Drivers can

- Add Vehicles
- Edit Vehicles
- View Vehicles

Supported types

- Car
- Motorcycle
- Rickshaw
- CNG
- Delivery Vehicle
- Other

---

## Tracking

Drivers simply press

```
Start Tracking
```

to begin publishing GPS data.

---

# 🔗 Driver-Vehicle Relationship

Database relationship

```
One Driver
      │
      ├──────── Vehicle A
      ├──────── Vehicle B
      └──────── Vehicle C
```

Firestore structure

```
drivers
    └── driverId

vehicles
    └── driverId
```

Every vehicle stores its owner's `driverId`.

The repository layer performs a join between

- drivers
- vehicles

and creates

```dart
class VehicleWithLocation {
  final VehicleEntity vehicle;
  final LocationEntity? location;
  final DriverEntity? driver;
}
```

This allows the UI to display driver and vehicle information together.

---

# 📡 Live Tracking Architecture

## Driver Side (Publisher)

```
Start Tracking
        │
        ▼
TrackingBloc
        │
        ▼
SimulatedLocationService
        │
        ▼
GpsSimulator
        │
        ▼
LocationEntity
        │
        ▼
Firestore
```

Location updates occur every

```
3 seconds
```

Coordinates are generated around Dhaka using random offsets.

---

## User Side (Subscriber)

```
Firestore
      │
      ▼
Snapshots()
      │
      ▼
MapBloc
      │
      ▼
VehicleWithLocation
      │
      ▼
FlutterMap
```

The application uses Firestore's real-time snapshot listeners, eliminating the need for polling.

---

# ⚠️ Prototype Limitations

This assessment project intentionally simplifies several production features.

### Simulated GPS

Uses mathematical coordinate generation instead of device GPS.

---

### Firestore Security

Runs in Test Mode.

Production applications should implement proper Firestore Security Rules.

---

### Stream Scalability

Current implementation is suitable for

- 10–50 vehicles

Large-scale systems should use

- GeoFirestore
- MQTT
- Dedicated WebSocket servers

---

### Authentication

The

```
Skip Login (Demo)
```

button bypasses Firebase Authentication.

---

### Route History

GPS history is stored in Firestore, but no UI exists for displaying historical routes.

---

### Serialization

Manual

```dart
toJson()
fromJson()
```

methods are used instead of

- freezed
- json_serializable

to avoid requiring code generation.

---

# 📌 Summary

This project demonstrates:

- Clean Architecture
- BLoC Pattern
- SOLID Principles
- Firebase Firestore
- Firebase Authentication
- Real-Time Streams
- OpenStreetMap Integration
- Driver & Vehicle Management
- Live Vehicle Tracking
- Flutter Best Practices

It serves as a strong architectural prototype for building scalable fleet management systems in Flutter.