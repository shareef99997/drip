
import 'package:drip/common/widgets/loaders/animation_loader.dart';
import 'package:drip/utils/constants/colors.dart';
import 'package:drip/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
/// Full Screen loading dialog
class TFullScreenLoader {
  
  static void openLoadingDiolog(String text, String animation){
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: THelperFunctions.isDarkMode(Get.context!)? TColors.dark : TColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 100),
              TAnimationLoaderWidget(text:text, animation:animation),
            ],
          ),
        )
        )
     );
  }


  /// Stop Loading Dialog
  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }
}