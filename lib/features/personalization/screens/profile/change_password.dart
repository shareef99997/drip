import 'package:drip/features/personalization/controllers/change_name_controller.dart';
import 'package:drip/features/personalization/controllers/change_password_controller.dart';
import 'package:drip/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';


class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatePasswordController());
    return Scaffold(
      /// Custom Appbar
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Change Password', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [                
            /// Headings
            Text('We will send an email to change your password.',
                 style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: TSizes.spaceBtwSections),
            Form(
              key: controller.updatePasswordFormKey,
              child: Column(
                children: [
                /// Text field and Button
                   TextFormField(
                      controller: controller.email,
                      validator: (value) =>
                          TValidator.validateEmptyText("Email", value),
                      decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.mail))),
                const SizedBox(height: TSizes.spaceBtwSections),
                // Button 
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.updatePassword(), child: const Text('Send'))),
                ],
              ),  
            ),
          ],
        ),
      ),
    );
  }
}
