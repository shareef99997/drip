import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/constants/sizes.dart';
import 'package:drip/utils/constants/text_strings.dart';
import 'package:drip/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            height: 150,
            image: AssetImage(dark? TImages.lightAppLogo : TImages.darkAppLogo),
          ),
          Text(TTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium,),
          SizedBox(height: TSizes.sm),
          Text(TTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium,),
        ],
      ),
    );
  }
}