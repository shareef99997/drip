import 'package:drip/data/repositories/users/user_repository.dart';
import 'package:drip/features/personalization/controllers/user_controller.dart';
import 'package:drip/features/personalization/screens/profile/profile.dart';
import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/helpers/network_manager.dart';
import 'package:drip/utils/popups/full_screen_loader.dart';
import 'package:drip/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePhoneController extends GetxController {
  static UpdatePhoneController get instance => Get.find();

    /// Variables
  GlobalKey<FormState> updatePhoneNumberFormKey = GlobalKey<FormState>();
   final phonenumber = TextEditingController();
   final usercontroller = UserController.instance;
   final userRepository = Get.put(UserRepository());
   
  @override
  void onInit() {
    initializNames();
      super.onInit();
    
  }

  Future<void> initializNames() async {
      phonenumber.text = usercontroller.user.value.phoneNumber;
    }
  
  Future<void>updatePhoneNumber() async{
    try {

      TFullScreenLoader.openLoadingDiolog('We are processing your information...', TImages.docerAnimation);
      
      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }  
      print('----------------- 1 --------------------');
      // Form Validation 
      if (!updatePhoneNumberFormKey.currentState!.validate()) {
          TFullScreenLoader.stopLoading();
          return;
      }
      print('----------------- 2 --------------------');
      // Update user's name
      Map<String, dynamic> phone = {'phoneNumber': phonenumber.text.trim()};
      await userRepository.updateSingleFeild(phone);
      print('----------------- 3 --------------------');
      //Update Rx User Value
      usercontroller.user.value.phoneNumber = phonenumber.text.trim();
 
      print('----------------- 4 --------------------');
      //Remove Loader
      TFullScreenLoader.stopLoading();
      
      // Show Success Message 
      TLoaders.successSnackBar(title: 'All Done👍', message: 'Your Phone Number has been updated.');

      Get.offAll(()=> const ProfileScreen(),transition: Transition.leftToRightWithFade);

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

}