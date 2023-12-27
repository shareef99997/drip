import 'package:drip/common/widgets/appbar/appbar.dart';
import 'package:drip/features/personalization/controllers/user_controller.dart';
import 'package:drip/utils/constants/sizes.dart';
import 'package:drip/utils/constants/text_strings.dart';
import 'package:drip/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';



class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;

    return Scaffold(
      /// Custom Appbar
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Re-Authenticate User', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [                
              /// Headings
              Text('we hope you would come back 😇',
                   style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: TSizes.spaceBtwSections),
              Form(
                key: controller.reAuthFormKey,
                child: Column(
                  children: [
                  /// Text field and Button
                     TextFormField(
                        controller: controller.verifyEmail,
                        validator: (value) =>
                            TValidator.validateEmail(value),
                        decoration: InputDecoration(
                            labelText: TTexts.email,
                            prefixIcon: Icon(Iconsax.direct_right))),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                     Obx(
                      ()=> TextFormField(
                        validator: (value) => TValidator.validateEmptyText('Password', value),
                        controller: controller.verifyPassword,
                        obscureText: controller.hidePassword.value,
                        decoration: InputDecoration(
                          labelText: TTexts.password,
                          prefixIcon: Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                            onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                            icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye)
                          )
                        ),
                      ),
                    ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(height: 350,),
                  // Button 
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => controller.reAuthenticateEmailAndPasswordUser(),child: const Text('Delete Account'))),
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
