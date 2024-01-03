import 'package:drip/data/repositories/authentication/authentication_repository.dart';
import 'package:drip/features/personalization/controllers/user_controller.dart';
import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/helpers/network_manager.dart';
import 'package:drip/utils/popups/full_screen_loader.dart';
import 'package:drip/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Variables
  final rememberMe = true.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController(text: ''); 
  final password = TextEditingController(text: '');
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  onInit(){
    email.text = localStorage.read('REMEMBER_ME_EMAIL')?? '';
    password.text = localStorage.read('REMEMBER_ME_PASSSWORD')?? '';
    super.onInit();
  }


  Future<void> emailAndPasswordSignIn() async {
    try {

      // Start Loading 
      TFullScreenLoader.openLoadingDiolog('Logging you in...', TImages.lockAnimation);
      
      
      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }  

      // Form Validation 
      if (!loginFormKey.currentState!.validate()) {
          TFullScreenLoader.stopLoading();
          return;
      }

      print('4');
      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSSWORD', password.text.trim());
      }

      // User Login
      final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());
      await UserController.instance.fetchUserRecord();
      TFullScreenLoader.stopLoading();
      
      AuthenticationRepository.instance.screenRedirect();

    } catch (e) {

      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print('----------------'+ e.toString());

    } 
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  /// --- Google SignIn 
  Future<void> googleSigIn() async {
   try {

      // Start Loading 
      TFullScreenLoader.openLoadingDiolog('Logging you in...', TImages.docerAnimation);
      
      
      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }  

      // User Login
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();
      

      // Save User Record
      await userController.saveUserRecord(userCredentials);
      
      // Remove Loader
      TFullScreenLoader.stopLoading();
      await UserController.instance.fetchUserRecord();
      AuthenticationRepository.instance.screenRedirect();

    } catch (e) {

      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print('----------------'+ e.toString());

    } 
  }
}