import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../personalization/controllers/address_controller.dart';

class TBillingAddressSection extends StatelessWidget {
  const TBillingAddressSection({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.address,
  });

  final String name, phoneNumber, address;

  @override
  Widget build(BuildContext context) {
    final addressController = AddressController.instance;
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          TSectionHeading(title: 'Shipping Address', buttonTitle: 'Change', showActionButton: true, onPressed: () => addressController.selectNewAddress(context)),
          Row(
            children: [
              const Icon(Icons.location_history, color: Colors.grey, size: 16),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text(addressController.selectedAddress.value.name, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems/2),
          Row(
            children: [
              const Icon(Icons.phone, color: Colors.grey, size: 16),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text(addressController.selectedAddress.value.formattedPhoneNo, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems/2),
          Row(
            children: [
              const Icon(Icons.location_city_rounded, color: Colors.grey, size: 16),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(child: Text(addressController.selectedAddress.value.country.toString()+", "+addressController.selectedAddress.value.state.toString()+", "+addressController.selectedAddress.value.city.toString(), style: Theme.of(context).textTheme.bodyMedium, softWrap: true)),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems/2),
          Row(
            children: [
              const Icon(Icons.drive_eta_outlined, color: Colors.grey, size: 16),
              const SizedBox(width: TSizes.spaceBtwItems),
              Expanded(child: Text(addressController.selectedAddress.value.street.toString()+", "+addressController.selectedAddress.value.postalCode.toString(), style: Theme.of(context).textTheme.bodyMedium, softWrap: true)),
            ],
          ),
        ],
      ),
    );
  }
}
