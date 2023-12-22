import 'package:drip/features/personalization/controllers/address_controller.dart';
import 'package:drip/features/shop/controllers/brand_controller.dart';
import 'package:drip/features/shop/controllers/cart_controller.dart';
import 'package:drip/features/shop/controllers/categories_controller.dart';
import 'package:drip/features/shop/controllers/checkout_controller.dart';
import 'package:drip/features/shop/controllers/product_controller.dart';
import 'package:drip/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:drip/app.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

Future<void> main() async {

  Get_init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  // .then(
  //   (FirebaseApp value) => Get.put(AuthenticationRepository))
  ;
  

  //Todo: Add Widgets Binding
  //Todo: Init Local Storage
  //Todo: Await Native Splash
  
  //Todo: Initialize Authentication 
  
  runApp(const App());
}





void Get_init() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(CartController());
  Get.put(CategoryController());
  Get.put(ProductController());
  Get.put(BrandController());
  Get.put(AddressController());
  Get.put(CheckoutController());
}