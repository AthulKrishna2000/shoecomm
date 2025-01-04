
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecomm/screens/auth_ui/welcome_screen.dart';
import 'package:shoecomm/utils/app_const.dart';

class DrawWidgets extends StatefulWidget {
  const DrawWidgets({super.key});

  @override
  State<DrawWidgets> createState() => _DrawWidgetsState();
}

class _DrawWidgetsState extends State<DrawWidgets> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        backgroundColor: AppConstant.appMainColor,
        child: Wrap(
          runSpacing: 10,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Athul',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
                subtitle: Text(
                  'ver 1.0.1',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
                leading: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: AppConstant.appSecendoryColor,
                  child: Text(
                    'A',
                    style: TextStyle(color: AppConstant.apptextColor),
                  ),
                ),
              ),
            ),
            const Divider(
              indent: 10.0,
              endIndent: 10.0,
              color: Colors.grey,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Home',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
                leading: Icon(Icons.home, color: AppConstant.apptextColor),
                trailing:
                    Icon(Icons.arrow_forward, color: AppConstant.apptextColor),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Product',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
                leading: Icon(Icons.production_quantity_limits,
                    color: AppConstant.apptextColor),
                trailing:
                    Icon(Icons.arrow_forward, color: AppConstant.apptextColor),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Orders',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
                leading:
                    Icon(Icons.shopping_bag, color: AppConstant.apptextColor),
                trailing:
                    Icon(Icons.arrow_forward, color: AppConstant.apptextColor),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  'Contact',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
                leading: Icon(Icons.help, color: AppConstant.apptextColor),
                trailing:
                    Icon(Icons.arrow_forward, color: AppConstant.apptextColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () async {
                  FirebaseAuth _auth = FirebaseAuth.instance;
                  await _auth.signOut();
                  Get.offAll(() => const Welcomscreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: const Text(
                  'Logout',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
                leading:
                    const Icon(Icons.logout, color: AppConstant.apptextColor),
                trailing: const Icon(Icons.arrow_forward,
                    color: AppConstant.apptextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
