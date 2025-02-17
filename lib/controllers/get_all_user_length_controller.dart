import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetAllUserLengthController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _userControllerSubscription;

  final Rx<int> userCollectionLength = Rx<int>(0);

  @override
  void onInit() {
    super.onInit();
    _userControllerSubscription = firestore
        .collection('users')
        .where('isAdmin', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      userCollectionLength.value = snapshot.size;
    });
  }

  @override
  void onClose() {
    _userControllerSubscription.cancel();
    super.onClose();
  }
}
