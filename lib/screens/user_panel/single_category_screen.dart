import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_card/image_card.dart';
import 'package:shoecomm/screens/models/product_mpdel.dart';
import 'package:shoecomm/screens/user_panel/product_details_screen.dart';
import 'package:shoecomm/utils/app_const.dart';

class AllSingalCategoryProductScreen extends StatefulWidget {
  String categoryId;
  // ignore: non_constant_identifier_names
  AllSingalCategoryProductScreen({super.key, required this.categoryId});

  @override
  State<AllSingalCategoryProductScreen> createState() =>
      _AllSingleCategoriesProductScreenState();
}

class _AllSingleCategoriesProductScreenState
    extends State<AllSingalCategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          'products',
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('categoryId', isEqualTo: widget.categoryId)
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
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                  childAspectRatio: 0.80),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(
                    productId: productData['productId'],
                    categoryId: productData['categoryId'],
                    productName: productData['productName'],
                    categoryName: productData['categoryName'],
                    salePrice: productData['salePrice'],
                    fullPrice: productData['fullPrice'],
                    productImages: productData['productImages'],
                    deliveryTime: productData['deliveryTime'],
                    isSale: productData['isSale'],
                    productDescription: productData['productDescription']);
                // CategoriesModel categoriesModel = CategoriesModel(
                //   categoryId: snapshot.data!.docs[index]['categoryId'],
                //   categoryName: snapshot.data!.docs[index]['categoryName'],
                //   categoryImg: snapshot.data!.docs[index]['categoryImg'],
                // );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() =>
                            ProductDetailsScreen(productModel: productModel));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 2.5,
                            heightImage: Get.height / 9,
                            imageProvider: CachedNetworkImageProvider(
                                productModel.productImages[0]),
                            title: Center(
                              child: Text(
                                productModel.productName,
                                style: const TextStyle(fontSize: 12.0),
                              ),
                            ),
                            // footer: Text('Rs ${productModel.fullPrice}'),
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
