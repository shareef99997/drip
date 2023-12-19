import 'package:drip/features/authentication/controllers/onboarding_controller.dart';
import 'package:drip/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';



class Onboarding_button extends StatelessWidget {
     Onboarding_button({
    super.key,
  });



  @override
  Widget build(BuildContext context) {  
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      bottom:TDeviceUtils.getBottomNavigationBarHeight()+10 ,
      right: TSizes.defaultSpace,
      child: ElevatedButton(
        onPressed: () => OnBoardingController.Instance.nextPage(),
        child: Icon(Icons.arrow_forward_ios_sharp,color: dark ?TColors.dark:TColors.light),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
        ),
      )
    );
  }
}




