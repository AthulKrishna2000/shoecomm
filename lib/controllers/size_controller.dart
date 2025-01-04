import 'package:flutter/foundation.dart';

class SizeController extends ChangeNotifier {
  String size = '';

  // String get size => _size;
  set selectedSize(String newSize) {
    size = newSize;
    notifyListeners();
  }
}
// import 'package:get/get.dart';

// class SizeController extends GetxController {
//   // Reactive variable for size
//   var size = "".obs;

//   // Setter to update the size
//   void setSize(String newSize) {
//     size.value = newSize;
//   }
// }
