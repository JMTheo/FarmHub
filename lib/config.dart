import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import './services/auth_service.dart';

import './controller/db_controller.dart';
import './controller/iot_controller.dart';

initConfig() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //GetX Binding
  Get.lazyPut<AuthService>(() => AuthService());
  Get.lazyPut<IoTController>(() => IoTController(), fenix: true);
  Get.lazyPut<DBController>(() => DBController());
}
