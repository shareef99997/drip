import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      child: Column(
        children: [
          // Divider
          TFormDivider(dividerText: TTexts.orSignInWith.capitalize!),
          //
          SizedBox(height: TSizes.spaceBtwItems+3,),
          // Social buttons
          TSocialButtons(),
        ],
      ),
    );
  }
}


