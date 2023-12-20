import 'package:drip/common/styles/spacing_styles.dart';
import 'package:drip/features/authentication/screens/login/widgets/Login_Footer.dart';
import 'package:drip/features/authentication/screens/login/widgets/Login_Form.dart';
import 'package:drip/features/authentication/screens/login/widgets/Login_Header.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:TSpacingStyle.paddingWithAppbarHeight,

          /// MAIN TREE
          child: Column(
            children: [
              ///  Logo , Title & Sub-Title
              Header(),
              ///  Form  
              FForm(),
              /// Footer
              Footer(),
            ]
            ),
        ),
      ),
    );
  }
}


