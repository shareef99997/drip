import 'package:drip/features/personalization/controllers/change_name_controller.dart';
import 'package:drip/features/personalization/controllers/change_phone_controller.dart';
import 'package:drip/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';


class ChangePhoneNumber extends StatelessWidget {
  const ChangePhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatePhoneController());
    return Scaffold(
      /// Custom Appbar
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Change Phone Number', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [                
              /// Headings
              Form(
                key: controller.updatePhoneNumberFormKey,
                child: Column(
                  children: [
                  /// Text field and Button
                     TextFormField(
                        controller: controller.phonenumber,
                        validator: (value) =>
                          TValidator.validatePhoneNumber(value),
                        decoration: InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone))),
                  const SizedBox(height: 500),
                  // Button 
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.updatePhoneNumber(), child: const Text('Save'))),
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
