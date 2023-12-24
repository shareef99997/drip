import 'package:drip/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:drip/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:drip/utils/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      /// Custom Appbar
      appBar: TAppBar(actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Headings
              Text(TTexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(TTexts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: TSizes.spaceBtwSections * 2),
      
              /// Text field
              Form(
                key: controller.ForgetPasswordFormkey,
                child: TextFormField(
                  controller: controller.email,
                  validator: TValidator.validateEmail,
                  decoration: InputDecoration(labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct_right)),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
      
              /// Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.sendPasswordResetEmail(),
                  child:Text(TTexts.submit),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
