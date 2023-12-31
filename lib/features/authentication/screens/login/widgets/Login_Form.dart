import 'package:drip/features/authentication/controllers/login/login_controller.dart';
import 'package:drip/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:drip/utils/constants/sizes.dart';
import 'package:drip/utils/theme/widget_themes/text_theme.dart';
import 'package:drip/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../home_menu.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../signup/signup.dart';

class FForm extends StatelessWidget {
  const FForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());


    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      child: Form(
          key: controller.loginFormKey,
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
          child: Column(
            children: [
              /// Email
              TextFormField(
                controller: controller.email,
                validator: (value) => TValidator.validateEmail(value),
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: TTexts.email
                ),
              ),
              /////////////////////////////////////////////
              SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              /// Password
              Obx(
            ()=> TextFormField(
              validator: (value) => TValidator.validateEmptyText('Password', value),
              controller: controller.password,
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
              /////////////////////////////////////////////
              SizedBox(
                height: TSizes.spaceBtwInputFields / 3,
              ),
              /// Remember me & Forget Password ?
              Row(
                children: [
                /// Remember me
                  Row(
                    children: [
                      Obx(
                        ()=> Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value
                        ),
                      ),
                      Text(
                        TTexts.rememberMe,
                        style: dark
                          ? TTextTheme.darkTextTheme.labelLarge
                          : TTextTheme.lightTextTheme.labelLarge,
                      )
                    ],
                  ),
                  Spacer(),
                  /// Forget Passowrd ?
                  TextButton(
                    onPressed: () {
                      Get.to(() => ForgetPassword(),transition: Transition.fadeIn);
                    },
                    child: Text(
                      TTexts.forgetPassword,
                      style: dark
                          ? TTextTheme.darkTextTheme.labelMedium
                          : TTextTheme.lightTextTheme.labelMedium,
                    ),
                  )
                ]
              ),
              /////////////////////////////////////////////
              SizedBox(
                height: TSizes.spaceBtwSections/2,
              ),
              /// Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:() => controller.emailAndPasswordSignIn(),
                  child: Text(
                    TTexts.signIn,
                    style: dark
                        ? TTextTheme.lightTextTheme.titleMedium
                        : TTextTheme.darkTextTheme.titleMedium,
                  ),
                ),
              ),
              /////////////////////////////////////////////
              SizedBox(
                height: TSizes.spaceBtwInputFields / 2,
              ),
              /// Create Account Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Get.to(() => SignupScreen(),transition: Transition.fadeIn);
                  },
                  child: Text(
                    TTexts.createAccount,
                  ),
                ),
              ),
              /////////////////////////////////////////////
            ],
          ),
      )),
    );
  }
}

