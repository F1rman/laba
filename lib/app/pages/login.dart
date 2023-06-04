import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laba/app/controllers/auth.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthController auth = Get.find<AuthController>();

   @override
  void initState() {
    print('${'test'}');
    void checkIfLogined() async {
    if (auth.getUID() != null && auth.getUID() != '') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed('/');
      });
    }
  }
    super.initState();
  }

  RxString email = ''.obs;

  RxString pass = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              onChanged: (e) => {email.value = e},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            TextField(
              obscureText: true,
              onChanged: (e) => {pass.value = e},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password ',
              ),
            ),
            TextButton(
                onPressed: () {
                  auth.loginWithEmail(
                      email.value, pass.value, (e) => {print(e)});
                  Get.toNamed('/Home');
                },
                child: Text('Login')),
            TextButton(
                onPressed: () {
                  Get.toNamed('/registration');
                },
                child: Text('Register')),
          ],
        ),
      ),
    );
  }
}
