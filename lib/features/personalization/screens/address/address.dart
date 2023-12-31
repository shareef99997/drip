import 'package:drip/features/personalization/models/address_model.dart';
import 'package:drip/features/personalization/screens/address/widgets/single_address_widget.dart';
import 'package:drip/home_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/icons/t_circular_icon.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../shop/controllers/dummy_data.dart';
import '../../controllers/address_controller.dart';
import 'add_new_address.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;
    return Scaffold(
      appBar: TAppBar(
        leadingOnPressed: () => Get.offAll(()=> const HomeMenu(),transition: Transition.leftToRightWithFade),
        leadingIcon: Icons.arrow_back,
        title: Text('Addresses', style: Theme.of(context).textTheme.headlineSmall),
        actions: [TCircularIcon(icon: Iconsax.add, onPressed: () => Get.to(() => const AddNewAddressScreen(),transition: Transition.leftToRightWithFade))],
      ),
      body: FutureBuilder<List<AddressModel>>(
        future: controller.getAddresses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while fetching data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show an error message if fetching data fails
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show a message if no addresses are available
            return Center(child: Text('No addresses available.'));
          } else {
            // Display the addresses
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!
                      .map((address) => TSingleAddress(
                            address: address,
                            onTap: () => controller.selectedAddress.value = address,
                          ))
                      .toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
