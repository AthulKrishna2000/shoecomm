import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecomm/screens/admin_panel/specfic_order_screen.dart';
import 'package:shoecomm/utils/app_const.dart';

class AdminAllOrdersScreen extends StatelessWidget {
  const AdminAllOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("All orders"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            // .where('isAdmin', isEqualTo: false)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            // ignore: avoid_unnecessary_containers, sized_box_for_whitespace
            return Container(
              height: Get.height / 5,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No orders found!'),
            );
          }
          if (snapshot.data != null) {
            // ignore: sized_box_for_whitespace
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () => Get.to(() => SpecificOrderScreen(
                          docId: snapshot.data!.docs[index]["uId"],
                          customerName: snapshot.data!.docs[index]
                              ["customerName"],
                        )),
                    leading: CircleAvatar(
                      backgroundColor: AppConstant.appSecendoryColor,
                      child: Text(data['customerName'][0]),
                    ),
                    title: Text(data['customerName']),
                    subtitle: Text(data['custometrPhone']),
                    trailing: const Icon(Icons.edit),
                  ),
                );
              },
            );
          }
          return const Text("error1");
        },
      ),
    );
  }
}
