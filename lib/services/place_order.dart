import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shoecomm/screens/models/order_models.dart';
import 'package:shoecomm/screens/user_panel/mainscreen.dart';
import 'package:shoecomm/utils/app_const.dart';

import 'generate_order.dart';

void placeOrder(
    {required BuildContext context,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
    required String customerDeviceToken}) async {
  final User = FirebaseAuth.instance.currentUser;
  EasyLoading.show(status: "Please wait ..");
  if (User != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(User.uid)
          .collection('cartOrders')
          .get();

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;
        String orderId = generateOrderId();

        OrderModel cartModel = OrderModel(
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
            createdAt: DateTime.now(),
            updatedAt: data['updatedAt'],
            productQuantity: data['productQuantity'],
            productTotalPrice:
                double.parse(data['productTotalPrice'].toString()),
            customerId: User.uid,
            status: true,
            customerName: customerName,
            customerPhone: customerPhone,
            customerAddress: customerAddress,
            customerDeviceToken: customerDeviceToken,
            size: data['size']);
        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(User.uid)
              .set(
            {
              'uId': User.uid,
              'customerName': customerName,
              'custometrPhone': customerPhone,
              'customerAddress': customerAddress,
              'customerDeviceTocken': customerDeviceToken,
              'orderStatus': true,
              'createdAt': DateTime.now()
            },
          );

                  // uplode orders

          await FirebaseFirestore.instance
              .collection('orders')
              .doc(User.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(cartModel.toMap());

          await FirebaseFirestore.instance
              .collection('cart')
              .doc(User.uid)
              .collection('cartOrders')
              .doc(cartModel.productId.toString())
              .delete()
              .then(
                (value) => {
                  print("Delete cart product ${cartModel.productId.toString()}")
                },
              );
        }
      }
      print('order Confirmed');
      Get.snackbar("order Confirmed", "Thanku for your order!",
          backgroundColor: AppConstant.appMainColor,
          colorText: AppConstant.apptextColor,
          duration: Duration(seconds: 5));
      EasyLoading.dismiss();
      Get.offAll(() => Mainscreen());
    } catch (e) {
      print("error : $e");
    }
  }
}
