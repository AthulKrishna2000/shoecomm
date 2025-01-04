import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shoecomm/controllers/get_user_data_controller.dart';
import 'package:shoecomm/screens/admin_panel/admin_main_screen.dart';
import 'package:shoecomm/screens/auth_ui/welcome_screen.dart';
import 'package:shoecomm/screens/user_panel/mainscreen.dart';
import 'package:shoecomm/utils/app_const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      loggdin(context);
    });
  }

  Future<void> loggdin(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController =
          Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);

      if (userData[0]['isAdmin'] == true) {
        Get.offAll(() => const AdminMainScreen());
      } else {
        Get.offAll(() =>  Mainscreen());
      }
    } else {
      Get.to(() => const Welcomscreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appSecendoryColor,
      appBar: AppBar(
        backgroundColor: AppConstant.appSecendoryColor,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.network(
              'https://lottie.host/c6cb51c5-f011-4451-9fdf-7ac9905012f1/qTYAp4do8b.json'),
          Container(
            width: Get.width,
            alignment: Alignment.center,
            child: Text(
              AppConstant.appPoweredBy,
              style: const TextStyle(
                  color: AppConstant.apptextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
