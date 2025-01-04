import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecomm/screens/admin_panel/check_single_order_screen.dart';
import 'package:shoecomm/screens/models/order_models.dart';
import 'package:shoecomm/utils/app_const.dart';

// ignore: must_be_immutable
class SpecificOrderScreen extends StatefulWidget {
  String docId;
  String customerName;
  SpecificOrderScreen({
    super.key,
    required this.docId,
    required this.customerName,
  });

  @override
  State<SpecificOrderScreen> createState() => _SpecificOrderScreenState();
}

class _SpecificOrderScreenState extends State<SpecificOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: Text(widget.customerName),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.docId)
            .collection('confirmOrders')
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
                String orderDocId = data.id;
                OrderModel orderModel = OrderModel(
                    productId: data['productId'],
                    categoryId: data['categoryId'],
                    productName: data['productName'],
                    categoryName: data['categoryName'],
                    salePrice: data['salePrice'],
                    fullPrice: data['fullPrice'],
                    productImages: data['productImages'],
                    deliveryTime: data['deliveryTime'],
                    isSale: data['isSale'],
                    productDescription: data['productDescription'],
                    createdAt: data['createdAt'],
                    updatedAt: data['updatedAt'],
                    productQuantity: data['productQuantity'],
                    productTotalPrice: data['productTotalPrice'],
                    customerId: data['customerId'],
                    status: data['status'],
                    customerName: data['customerName'],
                    customerPhone: data['customerPhone'],
                    customerAddress: data['customerAddress'],
                    customerDeviceToken: data['customerDeviceToken'],
                    size: data['size']);

                return Card(
                  elevation: 5,
                  child: ListTile(
                      onTap: () => Get.to(() => CheckSingleOrderScreen(
                            docId: snapshot.data!.docs[index].id,
                            orderModel: orderModel,
                          )),
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appSecendoryColor,
                        child: Text(data['customerName'][0]),
                      ),
                      title: Text(data['customerName']),
                      subtitle: Text(orderModel.productName),
                      // trailing: Icon(Icons.edit),
                      trailing: InkWell(
                          onTap: () {
                            showBottomSheet(
                                userDocId: widget.docId,
                                ordermodel: orderModel,
                                orderDocid: orderDocId);
                          },
                          child: const Icon(Icons.more_vert))),
                );
              },
            );
          }
          return const Text("error1");
        },
      ),
    );
  }

  void showBottomSheet(
      {required String userDocId,
      required OrderModel ordermodel,
      required String orderDocid}) {
    Get.bottomSheet(
      Container(
        // height: Get.height / 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Update order status"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: AppConstant.apptextColor,
                        backgroundColor: AppConstant.appMainColor),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(userDocId)
                          .collection('confirmOrders')
                          .doc(orderDocid)
                          .update({
                        'status': false,
                      });
                    },
                    child: const Text('Pending'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: AppConstant.apptextColor,
                        backgroundColor: AppConstant.appMainColor),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(userDocId)
                          .collection('confirmOrders')
                          .doc(orderDocid)
                          .update({
                        'status': true,
                      });
                    },
                    child: const Text(
                      'Delevered',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
