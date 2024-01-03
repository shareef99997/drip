import 'package:drip/features/personalization/controllers/address_controller.dart';
import 'package:drip/features/shop/controllers/checkout_controller.dart';
import 'package:drip/features/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:drip/features/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:drip/home_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/products/cart/billing_amount_section.dart';
import '../../../../common/widgets/products/cart/coupon_code.dart';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/helpers/pricing_calculator.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/dummy_data.dart';
import '../cart/widgets/cart_items.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final checkoutController = CheckoutController.instance;
    final addressController = AddressController.instance;
    final cartController = CartController.instance;
    final subTotal = cartController.totalCartPrice.value;
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: const TAppBar(title: Text('Order Review'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// -- Items in Cart
              const TCartItems(showAddRemoveButtons: false),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Coupon TextField
              const TCouponCode(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Billing Section
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: Column(
                  children: [
                    /// Pricing
                    TBillingAmountSection(subTotal: subTotal),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Divider
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Payment Methods
                    const TBillingPaymentSection(),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Address
                    TBillingAddressSection(
                      name: TDummyData.user.fullName,
                      phoneNumber: TDummyData.user.formattedPhoneNo,
                      address: TDummyData.user.addresses.toString(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),

      /// -- Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom:TSizes.defaultSpace,right:TSizes.defaultSpace,left: TSizes.defaultSpace ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm Checkout'),
                content: Text('Are you sure you want to proceed with the checkout?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 40,),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        // Perform the checkout action
                        checkoutController.checkout(
                          TPricingCalculator.calculateTotalPrice(subTotal, 'US'),
                          addressController.selectedAddress.value.toString(),
                          checkoutController.selectedPaymentMethod.value.name.toString(),
                          checkoutController.selectedPaymentMethod.value.image.toString(),

                        );
                      },
                      child: Text('Checkout'),
                    ),
                  ),
                ],
              );
            },
          ),
            child: Text('Checkout \$${TPricingCalculator.calculateTotalPrice(subTotal, 'US').toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }

}
