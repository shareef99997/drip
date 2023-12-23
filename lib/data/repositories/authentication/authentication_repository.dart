
import 'dart:io';

import 'package:drip/features/authentication/screens/login/login.dart';
import 'package:drip/features/authentication/screens/onboarding/onboarding.dart';
import 'package:drip/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:drip/utils/exceptions/firebase_exceptions.dart';
import 'package:drip/utils/exceptions/format_exceptions.dart';
import 'package:drip/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  final deviceStorage = GetStorage(); 
  final _auth = FirebaseAuth.instance;

  /// Called from main.dart on app launch
  
  @override
  void onReady(){
    FlutterNativeSplash.remove();
    screenRedirect();
  }



  /// Function to Show Relevant Screen
  screenRedirect()async {
    //Local Storage
    deviceStorage.writeIfNull("IsFirstTime",true);
    deviceStorage.read('IsFirstTime') != true ? Get.offAll(() => LoginScreen()):Get.offAll(OnBoardingScreen());
  }

  /* --------------------------------- Email & Password sign-in ------------------------------------- */

  /// [EmailAuthentication] - SignIn
  
  
  /// [EmailAuthentication] - Register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password)async{
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
    } on FirebaseAuthException catch(e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw TFirebaseException(e.code).message;
    } on TFormatException catch(_) {
      throw TFormatException();
    } on PlatformException catch(e) {
      throw TPlatformException(e.code).message;
    }
     catch (e) {
      throw "Somthing Went Wrong Please Try Again";
    }
    
  }


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