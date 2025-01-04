import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecomm/controllers/is_sale_controller.dart';
import 'package:shoecomm/screens/models/category_model.dart';
import 'package:shoecomm/screens/models/product_mpdel.dart';
import 'package:shoecomm/services/generate_ids.dart';
import 'package:shoecomm/utils/app_const.dart';

class AddProdutScrenn extends StatefulWidget {
  const AddProdutScrenn({super.key});

  @override
  State<AddProdutScrenn> createState() => _AddProdutScrennState();
}

class _AddProdutScrennState extends State<AddProdutScrenn> {
  IsSaleController isSaleController = Get.put(IsSaleController());

  TextEditingController productNameCotroller = TextEditingController();
  TextEditingController salePriceCotroller = TextEditingController();
  TextEditingController fullpriceCotroller = TextEditingController();
  TextEditingController deliveryTimeCotroller = TextEditingController();
  TextEditingController productDescriptionCotroller = TextEditingController();
  TextEditingController imagecontroller = TextEditingController();

  RxList<String> imageUrls = <String>[].obs; // hold the listvof urls

  @override
  void dispose() {
    // Dispose each controller when the widget is disposed
    productNameCotroller.dispose();
    salePriceCotroller.dispose();
    fullpriceCotroller.dispose();
    deliveryTimeCotroller.dispose();
    productDescriptionCotroller.dispose();
    imagecontroller.dispose();

    super.dispose(); // Always call the super dispose method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text("add products"),
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
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No categorie found!'),
            );
          }
          if (snapshot.data != null) {
            // ignore: sized_box_for_whitespace
            return Column(
              children: [
                const Text(
                  'select a category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  height: Get.height * 0.8,
                  width: Get.width,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
                      CategoriesModel categoriesModel = CategoriesModel(
                        categoryId: data['categoryId'],
                        categoryName: data['categoryName'],
                        categoryImg: data['categoryImg'],
                      );

                      return Card(
                        elevation: 5,
                        child: ListTile(
                          onTap: () {
                            showCustomBottomSheet(
                                categoryid: categoriesModel.categoryId,
                                categoryname: categoriesModel.categoryName);
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(categoriesModel.categoryImg),
                          ),
                          title: Text(categoriesModel.categoryName),
                          subtitle: Text(categoriesModel.categoryId),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Text("error1");
        },
      ),
    );
  }

  void showCustomBottomSheet(
      {required String categoryid, required String categoryname}) {
    Get.bottomSheet(
      Container(
        height: Get.height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("category : $categoryname"),
              Container(
                height: 50,
                width: Get.width,
                // color: Colors.amber,
                child:
                    GetBuilder<IsSaleController>(builder: (isSaleController) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("is sale"),
                          Switch(
                              value: isSaleController.isSale.value,
                              activeColor: AppConstant.appMainColor,
                              onChanged: (value) {
                                isSaleController.toggleIsSale(value);
                              })
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: productNameCotroller,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Product Name",
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
                    hintText: "Enter image url",
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
                    imageUrls.add(imagecontroller.text);
                    // print(imagecontroller.text.trim());
                    // print(imageUrls.length);
                    imagecontroller.clear();
                    // setState(() {
                    //   imageUrls.add(imagecontroller.text);
                    //   // print(imagecontroller.text.trim());
                    //   // print(imageUrls.length);
                    //   imagecontroller.clear();
                    // });
                  }
                },
                icon: const Icon(Icons.add),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return imageUrls.isNotEmpty
                    ? Container(
                        height: 150,
                        padding: const EdgeInsets.all(8),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                imageUrls[index],
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink();
              }),
              const SizedBox(height: 10),
              Obx(() {
                return isSaleController.isSale.value
                    ? Container(
                        height: 65,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          cursorColor: AppConstant.appMainColor,
                          textInputAction: TextInputAction.next,
                          controller: salePriceCotroller,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            hintText: "Sale Price",
                            hintStyle: TextStyle(fontSize: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }),
              const SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: fullpriceCotroller,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Full Price",
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
                  controller: deliveryTimeCotroller,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Delivery Time",
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
                  controller: productDescriptionCotroller,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Product Desc",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String produtId = await GenerateIds().generateProductId();
                  print(produtId);
                  print(imageUrls);
                  try {
                    ProductModel productModel = ProductModel(
                      productId: produtId,
                      categoryId: categoryid,
                      productName: productNameCotroller.text.trim(),
                      categoryName: categoryname,
                      salePrice: salePriceCotroller.text != ''
                          ? salePriceCotroller.text.trim()
                          : '',
                      fullPrice: fullpriceCotroller.text.trim(),
                      productImages: imageUrls,
                      deliveryTime: deliveryTimeCotroller.text.trim(),
                      isSale: isSaleController.isSale.value,
                      productDescription:
                          productDescriptionCotroller.text.trim(),
                    );
                    await FirebaseFirestore.instance
                        .collection('products')
                        .doc(produtId)
                        .set(
                          productModel.toMap(),
                        );
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
                  } catch (e) {
                    print("error : $e");
                  }
                },
                child: const Text("upload"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
