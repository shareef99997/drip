import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class LoadingOrders extends StatelessWidget {
  const LoadingOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:EdgeInsets.only(top: MediaQuery.of(context).size.height /3-100 ),
        child: Center(
          child: Image(image: AssetImage(TImages.getorder), width: THelperFunctions.screenWidth() * 0.6),
          ));
  }
}
