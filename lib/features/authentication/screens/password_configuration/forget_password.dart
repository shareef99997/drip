// import 'package:cwt_ecommerce_ui_kit/features/authentication/screens/password_configuration/reset_password.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../../../common/widgets/appbar/appbar.dart';
// import '../../../../utils/constants/sizes.dart';
// import '../../../../utils/constants/text_strings.dart';

// class ForgetPassword extends StatelessWidget {
//   const ForgetPassword({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       /// Custom Appbar
//       appBar: TAppBar(actions: [IconButton(onPressed: () => Get.back(), icon: const Icon(CupertinoIcons.clear))]),
//       body: Padding(
//         padding: const EdgeInsets.all(TSizes.defaultSpace),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Headings
//             Text(TTexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium),
//             const SizedBox(height: TSizes.spaceBtwItems),
//             Text(TTexts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium),
//             const SizedBox(height: TSizes.spaceBtwSections * 2),

//             /// Text field
//             const TextField(
//               decoration: InputDecoration(labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct_right)),
//             ),
//             const SizedBox(height: TSizes.spaceBtwSections),

//             /// Submit Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => Get.to(() => const ResetPassword()),
//                 child: const Text(TTexts.submit),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
