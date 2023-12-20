import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/constants/sizes.dart';
import 'package:drip/utils/constants/text_strings.dart';
import 'package:drip/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class Signup_Header extends StatelessWidget {
  const Signup_Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TTexts.signupTitle, style: Theme.of(context).textTheme.headlineSmall,),
        ],
      ),
    );
  }
}