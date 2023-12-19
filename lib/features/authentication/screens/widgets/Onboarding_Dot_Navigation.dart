import 'package:drip/features/authentication/controllers/onboarding_controller.dart';
import 'package:drip/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';



class OnBoardDotNavigation extends StatelessWidget {
  const OnBoardDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = OnBoardingController.Instance;
    return Positioned(
      bottom:TDeviceUtils.getBottomNavigationBarHeight()+25 ,
      left: TSizes.defaultSpace,
      
      child : SmoothPageIndicator(
        controller:controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect:ExpandingDotsEffect(activeDotColor: dark ?TColors.light:TColors.dark,dotHeight: 6),));
  }
}
