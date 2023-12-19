import 'package:drip/features/authentication/controllers/onboarding_controller.dart';
import 'package:drip/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';


class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(top: TDeviceUtils.getAppBarHeight(),right: TSizes.defaultSpace, child: TextButton(onPressed: () =>OnBoardingController.Instance.skipPage(), child: Text(TTexts.skip),)
      
      
    );
  }
}

