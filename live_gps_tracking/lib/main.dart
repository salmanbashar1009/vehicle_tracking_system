import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:live_gps_tracking/injection_container.dart';
import 'package:live_gps_tracking/presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with dummy options to bypass native configuration crashes
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "dummy_api_key_for_testing_only",
      appId: "1:1234567890:android:abcdef123456",
      messagingSenderId: "1234567890",
      projectId: "dummy-gps-project",
      storageBucket: "dummy-gps-project.appspot.com",
    ),
  );

  await configureDependencies();
  runApp(const MyApp());
}