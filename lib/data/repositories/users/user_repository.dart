

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drip/data/repositories/authentication/authentication_repository.dart';
import 'package:drip/features/personalization/models/user_model.dart';
import 'package:drip/utils/exceptions/firebase_exceptions.dart';
import 'package:drip/utils/exceptions/format_exceptions.dart';
import 'package:drip/utils/exceptions/platform_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  
  final FirebaseFirestore _db = FirebaseFirestore.instance;
 

  /// Function to save user data to Firestore.
  Future<void> saveUserRecord (UserModel user) async {
    try {
      print(user.toJson());
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException (e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Fetch User Details
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException (e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
  
  /// Update User Details
  Future<void> updateUserDetails(UserModel updateUser) async {
    try {
      await _db.collection("Users").doc(updateUser.id).update(updateUser.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException (e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
  
  /// Update One Deild
  Future<void> updateSingleFeild(Map<String,dynamic> json) async {
    try {
      await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException (e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
  
  /// REMOVE USER Record
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException (e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Upload Image
  Future<void> uploadImage(String userId) async {
    try {
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException (e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  
}