import 'package:drip/data/repositories/repositories.authentication/authentication_repository.dart';
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
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
Future<void> main() async {
  //Init Get 
  Get_init();

  // Widgets Binding 
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // GetX Local Storage
  await GetStorage.init();

  // Todo: Await Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Init Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
   .then((FirebaseApp value) => Get.put(AuthenticationRepository()));
  
  runApp(App());
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