// ignore_for_file: prefer_const_constructors

import 'package:drip/features/authentication/controllers/onboarding_controller.dart';
import 'package:drip/features/authentication/screens/widgets/Onboarding_Dot_Navigation.dart';
import 'package:drip/features/authentication/screens/widgets/onboarding_Circular_Button.dart';
import 'package:drip/features/authentication/screens/widgets/onboarding_page.dart';
import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'widgets/onboarding_skip.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        children: [
          //Horizontal Scrollable Page
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(image: TImages.onBoardingImage1, title: TTexts.onBoardingTitle1, subTitle:TTexts.onBoardingSubTitle1,),
              OnBoardingPage(image: TImages.onBoardingImage2, title: TTexts.onBoardingTitle2, subTitle:TTexts.onBoardingSubTitle2,),
              OnBoardingPage(image: TImages.onBoardingImage3, title: TTexts.onBoardingTitle3, subTitle:TTexts.onBoardingSubTitle3,),
            ],
          ),
          
          ///Skip Button
          OnBoardingSkip(),
          
          ///Dot Navigation SmoothPageIndicator 
          OnBoardDotNavigation(),
           
          ///Circular Button
          Onboarding_button()

        ],
      ),
    );
  }
}

