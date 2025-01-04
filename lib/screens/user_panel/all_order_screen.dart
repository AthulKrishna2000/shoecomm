import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:shoecomm/controllers/cart_price_controller.dart';
import 'package:shoecomm/screens/models/order_models.dart';
import 'package:shoecomm/screens/user_panel/add_reviews_screen.dart';
import 'package:shoecomm/utils/app_const.dart';

class AllOrderScreen extends StatefulWidget {
  const AllOrderScreen({super.key});

  @override
  State<AllOrderScreen> createState() => _AllOrderScrreenState();
}

class _AllOrderScrreenState extends State<AllOrderScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConstant.apptextColor),
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "All Orders",
          style: const TextStyle(color: AppConstant.apptextColor),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
            .snapshots(),
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
            print("list ${snapshot.data!.docs}");
            return const Center(
              child: Text('No product found!'),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            final docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              print('No matching documents found.');
              return const Center(child: Text('No products found!'));
            }
          }
          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  OrderModel orderModel = OrderModel(
                    productId: productData['productId'],
                    categoryId: productData['categoryId'],
                    productName: productData['productName'],
                    categoryName: productData['categoryName'],
                    salePrice: productData['salePrice'],
                    fullPrice: productData['fullPrice'],
                    productImages: productData['productImages'],
                    deliveryTime: productData['deliveryTime'],
                    isSale: productData['isSale'],
                    productDescription: productData['productDescription'],
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt'],
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: double.parse(
                        productData['productTotalPrice'].toString()),
                    customerId: productData['customerId'],
                    status: productData['status'],
                    customerName: productData['customerName'],
                    customerAddress: productData['customerAddress'],
                    customerPhone: productData['customerPhone'],
                    customerDeviceToken: productData['customerDeviceToken'],
                    size: productData['size'],
                  );
                  productPriceController.fetchProductsPrice();
                  return Card(
                    elevation: 5,
                    color: AppConstant.apptextColor,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appMainColor,
                        backgroundImage:
                            NetworkImage(orderModel.productImages[0]),
                      ),
                      title: Text(orderModel.productName),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(orderModel.productTotalPrice.toString()),
                          const SizedBox(
                            width: 10.0,
                          ),
                          orderModel.status != true
                              ? const Text(
                                  'Pending......',
                                  style: TextStyle(color: Colors.green),
                                )
                              : const Text(
                                  "Deleverd",
                                  style: TextStyle(color: Colors.red),
                                )
                        ],
                      ),
                      trailing: orderModel.status == true
                          ? ElevatedButton(
                              onPressed: () {
                                Get.to(() => AddReviewsScreen(
                                      orderModel: orderModel,
                                    ));
                              },
                              child: const Text('Add Review'),
                            )
                          : const SizedBox.shrink(),
                    ),
                  );
                },
              ),
            );
          }
          return const Text("error");
        },
      ),
    );
  }
}
