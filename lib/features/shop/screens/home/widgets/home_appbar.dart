import 'package:drip/features/personalization/controllers/user_controller.dart';
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
   // Method to toggle between light and dark themes
  void toggleTheme() {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  // Home Appbar
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return TAppBar(
      title: GestureDetector(
        onTap: () => Get.to(() => const ProfileScreen(),transition: Transition.leftToRightWithFade),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(TTexts.homeAppbarTitle, style: Theme.of(context).textTheme.labelMedium!.apply(color: TColors.grey)),
            Obx((){
              if (controller.profileLoading.value) {
                return Text('', style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white));
              }else{
                return Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.white));
              }
              }),
          ],
        ),
      ),
      // Cart Icon
      actions: [
        Builder(
          builder: (BuildContext buttonContext) {
            return Container(
              child: ElevatedButton(
                onPressed: () => toggleTheme(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.isDarkMode ? Colors.grey[800] : Color.fromARGB(255, 255, 255, 255), // Adjust colors based on your design
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Row(
                    children: [
                      Icon(
                        Get.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                        size: 20,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        Get.isDarkMode ? 'Light' : 'Dark',
                        style: TextStyle(fontSize: 15,color: Get.isDarkMode ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const TCartCounterIcon(iconColor: TColors.white, counterBgColor: TColors.black, counterTextColor: TColors.white),
      
      ],
    );
  }
}
