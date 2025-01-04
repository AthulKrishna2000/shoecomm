import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_card/image_card.dart';
import 'package:shoecomm/screens/models/category_model.dart';
import 'package:shoecomm/screens/user_panel/single_category_screen.dart';
import 'package:shoecomm/utils/app_const.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          'All Categories',
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(),
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
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No category found!'),
            );
          }
          if (snapshot.data != null) {
            // ignore: sized_box_for_whitespace
            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childAspectRatio: 1.19),
              itemBuilder: (context, index) {
                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: snapshot.data!.docs[index]['categoryId'],
                  categoryName: snapshot.data!.docs[index]['categoryName'],
                  categoryImg: snapshot.data!.docs[index]['categoryImg'],
                );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => AllSingalCategoryProductScreen(
                            categoryId: categoriesModel.categoryId));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 2.28,
                            heightImage: Get.height / 9,
                            imageProvider: CachedNetworkImageProvider(
                                categoriesModel.categoryImg),
                            title: Center(
                                child: Text(
                              categoriesModel.categoryName,
                              style: const TextStyle(fontSize: 12.0),
                            )),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
            // Container(
            //   height: Get.height / 5,
            //   child: ListView.builder(
            //     itemCount: snapshot.data!.docs.length,
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,

            //   ),
            // );
          }
          return const Text("error");
        },
      ),
    );
  }
}
