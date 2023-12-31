import 'package:drip/common/widgets/shimmers/shimmer.dart';
import 'package:drip/features/personalization/controllers/user_controller.dart';
import 'package:drip/features/personalization/screens/profile/change_password.dart';
import 'package:drip/features/personalization/screens/profile/change_phonenumber.dart';
import 'package:drip/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:drip/features/personalization/screens/setting/settings.dart';
import 'package:drip/home_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/t_circular_image.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import 'change_name.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: TAppBar(
        leadingOnPressed: () => Get.offAll(()=> const HomeMenu(),transition: Transition.leftToRightWithFade),
        leadingIcon: Icons.arrow_back,
        title: Text('Personal Profile', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx((){
                      final networkImage = controller.user.value.profilePicture;
                      final image = networkImage.isNotEmpty ? networkImage : TImages.user;
                      return controller.imageUploading.value ?
                        const TShimmerEffect(width: 80, height: 80,radius: 80,)
                        : TCircularImage(image: image, width: 100, height: 100,isNetworkImage: networkImage.isNotEmpty,padding: 5,);
                      },
                    ),
                    TextButton(onPressed: () => controller.uploadUserProfilePicture(), child: const Text('Change Profile Picture')),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              
              const TSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(onPressed: () => Get.to(() => const ChangeName(),transition: Transition.leftToRightWithFade), title: 'Name', value: controller.user.value.fullName),
              TProfileMenu(onPressed: () {}, title: 'Username', value: controller.user.value.username),
              TProfileMenu(onPressed: () => Get.to(() => const ChangePassword(),transition: Transition.leftToRightWithFade), title: 'Password', value: '*****************'),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(onPressed: () {_copyToClipboard(controller.user.value.id);}, title: 'User ID', value: controller.user.value.id, icon: Iconsax.copy),
              TProfileMenu(onPressed: () {}, title: 'E-mail', value: controller.user.value.email,icon: Icons.mail_outline,),
              TProfileMenu(onPressed: () => Get.to(() => const ChangePhoneNumber(),transition: Transition.leftToRightWithFade), title: 'Phone Number', value: controller.user.value.phoneNumber),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: TextButton(
                    onPressed: () => controller.deleteAccountWarningPopup(), child: const Text('Delete Account', style: TextStyle(color: Colors.red))),
              )
            ],
          ),
        ),
      ),
    );
  }
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    showToast("User ID copied to clipboard");
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

