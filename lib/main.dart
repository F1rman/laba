import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';

import 'app/app.dart';
import 'app/services/initializer.dart';

void main() async {
  await Initializer.init();
  await GetStorage.init();
  runApp(const MyApp());
}
