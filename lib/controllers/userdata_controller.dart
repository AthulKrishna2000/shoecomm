import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shoecomm/screens/models/user_model.dart';

class UserdataController extends GetxController {
  RxString username = ''.obs;
  RxString city = ''.obs;
  RxString phone = ''.obs;
  RxString email = ''.obs;
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void onInit() {
    super.onInit();
    fetchUserdata();
  }

  void fetchUserdata() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    Map<String, dynamic>? productData =
        snapshot.data() as Map<String, dynamic>?;
    UserModel userModel = UserModel(
      uId: productData?['uId'],
      username: productData?['username'],
      email: productData?['email'],
      phone: productData?['phone'],
      userImg: productData?['userImg'],
      userDeviceToken: productData?['userDeviceToken'],
      country: productData?['country'],
      userAddress: productData?['userAddress'],
      street: productData?['street'],
      isAdmin: productData?['isAdmin'],
      isActive: productData?['isActive'],
      createdOn: productData?['createdOn'],
      city: productData?['city'],
    );

    username.value = userModel.username;
    city.value = userModel.city;
    phone.value = userModel.phone;
    email.value = userModel.email;

    print(" username : $username");
    
  }
}
