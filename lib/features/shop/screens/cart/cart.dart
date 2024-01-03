import 'package:drip/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/cart_controller.dart';
import '../checkout/checkout.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    return Scaffold(
      /// -- AppBar
      appBar: TAppBar(showBackArrow: true, title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall)),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),

          /// -- Items in Cart
          child: TCartItems(),
        ),
      ),

      /// -- Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
           onPressed: () {
              // Check if there are items in the cart
              if (controller.cartItems.isEmpty) {
                // Show Snackbar if the cart is empty
                Get.snackbar('Empty Cart', 'Your cart is empty.');
              } else {
                // Navigate to CheckoutScreen if the cart has items
                Get.to(() => const CheckoutScreen(), transition: Transition.leftToRightWithFade);
              }
            },
            child: Obx(() => Text('Checkout ${controller.totalCartPrice.value.toStringAsFixed(2)}')),
          ),
        ),
      ),
    );
  }
}
