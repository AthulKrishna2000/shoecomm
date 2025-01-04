import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:shoecomm/controllers/cart_price_controller.dart';
import 'package:shoecomm/screens/models/cartModel.dart';
import 'package:shoecomm/screens/user_panel/check_out_screen.dart';
import 'package:shoecomm/utils/app_const.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "cart Screen",
          style:  TextStyle(color: AppConstant.apptextColor),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
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
                  CartModel cartModel = CartModel(
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
                    size: productData['size'],
                  );
                  productPriceController.fetchProductsPrice();
                  return SwipeActionCell(
                      key: ObjectKey(cartModel.productId),
                      trailingActions: [
                        SwipeAction(
                          title: "Delete",
                          forceAlignmentToBoundary: true,
                          performsFirstActionWithFullSwipe: true,
                          onTap: (CompletionHandler handler) async {
                            print('deleted');
                            await FirebaseFirestore.instance
                                .collection('cart')
                                .doc(user!.uid)
                                .collection('cartOrders')
                                .doc(cartModel.productId)
                                .delete();
                          },
                        )
                      ],
                      child: Card(
                        elevation: 5,
                        color: AppConstant.apptextColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppConstant.appMainColor,
                            backgroundImage:
                                NetworkImage(cartModel.productImages[0]),
                          ),
                          title: Text(cartModel.productName),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(cartModel.productTotalPrice.toString()),
                              SizedBox(
                                width: Get.width / 20.0,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (cartModel.productQuantity > 1) {
                                    if (cartModel.isSale == true) {
                                      await FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.productId)
                                          .update({
                                        'productQuantity':
                                            cartModel.productQuantity - 1,
                                        'productTotalPrice':
                                            (double.parse(cartModel.salePrice) *
                                                (cartModel.productQuantity - 1))
                                      });
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.productId)
                                          .update({
                                        'productQuantity':
                                            cartModel.productQuantity - 1,
                                        'productTotalPrice':
                                            (double.parse(cartModel.fullPrice) *
                                                (cartModel.productQuantity - 1))
                                      });
                                    }
                                  }
                                },
                                child: const CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: AppConstant.appMainColor,
                                  child: Text("-"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "Qt: ${cartModel.productQuantity.toString()}"),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (cartModel.productQuantity > 0) {
                                    if (cartModel.isSale == true) {
                                      await FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.productId)
                                          .update({
                                        'productQuantity':
                                            cartModel.productQuantity + 1,
                                        'productTotalPrice':
                                            (double.parse(cartModel.salePrice) *
                                                (cartModel.productQuantity + 1))
                                      });
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.productId)
                                          .update({
                                        'productQuantity':
                                            cartModel.productQuantity + 1,
                                        'productTotalPrice':
                                            double.parse(cartModel.fullPrice) *
                                                (cartModel.productQuantity + 1)
                                      });
                                    }
                                  }
                                },
                                child: const CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: AppConstant.appMainColor,
                                  child: Text("+"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
                },
              ),
            );
          }
          return const Text("error");
        },
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Text(
                'Rs: ${productPriceController.totalPrice.value.toStringAsFixed(1)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40.0, 8.0, 10.0, 8.0),
              child: Material(
                child: Container(
                  height: Get.height / 18,
                  width: Get.width / 2.0,
                  decoration: const BoxDecoration(
                    color: AppConstant.appSecendoryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => const CheckoutScreen());
                    },
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
