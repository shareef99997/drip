import 'package:drip/data/repositories/users/user_repository.dart';
import 'package:drip/features/personalization/controllers/user_controller.dart';
import 'package:drip/features/personalization/screens/profile/profile.dart';
import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/helpers/network_manager.dart';
import 'package:drip/utils/popups/full_screen_loader.dart';
import 'package:drip/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  static UpdatePasswordController get instance => Get.find();

    /// Variables
  GlobalKey<FormState> updatePasswordFormKey = GlobalKey<FormState>();
   final email = TextEditingController();
   final usercontroller = UserController.instance;
   final userRepository = Get.put(UserRepository());
   
  @override
  void onInit() {
    initializNames();
      super.onInit();
    
  }

  Future<void> initializNames() async {
      email.text = usercontroller.user.value.email;
    }
  
  Future<void> updatePassword() async {
      try {
        TFullScreenLoader.openLoadingDiolog(
            'We are processing your information...', TImages.docerAnimation);

        // Check internet connection
        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          TFullScreenLoader.stopLoading();
          return;
        }

        // Form Validation
        if (!updatePasswordFormKey.currentState!.validate()) {
          TFullScreenLoader.stopLoading();
          return;
        }

        // Update user's password
        await userRepository.sendChangePasswordEmail(
          email.text.trim(),
        );

        // Remove Loader
        TFullScreenLoader.stopLoading();

        // Show Success Message
        TLoaders.successSnackBar(
          title: 'All Done👍',
          message: 'Password change email was sent to your email.',
        );

        Get.offAll(() => const ProfileScreen(),
            transition: Transition.leftToRightWithFade);

      } catch (e) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      }
    }

}