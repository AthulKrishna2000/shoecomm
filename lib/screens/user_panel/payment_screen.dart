import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shoecomm/screens/user_panel/mainscreen.dart';
import 'package:shoecomm/services/place_order.dart';
import 'package:shoecomm/utils/app_const.dart';

class PaymentScreen extends StatefulWidget {
  final String customerPhone;
  final String customerName;
  final String customerAddress;
  final String customerDeviceToken;
  const PaymentScreen({
    super.key,
    required this.customerPhone,
    required this.customerName,
    required this.customerAddress,
    required this.customerDeviceToken,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController cardnumbercontroller = TextEditingController();
  TextEditingController expircontroller = TextEditingController();
  TextEditingController ccvcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          'Payment',
          style:  TextStyle(color: AppConstant.apptextColor),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Card(
                elevation: 5,
                child: Container(
                  height: Get.height / 2.0,
                  width: Get.width / 1.1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          height: 55.0,
                          child: TextFormField(
                            controller: cardnumbercontroller,
                            decoration: const InputDecoration(
                              labelText: 'Card number',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          height: 55.0,
                          child: TextFormField(
                            controller: expircontroller,
                            decoration: const InputDecoration(
                              labelText: 'expire',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        // ignore: sized_box_for_whitespace
                        child: Container(
                          height: 55.0,
                          child: TextFormField(
                            controller: ccvcontroller,
                            decoration: const InputDecoration(
                              labelText: 'CCV',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              hintStyle: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstant.appMainColor,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10)),
                        onPressed: () {
                          if (cardnumbercontroller.text != "" &&
                              expircontroller.text != "" &&
                              ccvcontroller.text != "") {
                            // place order services
                            // placeOrder(
                            //   context: context,
                            //   customerName: name,
                            //   customerPhone: phone,
                            //   customerAddress: address,
                            //   customerDeviceToken: customerToken,
                            // );

                            showCustomBottomSheet();
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("plese fill all detaies"),
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
                          }
                        },
                        child: const Text(
                          'Ok',
                          style: TextStyle(color: AppConstant.apptextColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomBottomSheet() {
    TextEditingController otpcontroller = TextEditingController();
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: otpcontroller,
                    decoration: const InputDecoration(
                      labelText: 'Enter OTP',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstant.appMainColor,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10)),
                onPressed: () {
                  if (otpcontroller.text != "") {
                    String name = widget.customerName;
                    String phone = widget.customerPhone;
                    String address = widget.customerAddress;
                    String customerToken = '';

                    // placeorder services
                    placeOrder(
                      context: context,
                      customerName: name,
                      customerPhone: phone,
                      customerAddress: address,
                      customerDeviceToken: customerToken,
                    );

                    Get.offAll(() => Mainscreen());
                  } else {
                    EasyLoading();
                    print("please fill all detailes");
                  }
                },
                child: const Text(
                  'Place Order',
                  style: TextStyle(color: AppConstant.apptextColor),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }
}
