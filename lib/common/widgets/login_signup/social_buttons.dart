import 'package:drip/features/authentication/controllers/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: Color.fromARGB(172, 224, 224, 224)), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () => controller.googleSigIn(),
            icon: const Image(
              width: TSizes.iconMd+10,
              height: TSizes.iconMd+10,
              image: AssetImage(TImages.google),
            ),
          ),
        ),
      ],
    );
  }
}
