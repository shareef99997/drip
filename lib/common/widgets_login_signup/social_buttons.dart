import 'package:flutter/material.dart';

import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';

class Social_Buttons extends StatelessWidget {
  const Social_Buttons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //google
        Container(
          decoration: BoxDecoration(border: Border.all(color:Color.fromARGB(120, 129, 129, 129)), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: (){
              //todo
            },
            icon: Image(
              width: TSizes.iconLg+8,
              height: TSizes.iconLg+8,
              image: AssetImage(TImages.google),
            ),
          ),
        ),
        SizedBox(width: TSizes.spaceBtwItems,),
        //facebook
        Container(
          decoration: BoxDecoration(border: Border.all(color:Color.fromARGB(120, 129, 129, 129)), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: (){
              //todo
            },
            icon: Image(
              width: TSizes.iconLg+8,
              height: TSizes.iconLg+8,
              image: AssetImage(TImages.facebook),
            ),
          ),
        ),
        
      ],
    );
  }
}
