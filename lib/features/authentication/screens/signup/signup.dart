import 'package:drip/features/authentication/screens/signup/widgets/Signup_Footer.dart';
import 'package:drip/features/authentication/screens/signup/widgets/Signup_Form.dart';
import 'package:drip/features/authentication/screens/signup/widgets/Signup_Header.dart';
import 'package:flutter/material.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../utils/constants/sizes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:EdgeInsets.only(
            top: TSizes.appBarHeight,
            left: TSizes.defaultSpace,
            bottom: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
          ),
          /// MAIN TREE
          child: Column(
            children: [
              ///  Header
              Signup_Header(),
              ///  Form  
              Signup_Form(),
              /// Footer
              Signup_Footer(),
            ]
            ),
        ),
      ),
    );
  }

}