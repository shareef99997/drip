
import 'package:drip/features/authentication/screens/login/login.dart';
import 'package:drip/features/authentication/screens/onboarding/onboarding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  final deviceStorage = GetStorage(); 

  /// Called from main.dart on app launch
  
  @override
  void onReady(){
    FlutterNativeSplash.remove();
    screenRedirect();
  }



  /// Function to Show Relevant Screen
  screenRedirect()async {
    //Local Storage
    if (kDebugMode) {
      print("================== GET STORAGE Auth Repo ===================");
      print(deviceStorage.read("IsFirstTime"));
    }
    deviceStorage.writeIfNull("IsFirstTime",true);
    deviceStorage.read('IsFirstTime') != true ? Get.offAll(() => LoginScreen()):Get.offAll(OnBoardingScreen());
  }

  /* --------------------------------- Email & Password sign-in ------------------------------------- */

  /// [EmailAuthentication] - SignIn
  /// [EmailAuthentication] - Register
  /// [ReAuthentication] - ReAuthenticate User
  /// [EmailVerification] - Mail VERIFICATION
  /// [EmailAuthentication] - Forget Password
  /* --------------------------------- Social Sign-in------------------------------------- */

  /// [GoogleAuthentication] - Google
  
  /// [FacebookAuthentication] - Facebook
  
  /* --------------------------------- ./end Federated identity and social sign-in ------------------------------------- */

  /// [Logout User] - Valid for any authintication
  
  // [DELETE USER] - Remove user Auth and Firestore Account.

  



}