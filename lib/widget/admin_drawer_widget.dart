import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecomm/screens/admin_panel/Admin_all_category_screen.dart';
import 'package:shoecomm/screens/admin_panel/Admin_all_product_screen.dart';
import 'package:shoecomm/screens/admin_panel/admin_all_order_screen.dart';
import 'package:shoecomm/screens/admin_panel/all_user_screen.dart';
import 'package:shoecomm/screens/auth_ui/welcome_screen.dart';
import 'package:shoecomm/utils/app_const.dart';

class AdminDrawerWidget extends StatefulWidget {
  const AdminDrawerWidget({super.key});

  @override
  State<AdminDrawerWidget> createState() => _AdminDrawerWidgetState();
}

class _AdminDrawerWidgetState extends State<AdminDrawerWidget> {
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () {
                  Get.to(() => const AllUsersScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: const Text(
                  'users',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
                leading:
                    const Icon(Icons.person, color: AppConstant.apptextColor),
                trailing: const Icon(Icons.arrow_forward,
                    color: AppConstant.apptextColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () {
                  Get.to(() => const AdminAllOrdersScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: const Text(
                  'orders',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
                leading: const Icon(Icons.shopping_bag,
                    color: AppConstant.apptextColor),
                trailing: const Icon(Icons.arrow_forward,
                    color: AppConstant.apptextColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () {
                  Get.to(() => const AdminAllProductScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: const Text(
                  'Product',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
                leading: const Icon(Icons.production_quantity_limits,
                    color: AppConstant.apptextColor),
                trailing: const Icon(Icons.arrow_forward,
                    color: AppConstant.apptextColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: ListTile(
                onTap: () {
                  Get.to(() => const AdminAllCategoryScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: const Text(
                  'categories',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
                leading:
                    const Icon(Icons.category, color: AppConstant.apptextColor),
                trailing: const Icon(Icons.arrow_forward,
                    color: AppConstant.apptextColor),
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
                leading: Icon(Icons.phone, color: AppConstant.apptextColor),
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
