import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoecomm/screens/models/product_mpdel.dart';
import 'package:shoecomm/screens/user_panel/product_details_screen.dart';
import 'package:shoecomm/utils/app_const.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  List allResults = [];
  List resultsList = [];
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    searchController.addListener(onSearchChange);
    super.initState();
  }

  onSearchChange() {
    print("searchController.text");
    searchresultList();
  }

  searchresultList() {
    var showResult = [];
    if (searchController.text != '') {
      for (var clienSnapshots in allResults) {
        var name = clienSnapshots['productName'].toString().toLowerCase();
        if (name.contains(searchController.text.toLowerCase())) {
          showResult.add(clienSnapshots);
        }
      }
    } else {
      showResult = List.from(allResults);
    }

    setState(() {
      resultsList = showResult;
    });
  }

  getProducts() async {
    var data = await FirebaseFirestore.instance
        .collection('products')
        .orderBy('productName')
        .get();

    setState(() {
      allResults = data.docs;
    });
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChange);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getProducts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: CupertinoSearchTextField(controller: searchController),
      ),
      body: ListView.builder(
        itemCount: resultsList.length,
        itemBuilder: (context, index) {
          ProductModel productModel = ProductModel(
              productId: resultsList[index]['productId'],
              categoryId: resultsList[index]['categoryId'],
              productName: resultsList[index]['productName'],
              categoryName: resultsList[index]['categoryName'],
              salePrice: resultsList[index]['salePrice'],
              fullPrice: resultsList[index]['fullPrice'],
              productImages: resultsList[index]['productImages'],
              deliveryTime: resultsList[index]['deliveryTime'],
              isSale: resultsList[index]['isSale'],
              productDescription: resultsList[index]['productDescription']);
          return GestureDetector(
            onTap: () {
              Get.to(ProductDetailsScreen(productModel: productModel));
            },
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(resultsList[index]['productImages'][0]),
              ),
              title: Text(resultsList[index]['productName']),
              subtitle: Text("${resultsList[index]['fullPrice']} Rs"),
            ),
          );
        },
      ),
    );
  }
}
