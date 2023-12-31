import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/address_controller.dart';
import '../../../models/address_model.dart';

class TSingleAddress extends StatelessWidget {
  const TSingleAddress({
    super.key,
    required this.address,
    required this.onTap,
  });

  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    return Obx(
      () {
        final selectedAddressId = controller.selectedAddress.value.id;
        final isAddressSelected = selectedAddressId == address.id;
        return GestureDetector(
          onTap: onTap,
          child: TRoundedContainer(
            showBorder: true,
            padding: const EdgeInsets.all(TSizes.md),
            width: double.infinity,
            backgroundColor: isAddressSelected ? TColors.primary.withOpacity(0.5) : Colors.transparent,
            borderColor: isAddressSelected
                ? Colors.transparent
                : dark
                    ? TColors.darkerGrey
                    : TColors.grey,
            margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    onPressed: (){},
                    icon: Icon(
                      isAddressSelected ? Iconsax.tick_circle1 : Iconsax.tick_circle1,
                      color: isAddressSelected
                          ? TColors.primary
                          : dark
                              ? TColors.darkerGrey
                              : TColors.grey,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () {
                      controller.deleteAddress(address);
                    },
                    icon: Icon(
                      isAddressSelected ? Icons.delete : Icons.delete,
                      color: isAddressSelected
                          ? Colors.red
                          : dark
                              ? Colors.red
                              : Colors.red,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:[
                        Icon(Icons.location_on_outlined,size: TSizes.iconXs,),
                        SizedBox(width: TSizes.spaceBtwItems,),
                        Text(address.name,maxLines: 1,overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.titleLarge,),
                      ]
                    ),
                    const SizedBox(height: TSizes.sm ),
                    Row(
                      children:[
                        Icon(Icons.phone,size: TSizes.iconXs,),
                        SizedBox(width: TSizes.spaceBtwItems,),
                        Text(address.formattedPhoneNo, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ]
                    ),
                    const SizedBox(height: TSizes.sm / 2),
                    Row(
                      children:[
                        Icon(Icons.location_city_outlined,size: TSizes.iconXs),
                        SizedBox(width: TSizes.spaceBtwItems,),
                        Text(address.country+', '+address.city+', '+address.state, softWrap: true),
                      ]
                    ),
                    const SizedBox(height: TSizes.sm / 2),
                    Row(
                      children:[
                        Icon(Icons.directions_car_filled_outlined,size: TSizes.iconXs),
                        SizedBox(width: TSizes.spaceBtwItems,),
                        Text(address.street+', '+address.postalCode, softWrap: true)
                      ]
                    ),
                    
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
