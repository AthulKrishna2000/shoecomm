import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:shoecomm/controllers/calculate_product_rating_controller.dart';
import 'package:shoecomm/controllers/size_controller.dart';
import 'package:shoecomm/screens/models/cartModel.dart';
import 'package:shoecomm/screens/models/product_mpdel.dart';
import 'package:shoecomm/screens/models/review_model.dart';
import 'package:shoecomm/screens/user_panel/cart_screen.dart';
import 'package:shoecomm/utils/app_const.dart';
import 'package:shoecomm/widget/sizeChart.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    CalculateProductRatingController calculateProductRatingController = Get.put(
        CalculateProductRatingController(widget.productModel.productId));
    return Consumer<SizeController>(
      builder: (context, sizeController, child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: AppConstant.apptextColor),
            backgroundColor: AppConstant.appMainColor,
            title: const Text(
              'Product Details',
              style: TextStyle(color: AppConstant.apptextColor),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(() => const CartScreen());
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.shopping_cart),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  // product image
                  SizedBox(
                    height: Get.height / 60,
                  ),
                  CarouselSlider(
                    items: widget.productModel.productImages
                        .map(
                          (imageurls) => ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: imageurls,
                              fit: BoxFit.cover,
                              width: Get.width,
                              placeholder: (context, url) => const ColoredBox(
                                color: Colors.white,
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                        scrollDirection: Axis.horizontal,
                        autoPlay: true,
                        aspectRatio: 1,
                        viewportFraction: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.productModel.productName),
                                  const Icon(Icons.favorite_outline)
                                ],
                              ),
                            ),
                          ),
                          Obx(
                            () {
                              return Row(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: RatingBar.builder(
                                      glow: false,
                                      ignoreGestures: true,
                                      initialRating: double.parse(
                                          calculateProductRatingController
                                              .averageRating
                                              .toString()),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 25,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                  ),
                                  Text(calculateProductRatingController
                                      .averageRating
                                      .toString())
                                ],
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  widget.productModel.isSale == true &&
                                          widget.productModel.salePrice != ''
                                      ? Text(
                                          'Rs: ${widget.productModel.salePrice}')
                                      : Text(
                                          'Rs: ${widget.productModel.fullPrice}'),
                                ],
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text("Select Size  UK"),
                              ],
                            ),
                          ),
                          const Sizechart(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  "Category : ${widget.productModel.categoryName}"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child:
                                  Text(widget.productModel.productDescription),
                            ),
                          ),
                          Material(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: Get.height / 16,
                                width: Get.width / 2.0,
                                decoration: const BoxDecoration(
                                  color: AppConstant.appSecendoryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Get.to(() => const SigninScreen());
                                    print(sizeController.size);
                                    checkProductExistence(
                                        uId: user!.uid,
                                        size: sizeController.size);
                                  },
                                  child: const Text(
                                    'Add to cart',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Text("Reviews"),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('products')
                        .doc(widget.productModel.productId)
                        .collection('review')
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          child: Text('No review found!'),
                        );
                      }
                      if (snapshot.data != null) {
                        // ignore: sized_box_for_whitespace
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index];
                            ReviewModel reviewModel = ReviewModel(
                              customerName: data['customerName'],
                              customerPhone: data['customerPhone'],
                              customerDeviceToken: data['customerDeviceToken'],
                              customerId: data['customerId'],
                              feedback: data['feedback'],
                              rating: data['rating'],
                              createdAt: ['createdAt'],
                            );
                            return Card(
                              elevation: 5,
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(reviewModel.customerName[0]),
                                ),
                                title: Text(
                                  reviewModel.customerName,
                                ),
                                subtitle: Text(reviewModel.feedback),
                                trailing:
                                    Text("Rating : ${reviewModel.rating}"),
                              ),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> checkProductExistence(
      {required String uId,
      int quantityIncrement = 1,
      required String size}) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice) *
          updatedQuantity;
      await documentReference.update(
        {
          'productQuantity': updatedQuantity,
          'productTotalPrice': totalPrice,
        },
      );
      print("product exists");
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          'uId': uId,
          'createdAt': DateTime.now(),
        },
      );
      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        deliveryTime: widget.productModel.deliveryTime,
        isSale: widget.productModel.isSale,
        productDescription: widget.productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productModel.isSale
            ? widget.productModel.salePrice
            : widget.productModel.fullPrice),
        size: size,
      );
      await documentReference.set(cartModel.toMap());
      // await FirebaseFirestore.instance
      //     .collection('cart')
      //     .doc(uId)
      //     .collection('cartOrders')
      //     .doc(widget.productModel.productId.toString())
      //     .set(cartModel.toMap());
      print("product Add");
    }
  }
}
