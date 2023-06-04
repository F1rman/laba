import 'package:get/get.dart';
import 'package:laba/app/pages/home_page.dart';
import 'package:laba/app/pages/login.dart';
import 'package:laba/app/pages/registration.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(name: Routes.LOGIN, page: () =>  Login()),
    GetPage(name: Routes.HOME, page: () => HomePage()),
    GetPage(name: Routes.REGISTRATION, page: () =>  Registration()),
  ];
}
