import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'package:automacao_horta/services/auth_service.dart';

initConfig() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //GetX Binding
  Get.lazyPut<AuthService>(() => AuthService());
}
