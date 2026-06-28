# 🚗 Live Multi-Vehicle GPS Tracking System

A Flutter-based real-time multi-vehicle GPS tracking application developed as an assessment project for **Rio Deep Technologies**.

---

## 📱 Project Overview

This project demonstrates a complete vehicle tracking platform consisting of two separate interfaces:

* **User Interface** for monitoring vehicles in real time.
* **Driver Interface** for vehicle management and simulated live location updates.

The application follows **Clean Architecture**, uses **BLoC** for state management, and stores data in **Firebase Cloud Firestore** with real-time synchronization.

---

# 📋 Table of Contents

* [Features](#-features)
* [Project Structure](#-project-structure)
* [Prerequisites](#-prerequisites)
* [Firebase Setup](#-firebase-setup)
* [Installation](#-installation)
* [Running the Project](#-running-the-project)
* [Technologies Used](#-technologies-used)
* [Architecture](#-architecture)
* [Platform Support](#-platform-support)
* [User Interface](#-user-interface)
* [Driver Interface](#-driver-interface)
* [Vehicle-Driver Relationship](#-vehicle-driver-relationship)
* [Live Tracking Simulation](#-live-tracking-simulation)
* [Limitations](#-limitations)

---

# ✨ Features

## User Side

* Dashboard with vehicle statistics
* Live vehicle tracking on OpenStreetMap
* Real-time marker updates
* Search vehicles by driver name
* Filter vehicles by type
* Vehicle details bottom sheet

## Driver Side

* Driver registration
* Vehicle management (Add/Edit)
* Start/Stop tracking
* Real-time coordinate updates
* Personal vehicle dashboard

---

# 📂 Project Structure

```
lib/
├── core/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── blocs/
│   ├── pages/
│   └── widgets/
└── injection/
```

---

# ✅ Prerequisites

Before running the project, make sure you have installed:

* Flutter SDK (>=3.0.0 <4.0.0)
* Dart SDK
* Android Studio or VS Code
* Flutter & Dart plugins
* Git

---

# 🔥 Firebase Setup

## 1. Create Firebase Project

Create a Firebase project named:

```
vehicle-tracker-demo
```

---

## 2. Register App

Add your Android/iOS application.

Example Android package name:

```
com.riodeep.vehicle_tracker
```

---

## 3. Download Firebase Configuration

Android:

```
android/app/google-services.json
```

iOS:

```
ios/Runner/GoogleService-Info.plist
```

---

## 4. Enable Firestore

Navigate to:

```
Firebase Console
→ Firestore Database
→ Create Database
→ Test Mode
```

---

## 5. (Optional)

Enable Firebase Authentication if extending the project.

---

# 🚀 Installation

Clone the repository:

```bash
git clone https://github.com/your-username/vehicle-tracking-system.git
```

Move into the project:

```bash
cd vehicle-tracking-system
```

Install dependencies:

```bash
flutter pub get
```

---

# ▶️ Running the Project

Run the application:

```bash
flutter run
```

---

## Demo Instructions

To quickly test the application:

1. Launch the app.
2. Select **Continue as User (Demo)**.
3. Open the **Live Map**.
4. If no vehicles appear, press the debug button that executes:

```dart
SeedData.populateDummyData()
```

This creates:

* 3 Drivers
* 5 Vehicles
* Initial locations

---

# 🛠 Technologies Used

| Technology         | Purpose                  |
| ------------------ | ------------------------ |
| Flutter            | Cross-platform framework |
| Dart               | Programming language     |
| flutter_bloc       | State management         |
| Equatable          | Value comparison         |
| GetIt              | Dependency Injection     |
| Injectable         | DI code generation       |
| Go Router          | Navigation               |
| Firebase Firestore | Real-time database       |
| flutter_map        | Interactive maps         |
| OpenStreetMap      | Map provider             |
| latlong2           | Coordinate utilities     |
| dartz              | Functional programming   |
| freezed            | Immutable models         |
| json_serializable  | JSON generation          |
| build_runner       | Code generation          |

---

# 🏗 Architecture

The project follows **Clean Architecture**.

```
Presentation
      │
      ▼
Domain
      │
      ▼
Data
      │
      ▼
Firebase Firestore
```

The architecture separates:

* UI
* Business Logic
* Data Sources

making the project scalable, maintainable, and testable.

---

# 📱 Platform Support

Built with Flutter.

Supports:

* ✅ Android
* ✅ iOS

Single codebase for both platforms.

---

# 👤 User Interface

The User Interface is intended for fleet managers and general users.

### Dashboard

Displays:

* Total registered vehicles
* Vehicle counts by category
* Active tracking count

Provides quick navigation actions.

---

### Live Tracking Map

Uses:

* OpenStreetMap
* flutter_map

Features:

* Custom markers by vehicle type
* Real-time updates
* Vehicle detail bottom sheet

---

### Vehicle List

Features:

* Search by driver name
* Filter by vehicle type
* Vehicle information panel

Displays:

* Driver name
* Phone
* Registration number
* Tracking status

---

# 🚚 Driver Interface

Designed for vehicle owners/drivers.

---

## Driver Registration

Collects:

* Name
* Email
* Phone

Data is stored in the Firestore **drivers** collection.

---

## Driver Dashboard

Displays:

* Driver profile
* Registered vehicles
* Current tracking status
* Live coordinates

---

## Vehicle Management

Drivers can:

* Add vehicles
* Edit vehicles

Supported vehicle types:

* Car
* Motorcycle
* Rickshaw
* CNG
* Delivery Vehicle
* Other

---

## Tracking Control

Drivers can:

* Start tracking
* Stop tracking

---

# 🔗 Vehicle-Driver Relationship

The project uses a **Foreign Key** relationship.

Each vehicle document contains:

```text
driverId
```

When a driver creates a vehicle:

```
Vehicle
      │
driverId
      │
      ▼
Driver
```

The map combines data from:

* drivers
* vehicles
* locations

using **StreamZip**, allowing each vehicle to be matched with its assigned driver.

---

# 📍 Live Tracking Simulation

Since this is an assessment project, GPS hardware is replaced with a realistic software simulation.

### Workflow

1. Start from central Dhaka coordinates

```
Latitude: 23.8103
Longitude: 90.4125
```

1. Every **3 seconds**, `Stream.periodic` emits a new event.

2. A small random offset

```
-0.0005
to
+0.0005
```

is added to latitude and longitude.

1. Updated coordinates are written to Firestore.

2. The User Interface listens to Firestore snapshots and updates the vehicle marker in real time.

---

# ⚠️ Limitations

### Authentication

Firebase Authentication is intentionally omitted for simplicity.

Drivers register using a simple form.

---

### Simulated Movement

Vehicles move using a random walk.

They do not follow actual road networks.

---

### Location History

Each vehicle overwrites its latest location.

A production-ready system would store historical coordinates to support route playback and polyline rendering.

---

### Offline Support

Offline caching is not implemented.

An active internet connection is required.

---

# 📄 License

This project was developed solely for the **Rio Deep Technologies Assessment** and is intended for demonstration and evaluation purposes.
