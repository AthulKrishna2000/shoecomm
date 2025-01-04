import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shoecomm/screens/user_panel/all_categories_screen.dart';
import 'package:shoecomm/screens/user_panel/all_flash_sale_product.dart';
import 'package:shoecomm/screens/user_panel/all_product_screen.dart';
import 'package:shoecomm/utils/app_const.dart';
import 'package:shoecomm/widget/all_product_widget.dart';
import 'package:shoecomm/widget/banner_widget.dart';
import 'package:shoecomm/widget/category_widget.dart';
import 'package:shoecomm/widget/costum_drawer_widger.dart';
import 'package:shoecomm/widget/flash_sale_widget.dart';
import 'package:shoecomm/widget/heading_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConstant.apptextColor),
        backgroundColor: AppConstant.appMainColor,
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: AppConstant.appSecendoryColor,
        //     statusBarIconBrightness: Brightness.light),
        title: Text(
          AppConstant.appMainName,
          style: const TextStyle(color: AppConstant.apptextColor),
        ),
        centerTitle: true,
      ),
      drawer: const DrawWidgets(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: Get.height / 90.0,
            ),

            //banners
            const BannerWidget(),
            HeadingWidget(
                headingTitle: 'Categories',
                headingSubTitle: '',
                onTap: () {
                  Get.to(() => const AllCategoriesScreen());
                },
                buttonText: 'See more >'),
            const CategoryWidget(),
            HeadingWidget(
                headingTitle: 'Flash sales',
                headingSubTitle: '',
                onTap: () {
                  Get.to(() => const AllFlashSaleProductsScreen());
                },
                buttonText: 'See more >'),
            const FlashSaleWidget(),
            HeadingWidget(
                headingTitle: 'All products',
                headingSubTitle: '',
                onTap: () {
                  Get.to(() => const AllProductScreen());
                },
                buttonText: 'See more >'),
            const AllProductWidget()
          ],
        ),
      ),
    );
  }
}
