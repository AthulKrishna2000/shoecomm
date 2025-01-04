import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:shoecomm/controllers/userdata_controller.dart';
import 'package:shoecomm/screens/auth_ui/welcome_screen.dart';

import 'package:shoecomm/utils/app_const.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  User? user = FirebaseAuth.instance.currentUser;

  UserdataController userdataController = Get.put(UserdataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConstant.apptextColor),
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          'Profile',
          style: TextStyle(color: AppConstant.apptextColor),
        ),
      ),
      body: Column(
        children: [
          Obx(() {
            return Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  // child: Text(userdataController.username.value[0]),
                  child: Text(userdataController.username.value.isNotEmpty
                      ? userdataController.username.value[0]
                      : "?"),
                ),
                Text(userdataController.username.value),
                Text(userdataController.email.value),
                Text(userdataController.city.value),
                Text(userdataController.phone.value),
              ],
            );
          }),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: ListTile(
                  onTap: () async {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    await auth.signOut();
                    Get.offAll(() => const Welcomscreen());
                  },
                  titleAlignment: ListTileTitleAlignment.center,
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: AppConstant.appSecendoryColor),
                  ),
                  leading:
                      const Icon(Icons.logout, color: AppConstant.appMainColor),
                  trailing: const Icon(Icons.arrow_forward,
                      color: AppConstant.appSecendoryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getuser() async {}
}
