import 'package:drip/features/personalization/controllers/change_name_controller.dart';
import 'package:drip/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';


class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      /// Custom Appbar
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Change Name', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [                
            /// Headings
            Text('Use real name for easy verification. This name will appear on several pages.',
                 style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: TSizes.spaceBtwSections),
            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                /// Text field and Button
                   TextFormField(
                      controller: controller.firstName,
                      validator: (value) =>
                          TValidator.validateEmptyText("First Name", value),
                      decoration: InputDecoration(
                          labelText: 'First Name',
                          prefixIcon: Icon(Iconsax.user_edit))),
                  const SizedBox(height: TSizes.spaceBtwInputFields),
                   TextFormField(
                    controller: controller.lastName,
                    validator: (value) =>TValidator.validateEmptyText("First Name", value),
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        prefixIcon: Icon(Iconsax.user_edit))),
                const SizedBox(height: TSizes.spaceBtwSections),
                // Button 
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.updateUserName(), child: const Text('Save'))),
                ],
              ),  
            ),
          ],
        ),
      ),
    );
  }
}
