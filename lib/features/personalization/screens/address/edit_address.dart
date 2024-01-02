import 'package:drip/features/personalization/controllers/address_controller.dart';
import 'package:drip/features/personalization/models/address_model.dart';
import 'package:drip/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../common/widgets/appbar/appbar.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    return Scaffold(
      appBar: const TAppBar(showBackArrow: true, title: Text('Add new Address')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: controller.addressFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (value) => TValidator.validateEmptyText("Name", value),
                      controller:controller.name,
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Name'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                       validator: (value) => TValidator.validateEmptyText("Phone Number", value),
                      controller:controller.phonenumber,
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.mobile), labelText: 'Phone Number'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                             validator: (value) => TValidator.validateEmptyText("Street", value),
                             controller:controller.street,
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: 'Street',
                              prefixIcon: Icon(Iconsax.building_31),
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                             controller:controller.postalcode,
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: 'Postal Code',
                              prefixIcon: Icon(Iconsax.code),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                             validator: (value) => TValidator.validateEmptyText("City", value),
                             controller:controller.city,
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              prefixIcon: Icon(Iconsax.building),
                            ),
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwInputFields),
                        Expanded(
                          child: TextFormField(
                             controller:controller.state,
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: 'State',
                              prefixIcon: Icon(Iconsax.activity),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                       validator: (value) => TValidator.validateEmptyText("Country", value),
                      controller:controller.country,
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.global), labelText: 'Country'),
                    ),
                    const SizedBox(height: TSizes.defaultSpace),
                    SizedBox(
                      width: double.infinity,
                      child:
                      ElevatedButton(
                        onPressed: () => controller.presaveAddress(),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
