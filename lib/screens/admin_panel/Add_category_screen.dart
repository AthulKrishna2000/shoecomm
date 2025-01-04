import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecomm/screens/models/category_model.dart';
import 'package:shoecomm/services/generate_ids.dart';
import 'package:shoecomm/utils/app_const.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController categorynamecontroller = TextEditingController();
    TextEditingController imagecontroller = TextEditingController();
    RxString imageurl = "".obs;
    // RxList<String> imageurl = <String>[].obs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add category'),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          Container(
            height: 65,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              cursorColor: AppConstant.appMainColor,
              textInputAction: TextInputAction.next,
              controller: categorynamecontroller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                hintText: "Category Name",
                hintStyle: TextStyle(fontSize: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            height: 65,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              cursorColor: AppConstant.appMainColor,
              textInputAction: TextInputAction.next,
              controller: imagecontroller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                hintText: "Image url",
                hintStyle: TextStyle(fontSize: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (imagecontroller.text.isNotEmpty) {
                // imageurl.add(imagecontroller.text.trim());
                imageurl.value = imagecontroller.text;

                // imagecontroller.clear(); // Clear after adding
              } else {
                Get.snackbar("Error", "Please enter a valid image URL.");
              }
            },
            icon: const Icon(Icons.add),
          ),
          Obx(
            () {
              return imageurl.isNotEmpty
                  ? Container(
                      height: Get.height * 0.3,
                      width: Get.width * 0.5,
                      child: Image.network(
                        imageurl.value,
                        fit: BoxFit.cover,
                      ))
                  : Text(imageurl.value);
            },
          ),
          ElevatedButton(
              onPressed: () async {
                String categoryId = await GenerateIds().generateCategoryId();
                try {
                  CategoriesModel categoriesModel = CategoriesModel(
                      categoryId: categoryId,
                      categoryName: categorynamecontroller.text,
                      categoryImg: imagecontroller.text);
                  await FirebaseFirestore.instance
                      .collection('categories')
                      .doc(categoryId)
                      .set(categoriesModel.toMap());
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("product add sucessfully"),
                      actions: [
                        MaterialButton(
                          onPressed: () {
                            navigator?.pop(context);
                          },
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                  categorynamecontroller.clear();
                  imagecontroller.clear();
                  imageurl.value = "";
                } catch (e) {
                  print("error : $e");
                }
              },
              child: const Text("Save"))
        ],
      ),
    );
  }
}
