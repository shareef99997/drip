
import 'package:drip/data/repositories/authentication/authentication_repository.dart';
import 'package:drip/data/repositories/users/user_repository.dart';
import 'package:drip/features/authentication/screens/signup/verify_email.dart';
import 'package:drip/features/personalization/models/user_model.dart';
import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/helpers/network_manager.dart';
import 'package:drip/utils/popups/full_screen_loader.dart';
import 'package:drip/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();


  /// -- SIGNUP
  Future<void> signup() async {
    try {
      // Start Loading 
      TFullScreenLoader.openLoadingDiolog('We are processing your information...', TImages.docerAnimation);

      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }  
      
      // Form Validation 
      if (!signupFormKey.currentState!.validate()) {
          TFullScreenLoader.stopLoading();
          return;
      }
        

      // privacyPolicy Validation
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'In order to create an account , you must read and accept The Privacy Policy & Terms of Use.' 
          );
          TFullScreenLoader.stopLoading();
          return;
      }
      // User Registeration
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());
      
      // Save New User In Database
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(), 
        username: username.text.trim(), 
        email: email.text.trim(), 
        phoneNumber: phoneNumber.text.trim(), 
        profilePicture:''
      );

      final userRepository = Get.put(UserRepository()); 
      await  userRepository.saveUserRecord(newUser);

      TFullScreenLoader.stopLoading();

      TLoaders.successSnackBar(title: 'Great!',message: 'Your account has been creeated! Verify email to continue.');

      Get.to(() => VerifyEmailScreen(email: email.text.trim()),transition: Transition.leftToRightWithFade);

    } catch (e) {
      TFullScreenLoader.stopLoading();

      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      
    } 
  }
  
}