import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection_container.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async {
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  await getIt.init(environment: Environment.prod);
}
