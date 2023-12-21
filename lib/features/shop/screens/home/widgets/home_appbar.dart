import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../personalization/screens/profile/profile.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });
  // Home Appbar
  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: GestureDetector(
        onTap: () => Get.to(() => const ProfileScreen()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(TTexts.homeAppbarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: TColors.grey)),
            Text(TTexts.homeAppbarSubTitle, style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white)),
          ],
        ),
      ),
      // To Know
      actions: const [TCartCounterIcon(iconColor: TColors.white, counterBgColor: TColors.black, counterTextColor: TColors.white)],
    );
  }
}
