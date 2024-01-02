import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../styles/spacing_styles.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    Key? key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.onPressed,
  }) : super(key: key);

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: TSpacingStyle.paddingWithAppBarHeight * 2,
                child: Column(
                  children: [
                    /// Image
                    Image(image: AssetImage(image), width: THelperFunctions.screenWidth() * 0.6),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    /// Title & SubTitle
                    Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Text(subTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              ),
            ),
          ),
          /// Button at the bottom
          SizedBox(
            width: THelperFunctions.screenWidth()-1,
            child: ElevatedButton(
              onPressed: onPressed,
              child: const Text(TTexts.tContinue),
            ),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}
