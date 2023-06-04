import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laba/app/controllers/auth.dart';
import 'package:laba/app/controllers/firestore.dart';

class Registration extends StatelessWidget {
  Registration({super.key});
  AuthController authController = Get.find<AuthController>();
  RxString email = ''.obs;
  RxString pass = ''.obs;
  FirestoreController firestore = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (e) {
              email.value = e;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          TextField(
            onChanged: (e) => {pass.value = e},
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password ',
            ),
          ),
          TextButton(
              onPressed: () async {
                var resultUid = await authController.registerWithEmail(
                    email.value, pass.value, (e) => {print(e)});
                await firestore.createUser(resultUid!, {
                  'email': email.value,
                  'name': 'Developer',
                  'password': pass.value,
                  'uid': resultUid,
                  'createdAt': DateTime.now().toString(),
                });
                Get.toNamed('/login');
              },
              child: Text('Register')),
        ],
      ),
    );
  }
}
