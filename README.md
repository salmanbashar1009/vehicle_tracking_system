```markdown
# Live Multi-Vehicle GPS Tracking System

A **production-grade Flutter application** for real-time multi-vehicle GPS tracking using **Clean Architecture**, **BLoC**, and **Firebase**.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

## 🏗️ Architecture

This project strictly follows **Clean Architecture** principles:

- **Domain Layer**: Entities, Repository Abstract Classes, Use Cases (Business Logic)
- **Data Layer**: Models, Data Sources (Firebase), Repository Implementations
- **Presentation Layer**: BLoCs (State Management), Screens, Widgets

## 🧩 Core Technologies

- **State Management**: `flutter_bloc` + `equatable`
- **Dependency Injection**: `get_it`
- **Navigation**: `go_router`
- **Backend/Firebase**: `cloud_firestore`, `firebase_auth`
- **Maps**: `flutter_map` + OpenStreetMap
- **Functional Error Handling**: `dartz` (Either/Left/Right)

## 🚀 Getting Started

### 1. Prerequisites

- Flutter SDK >= 3.2.0
- Firebase Project (Firestore & Auth enabled)
- Android Studio / VS Code

### 2. Firebase Setup

1. Create a Firebase project at the [Firebase Console](https://console.firebase.google.com).
2. Enable **Cloud Firestore**.
3. Enable **Authentication** (Email/Password).
4. Add your Android/iOS app and download `google-services.json` / `GoogleService-Info.plist`.
5. Place the config file in the appropriate directory (`android/app/` for Android).

### 3. Installation

```bash
# Clone the repository
git clone <repo-url>

# Navigate to project directory
cd vehicle_tracking_system

# Install dependencies
flutter pub get
```

### 4. Seed Dummy Data (Optional)

To test the app immediately with simulated vehicles:

1. Temporarily add a call to `seedDummyData()` inside `main.dart` right after `configureDependencies()`.
2. Run the app once.
3. Remove the seed call and hot restart.

The database will now contain sample data.

### 5. Run the App

```bash
flutter run
```

## 📱 App Flow

### User Interface

- **Dashboard**: View stats (Total vehicles, Active tracking, Categories).
- **Live Map**: View all tracked vehicles on OpenStreetMap with custom emoji markers.
- **Vehicle List**: Search & filter vehicles by type and driver name.

### Driver Interface

- **Registration**: Register as a driver (Name, Email, Phone).
- **Dashboard**: View profile, tracking status, and current coordinates.
- **Vehicle Management**: Add/Edit vehicles, select types (Car, CNG, Motorcycle, etc.).
- **Tracking**: Start/Stop simulated GPS tracking. Updates coordinates every 3 seconds to Firestore.

## 📂 Project Structure

```text
lib/
├── core/                  # Constants, Errors, Themes, Utilities, Services
├── features/              # Feature-based modules
│   ├── authentication/
│   ├── driver/
│   ├── vehicle/
│   ├── tracking/
│   └── map/
├── injection_container.dart   # Get_it Dependency Injection
├── router.dart                # GoRouter Configuration
└── main.dart                  # App Entry Point
```

## 🗺️ Map Integration

- Uses `flutter_map` with **OpenStreetMap** tiles.
- Markers change color based on tracking status:
    - **Green** = Live
    - **Grey** = Offline
- Bottom sheet displays vehicle & driver details on marker tap.
- Auto-centers on selected vehicle.

## 📡 Tracking Simulation

Because this is an assessment prototype, actual device GPS is replaced with a simulation engine (`GpsSimulator`):

- Base coordinates: **Dhaka, Bangladesh** (`23.8103, 90.4125`)
- Updates every **3 seconds** via `Stream.periodic`
- Adds random variance (`±0.0005`) to latitude/longitude to simulate realistic movement

---

**Made with ❤️ using Flutter & Firebase**
```

