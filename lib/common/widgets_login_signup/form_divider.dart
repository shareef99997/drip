import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/helpers/helper_functions.dart';

class Divider_Widget extends StatelessWidget {
  const Divider_Widget({
    super.key,
    
  });


  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Divider(color: dark ? TColors.darkGrey : TColors.grey,thickness: 1,indent: 40,endIndent: 5,),),
        Text(TTexts.orSignInWith),
        Flexible(child: Divider(color: dark ? TColors.darkGrey : TColors.grey,thickness: 1,indent: 5,endIndent: 40,),),
      ],
    );
  }
}