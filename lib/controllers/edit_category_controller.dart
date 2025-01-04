// ignore_for_file: file_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:shoecomm/screens/models/category_model.dart';

class EditCategoryController extends GetxController {
  CategoriesModel categoriesModel;
  EditCategoryController({required this.categoriesModel});
  Rx<String> categoryImg = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getRealTimeCategoryImg();
  }

  void getRealTimeCategoryImg() {
    FirebaseFirestore.instance
        .collection('categories')
        .doc(categoriesModel.categoryId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['categoryImg'] != null) {
          // Update RxString
          categoryImg.value = data['categoryImg'].toString();
          print(categoryImg);
          update();
        }
      }
    });
  }

  //collection
  Future<void> deleteImageFromFireStore(
      String imageUrl, String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .update({'categoryImg': ''});
      update();
    } catch (e) {
      print("Error $e");
    }
  }

  //delete whole category from firestore
  Future<void> deleteWholeCategoryFromFireStore(String categoryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();
      update();
    } catch (e) {
      print("Error $e");
    }
  }
}
