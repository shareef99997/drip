import 'package:drip/data/repositories/authentication/authentication_repository.dart';
import 'package:drip/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/helpers/network_manager.dart';
import 'package:drip/utils/popups/full_screen_loader.dart';
import 'package:drip/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> ForgetPasswordFormkey = GlobalKey<FormState>();
  

  /// Send Reset Request
  sendPasswordResetEmail() async {
    try {
      // Start Loading 
      TFullScreenLoader.openLoadingDiolog('Logging you in...', TImages.docerAnimation);
      
      
      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }  

      // Form Validation 
      if (!ForgetPasswordFormkey.currentState!.validate()) {
          TFullScreenLoader.stopLoading();
          return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      TFullScreenLoader.stopLoading();
      

      TLoaders.successSnackBar(title: 'Email Sent 📧', message: 'Email Link Sent to reset your password'.tr);

      Get.to(() => ResetPassword(email: email.text.trim()),transition: Transition.fadeIn);

    } catch (e) {
      //Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
      
  }

  resendPasswordResetEmail() async {
     try {
      // Start Loading 
      TFullScreenLoader.openLoadingDiolog('Logging you in...', TImages.docerAnimation);
      
      
      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }  

      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      TFullScreenLoader.stopLoading();
      

      TLoaders.successSnackBar(title: 'Email Sent 📧', message: 'Email Link Sent to reset your password'.tr);

    } catch (e) {
      //Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  } 

  
}