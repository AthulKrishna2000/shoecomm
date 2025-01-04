import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoecomm/controllers/mainscreen_provider.dart';
import 'package:shoecomm/screens/user_panel/all_order_screen.dart';
import 'package:shoecomm/screens/user_panel/cart_screen.dart';
import 'package:shoecomm/screens/user_panel/homepage.dart';
import 'package:shoecomm/screens/user_panel/profilepage.dart';
import 'package:shoecomm/screens/user_panel/searchpage.dart';
import 'package:shoecomm/utils/app_const.dart';
import 'package:shoecomm/widget/bottomnavigation.dart';

// ignore: must_be_immutable
class Mainscreen extends StatelessWidget {
  Mainscreen({super.key});

  List<Widget> pageList = const [
    Homepage(),
    Searchpage(),
    AllOrderScreen(),
    //ProductByCart(),
    CartScreen(),
    Profilepage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<mainScreenNotifier>(
      builder: (context, mainscreenNotifier, child) {
        return Scaffold(
          // backgroundColor: const Color.fromARGB(255, 224, 220, 220),
          bottomNavigationBar: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppConstant.appMainColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bottomnavigation(
                    ontap: () {
                      mainscreenNotifier.pageIndex = 0;
                    },
                    icon: mainscreenNotifier.pageIndex == 0
                        ? Icons.home
                        : Icons.home_outlined,
                  ),
                  bottomnavigation(
                    ontap: () {
                      mainscreenNotifier.pageIndex = 1;
                    },
                    icon: mainscreenNotifier.pageIndex == 1
                        ? Icons.search
                        : Icons.search_rounded,
                  ),
                  bottomnavigation(
                    ontap: () {
                      mainscreenNotifier.pageIndex = 2;
                    },
                    icon: mainscreenNotifier.pageIndex == 2
                        ? Icons.add_box_outlined
                        : Icons.add,
                  ),
                  bottomnavigation(
                    ontap: () {
                      mainscreenNotifier.pageIndex = 3;
                    },
                    icon: mainscreenNotifier.pageIndex == 3
                        ? Icons.shopping_cart
                        : Icons.shopping_cart_outlined,
                  ),
                  bottomnavigation(
                    ontap: () {
                      mainscreenNotifier.pageIndex = 4;
                    },
                    icon: mainscreenNotifier.pageIndex == 4
                        ? Icons.person
                        : Icons.person_2_outlined,
                  ),
                ],
              ),
            ),
          )),
          body: pageList[mainscreenNotifier.pageIndex],
        );
      },
    );
  }
}
