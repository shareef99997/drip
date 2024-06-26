
import 'package:drip/data/repositories/users/user_repository.dart';
import 'package:drip/features/authentication/screens/login/login.dart';
import 'package:drip/features/authentication/screens/onboarding/onboarding.dart';
import 'package:drip/features/authentication/screens/signup/verify_email.dart';
import 'package:drip/home_menu.dart';
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
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  /// Variables
  final deviceStorage = GetStorage(); 
  final _auth = FirebaseAuth.instance;

  /// Get Authenticated User Data
  User? get authUser => _auth.currentUser;

  /// Called from main.dart on app launch
  @override
  void onReady(){
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  /// Function to Show Relevant Screen
  screenRedirect()async {
    final user = _auth.currentUser;

    if (user != null) {
      // if user logged in
      if(user.emailVerified){
        //if user verified
        Get.offAll(() => const HomeMenu(),transition: Transition.leftToRightWithFade);
      }else{
        //if user not verified
        Get.offAll(() => VerifyEmailScreen(email:_auth.currentUser?.email),transition: Transition.leftToRightWithFade);
      }
    }else {
    //Local Storage
    deviceStorage.writeIfNull("IsFirstTime",true);
    deviceStorage.read('IsFirstTime') != true ? Get.offAll(() => LoginScreen(),transition: Transition.leftToRightWithFade):Get.offAll(OnBoardingScreen(),transition: Transition.leftToRightWithFade);
    }
  }
    


  /* --------------------------------- Email & Password sign-in ------------------------------------- */

  /// [EmailAuthentication] - Login
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
      
    } on FirebaseAuthException catch(e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw const TFormatException();
    } on PlatformException catch(e) {
      throw TPlatformException(e.code).message;
    }
     catch (e) {
      throw "Somthing Went Wrong Please Try Again";
    }
  }

  /// [EmailAuthentication] - Register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password)async{
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
    } on FirebaseAuthException catch(e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw const TFormatException();
    } on PlatformException catch(e) {
      throw TPlatformException(e.code).message;
    }
     catch (e) {
      throw "Somthing Went Wrong Please Try Again";
    }
    
  }

  /// [EmailVerification] - Mail VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch(e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw const TFormatException();
    } on PlatformException catch(e) {
      throw TPlatformException(e.code).message;
    }
     catch (e) {
      throw "Somthing Went Wrong Please Try Again";
    }
  }
  
  /// [EmailAuthentication] - Forget Password
    Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch(e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw const TFormatException();
    } on PlatformException catch(e) {
      throw TPlatformException(e.code).message;
    }
     catch (e) {
      throw "Somthing Went Wrong Please Try Again";
    }
  } 

   
  /// [ReAuthentication] - ReAuthenticate User
    Future<void> reAuthenticateEmailAndPassword(String email, String password) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch(e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw const TFormatException();
    } on PlatformException catch(e) {
      throw TPlatformException(e.code).message;
    }
     catch (e) {
      throw "Somthing Went Wrong Please Try Again";
    }
  } 
  
  
  
  /* --------------------------------- Social Sign-in------------------------------------- */

  /// [GoogleAuthentication] - Google
  Future<UserCredential?> signInWithGoogle()async{
    try {
      
      // trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      //Obtain the auth details 
      final GoogleSignInAuthentication? googleAuth = await userAccount?.authentication;
      
      //create new cardential
      final credentials = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      // Once signd in return Usercredentials
      return await _auth.signInWithCredential(credentials);

    } on FirebaseAuthException catch(e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw const TFormatException();
    } on PlatformException catch(e) {
      throw TPlatformException(e.code).message;
    }
     catch (e) {
      if (kDebugMode) print('Somthing went wrong: $e') ;
      return null;
    }
    
  }

  /// [FacebookAuthentication] - Facebook
  
  /* --------------------------------- ./end Federated identity and social sign-in ------------------------------------- */

  /// [Logout User] - Valid for any authintication
  Future<void> logout()async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch(e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw const TFormatException();
    } on PlatformException catch(e) {
      throw TPlatformException(e.code).message;
    }
     catch (e) {
      throw "Somthing Went Wrong Please Try Again";
    }
  }

  // [DELETE USER] - Remove user Auth and Firestore Account.
  Future<void> deleteAccount()async{
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch(e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw const TFormatException();
    } on PlatformException catch(e) {
      throw TPlatformException(e.code).message;
    }
     catch (e) {
      throw "Somthing Went Wrong Please Try Again";
    }
  }
  



}