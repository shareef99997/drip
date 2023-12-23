import 'package:drip/utils/helpers/network_manager.dart';
import 'package:get/get.dart';

import '../features/shop/controllers/brand_controller.dart';
import '../features/personalization/controllers/address_controller.dart';
import '../features/personalization/controllers/user_controller.dart';
import '../features/shop/controllers/cart_controller.dart';
import '../features/shop/controllers/categories_controller.dart';
import '../features/shop/controllers/checkout_controller.dart';
import '../features/shop/controllers/product_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {

    Get.put(NetworkManager());
    /// -- Product Controllers
    Get.put(ProductController());
    Get.put(CartController());
    Get.put(CheckoutController());
    Get.put(CategoryController());
    Get.put(BrandController());

    /// -- User Controllers
    Get.put(UserController());
    Get.put(AddressController());
  }
}
