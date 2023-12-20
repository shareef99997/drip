import 'package:drip/utils/constants/colors.dart';
import 'package:drip/utils/constants/sizes.dart';
import 'package:drip/utils/theme/widget_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class Signup_Form extends StatelessWidget {
  const Signup_Form({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      child: Form(
          child: Padding(
          padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
          child: Column(
            children: [
              /// Email
              TextFormField(
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
              TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.password_check),
                    labelText: TTexts.password,
                    suffixIcon: Icon(Iconsax.eye_slash)),
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
                      Checkbox(
                        value: true,
                        onChanged: (value) {
                          // Todo
                        }
                      ),
                      Text(
                        TTexts.rememberMe,
                        style: dark
                          ? TTextTheme.darkTextTheme.displaySmall
                          : TTextTheme.lightTextTheme.displaySmall,
                      )
                    ],
                  ),
                  Spacer(),
                  /// Forget Passowrd ?
                  TextButton(
                    onPressed: () {
                      //Todo
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
                  onPressed: () {
                    // Todo
                  },
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
                    // Todo
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

