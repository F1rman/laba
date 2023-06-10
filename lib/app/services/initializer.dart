import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laba/app/controllers/auth.dart';

import '../controllers/global_controller.dart';
import 'firebase_options.dart';

class Initializer {
  static Future<void> init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(options: options);
      await _initStorage();
      _initScreenPreference();
      _initApis();
    } catch (err) {
      rethrow;
    }
  }

  static void _initApis() async {
    final authController = AuthController();
    Get.put<AuthController>(
      authController,
    );
    final globalCtrl = GlobalController();
    Get.put<GlobalController>(
      globalCtrl,
    );

  }

  static Future<void> _initStorage() async {
    await GetStorage.init();
  }

  static void _initScreenPreference() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
