import 'package:drip/utils/constants/colors.dart';
import 'package:drip/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TLoaders {
  static hideSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({required message}){
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: EdgeInsets.all(12.0),
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: THelperFunctions.isDarkMode(Get.context!)? TColors.darkGrey.withOpacity(0.9) : TColors.grey.withOpacity(0.9),
          ),
          child: Center(child: Text(message,style: Theme.of(Get.context!).textTheme.labelLarge),),
        ),
        )
    );
  }

  static void successSnackBar({required String title,message ='',duration = 3}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: TColors.primary,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: EdgeInsets.all(10),
      icon: Icon(Iconsax.check,color: TColors.white),
      );
  }
  static void warningSnackBar({required String title,message =''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(20),
      icon: Icon(Iconsax.warning_2,color: TColors.white),
      );
  }

  static errorSnackBar({required title,message =''}){
     Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      backgroundColor: Colors.red,
      colorText: TColors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(20),
      icon: Icon(Iconsax.warning_2,color: TColors.white),
      );
  }
    
}