import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets_login_signup/form_divider.dart';
import '../../../../../common/widgets_login_signup/social_buttons.dart';
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
          Divider_Widget(),
          //
          SizedBox(height: TSizes.spaceBtwItems+3,),
          // Social buttons
          Social_Buttons(),
        ],
      ),
    );
  }
}


