import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shoecomm/controllers/is_sale_controller.dart';
import 'package:shoecomm/screens/admin_panel/add_product_screen.dart';
import 'package:shoecomm/screens/admin_panel/admin_single_product_screen.dart';
import 'package:shoecomm/screens/admin_panel/edit_produt_screen.dart';
import 'package:shoecomm/screens/models/product_mpdel.dart';
import 'package:shoecomm/utils/app_const.dart';

class AdminAllProductScreen extends StatefulWidget {
  const AdminAllProductScreen({super.key});

  @override
  State<AdminAllProductScreen> createState() => _AdminAllProductscreenState();
}

class _AdminAllProductscreenState extends State<AdminAllProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("All product "),
        actions: [
          GestureDetector(
              onTap: () {
                Get.to(() => const AddProdutScrenn());
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add,
                  color: AppConstant.apptextColor,
                ),
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
              child: Text('No product found!'),
            );
          }
          if (snapshot.data != null) {
            // ignore: sized_box_for_whitespace
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(
                    productId: data['productId'],
                    categoryId: data['categoryId'],
                    productName: data['productName'],
                    categoryName: data['categoryName'],
                    salePrice: data['salePrice'],
                    fullPrice: data['fullPrice'],
                    productImages: data['productImages'],
                    deliveryTime: data['deliveryTime'],
                    isSale: data['isSale'],
                    productDescription: data['productDescription']);
                return SwipeActionCell(
                    key: ObjectKey(productModel.productId),

                    /// this key is necessary
                    trailingActions: <SwipeAction>[
                      SwipeAction(
                          title: "delete ",
                          onTap: (CompletionHandler handler) async {
                            await Get.defaultDialog(
                              title: "Delete Product",
                              content: const Text(
                                  "Are you sure you want to delete this product?"),
                              textCancel: "Cancel",
                              textConfirm: "Delete",
                              contentPadding: const EdgeInsets.all(10.0),
                              confirmTextColor: Colors.white,
                              onCancel: () {},
                              onConfirm: () async {
                                Get.back(); // Close the dialog
                                EasyLoading.show(status: 'Please wait..');

                                await FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(productModel.productId)
                                    .delete();

                                EasyLoading.dismiss();
                              },
                              buttonColor: Colors.red,
                              cancelTextColor: Colors.black,
                            );
                          },
                          color: Colors.red),
                    ],
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        onTap: () {
                          Get.to(() => AdminSingleProductScreen(
                                productModel: productModel,
                              ));
                        },
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              productModel.productImages[0]),
                        ),
                        title: Row(
                          children: [
                            Text(productModel.productName),
                          ],
                        ),
                        subtitle: Text(productModel.categoryName),
                        trailing: GestureDetector(
                            onTap: () {
                              // ignore: non_constant_identifier_names
                              final isSaleController =
                                  Get.put(IsSaleController());
                              isSaleController
                                  .setIsSaleOldValue(productModel.isSale);
                              Get.to(() => EditProductScreen(
                                  productModel: productModel));
                            },
                            child: const Icon(Icons.edit)),
                      ),
                    ));
              },
            );
          }
          return const Text("error1");
        },
      ),
    );
  }
}
