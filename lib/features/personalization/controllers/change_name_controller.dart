import 'package:drip/data/repositories/users/user_repository.dart';
import 'package:drip/features/personalization/controllers/user_controller.dart';
import 'package:drip/features/personalization/screens/profile/profile.dart';
import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/helpers/network_manager.dart';
import 'package:drip/utils/popups/full_screen_loader.dart';
import 'package:drip/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

    /// Variables
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();
   final firstName = TextEditingController();
   final lastName = TextEditingController();
   final usercontroller = UserController.instance;
   final userRepository = Get.put(UserRepository());
   
  @override
  void onInit() {
    initializNames();
      super.onInit();
    
  }

  Future<void> initializNames() async {
      firstName.text = usercontroller.user.value.firstName;
      lastName.text = usercontroller.user.value.lastName;
    }
  
  Future<void>updateUserName() async{
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
      if (!updateUserNameFormKey.currentState!.validate()) {
          TFullScreenLoader.stopLoading();
          return;
      }
      print('----------------- 2 --------------------');
      // Update user's name
      Map<String, dynamic> name = {'firstName': firstName.text.trim(), 'lastName':lastName.text.trim()};
      await userRepository.updateSingleFeild(name);
      print('----------------- 3 --------------------');
      //Update Rx User Value
      usercontroller.user.value.firstName = firstName.text.trim();
      usercontroller.user.value.lastName = lastName.text.trim();
 
      print('----------------- 4 --------------------');
      //Remove Loader
      TFullScreenLoader.stopLoading();
      
      // Show Success Message 
      TLoaders.successSnackBar(title: 'All Done👍', message: 'Your Name has been updated.');

      Get.off(()=> const ProfileScreen());

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

}