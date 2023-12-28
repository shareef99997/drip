// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drip/data/repositories/authentication/authentication_repository.dart';
import 'package:drip/data/repositories/users/user_repository.dart';
import 'package:drip/features/authentication/screens/login/login.dart';
import 'package:drip/features/personalization/models/user_model.dart';
import 'package:drip/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/constants/sizes.dart';
import 'package:drip/utils/helpers/network_manager.dart';
import 'package:drip/utils/popups/full_screen_loader.dart';
import 'package:drip/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController{
  static UserController get instance => Get.find();
  
  ///Variables
  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final hidePassword =false.obs;
  final imageUploading = false.obs;
  final verifyEmail =TextEditingController();
  final verifyPassword =TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit(){
    super.onInit();
    fetchUserRecord();
  }

  /// Fetch User Record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    }finally{
      profileLoading.value = false;
    }
  }

  /// Save user Record from Provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {

      await fetchUserRecord();

      if (user.value.id.isEmpty) {
        if(userCredentials != null){
        
          // Convert Name to First and Last Name
          final nameParts = UserModel.nameParts(userCredentials.user!.displayName?? '');
          final username = UserModel.generateUsername(userCredentials.user!.displayName?? '');
        
          // Map Data
          final user = UserModel(
              id: userCredentials.user!.uid,
              firstName: nameParts[0],
              lastName: nameParts.length > 1 ? nameParts.sublist(1).join(''):'',
              username: username,
              email: userCredentials.user!.email??'',
              phoneNumber: userCredentials.user!.phoneNumber ?? '',
              profilePicture: userCredentials.user!.photoURL ?? '');
        
          await userRepository.saveUserRecord(user);
        }
      }

    } catch (e) {
      TLoaders.warningSnackBar(title: 'Data not saved',
      message: 'Somthing went wrong while saving your information. You can re-save your data in your Profile.');
    
    }
  }
  
  ///Popup
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md), 
      title: "Delete Account",
      middleText: 'Are you sure you want to delete your account permanently? this action is not reversible and all of your data will be removed permanently.',
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red,side: const BorderSide(color: Colors.red)), 
        child: const Padding(padding: EdgeInsets.symmetric(horizontal: TSizes.lg), child: Text('Delete')),
        ),
      cancel: OutlinedButton(
          child: const Text('Cancel'),
          onPressed:()=> Navigator.of(Get.overlayContext!).pop(),
          )
    );
  }

  void deleteUserAccount() async {
    try {
      TFullScreenLoader.openLoadingDiolog('Processing', TImages.docerAnimation);

      final auth = AuthenticationRepository.instance;
      final provider = auth.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {

        if (provider =='google.com') {
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if(provider == 'password') {
          TFullScreenLoader.stopLoading();
           Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      TFullScreenLoader.openLoadingDiolog('Processing', TImages.docerAnimation);

      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }  
      
      // Form Validation 
      if (!reAuthFormKey.currentState!.validate()) {
          TFullScreenLoader.stopLoading();
          return;
      }

      await AuthenticationRepository.instance.reAuthenticateEmailAndPassword(verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();

      TFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
  
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(source:ImageSource.gallery, imageQuality: 70 , maxHeight: 512, maxWidth: 512);
      if (image != null) {
        imageUploading.value = true;
        final imageUrl = await userRepository.uploadImage('Users/Images/Profile', image);

        // Update user image Record
        Map<String, dynamic> json = {'profilePicture':imageUrl};
        await userRepository.updateSingleFeild(json);

        user.value.profilePicture = imageUrl;
        user.refresh();

        TLoaders.successSnackBar(title: 'All Done👍', message: 'Your Profile Image has been updated.');
        }
    }  catch (e) {
        TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }finally{
      imageUploading.value = false;
    }
    
  }
}