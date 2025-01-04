import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shoecomm/screens/admin_panel/Add_category_screen.dart';
import 'package:shoecomm/screens/admin_panel/edit_category_screen.dart';
import 'package:shoecomm/screens/models/category_model.dart';
import 'package:shoecomm/utils/app_const.dart';

class AdminAllCategoryScreen extends StatelessWidget {
  const AdminAllCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text('All category'),
        actions: [
          InkWell(
            onTap: () => Get.to(() => const AddCategoryScreen()),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
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
              child: Text('No category found!'),
            );
          }
          if (snapshot.data != null) {
            // ignore: sized_box_for_whitespace
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                CategoriesModel categoriesModel = CategoriesModel(
                    categoryId: data['categoryId'],
                    categoryName: data['categoryName'],
                    categoryImg: data['categoryImg']);
                return SwipeActionCell(
                    key: ObjectKey(categoriesModel.categoryId),

                    /// this key is necessary
                    trailingActions: <SwipeAction>[
                      SwipeAction(
                          title: "delete",
                          onTap: (CompletionHandler handler) async {
                            await Get.defaultDialog(
                              title: "Delete category",
                              content: const Text(
                                  "Are you sure you want to delete this category?"),
                              textCancel: "Cancel",
                              textConfirm: "Delete",
                              contentPadding: const EdgeInsets.all(10.0),
                              confirmTextColor: Colors.white,
                              onCancel: () {},
                              onConfirm: () async {
                                Get.back(); // Close the dialog
                                EasyLoading.show(status: 'Please wait..');

                                await FirebaseFirestore.instance
                                    .collection('categories')
                                    .doc(categoriesModel.categoryId)
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
                        // onTap: () {
                        //   Get.to(() => AdminSingleProductScreen(
                        //         productModel: productModel,
                        //       ));
                        // },
                        leading: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              categoriesModel.categoryImg),
                        ),
                        title: Row(
                          children: [
                            Text(categoriesModel.categoryName),
                          ],
                        ),
                        subtitle: Text(categoriesModel.categoryId),
                        trailing: GestureDetector(
                            onTap: () {
                              Get.to(() => EditCategoryScreen(
                                  categoriesModel: categoriesModel));
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
