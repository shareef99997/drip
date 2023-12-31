import 'dart:async';

import 'package:drip/common/widgets/success_screen/success_screen.dart';
import 'package:drip/data/repositories/authentication/authentication_repository.dart';
import 'package:drip/features/authentication/screens/login/login.dart';
import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/constants/text_strings.dart';
import 'package:drip/utils/popups/full_screen_loader.dart';
import 'package:drip/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  //Send Email when verification screen apears and set timer for auto redirect
  @override
  void onInit(){
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  /// Send Email
  sendEmailVerification()async{
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      TLoaders.successSnackBar(title: 'Email Sent',message: 'Please Check your inbox and verify your email.');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }

  /// Timer to redirect screen
  setTimerForAutoRedirect() async {
    Timer.periodic(const Duration(seconds: 1),
     (timer) async{
     await FirebaseAuth.instance.currentUser?.reload();
     final user = FirebaseAuth.instance.currentUser;
     if (user?.emailVerified ?? false) {
       timer.cancel();
       Get.off(
          () => SuccessScreen(
              image: TImages.staticSuccessIllustration,
              title: TTexts.yourAccountCreatedTitle,
              subTitle: TTexts.yourAccountCreatedSubTitle,
              onPressed: () =>AuthenticationRepository.instance.screenRedirect()),transition: Transition.fadeIn      
        );
      }}
    );
  }

  /// Manually Check if Email Verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser !=null && currentUser.emailVerified) {
      Get.off(
          () => SuccessScreen(
              image: TImages.staticSuccessIllustration,
              title: TTexts.yourAccountCreatedTitle,
              subTitle: TTexts.yourAccountCreatedSubTitle,
              onPressed: () =>AuthenticationRepository.instance.screenRedirect()),transition: Transition.fadeIn      
        );
    }else{
      TLoaders.warningSnackBar(
          title: 'You Must Verify Your Account to Continue',
          message: 'In order to create an account , you must verify your account to continue.' 
          );
          
    }
  }

}