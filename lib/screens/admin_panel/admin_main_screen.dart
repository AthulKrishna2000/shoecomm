import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shoecomm/controllers/length_controller.dart';
import 'package:shoecomm/utils/app_const.dart';

import 'package:shoecomm/widget/admin_drawer_widget.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LengthController lengthController = Get.put(LengthController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("Admin panel"),
      ),
      drawer: const AdminDrawerWidget(),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Total numbers of users : ${lengthController.totalusers}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Total numbers of products : ${lengthController.totalProducts}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Total numbers of categories : ${lengthController.totalcategory}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Total numbers of orders : ${lengthController.totalOrders}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
