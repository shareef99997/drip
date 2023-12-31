
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drip/features/personalization/screens/address/address.dart';
import 'package:drip/utils/constants/image_strings.dart';
import 'package:drip/utils/helpers/network_manager.dart';
import 'package:drip/utils/popups/full_screen_loader.dart';
import 'package:drip/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/sizes.dart';
import '../../shop/controllers/dummy_data.dart';
import '../models/address_model.dart';
import '../screens/address/add_new_address.dart';
import '../screens/address/widgets/single_address_widget.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;

  String? userUid = FirebaseAuth.instance.currentUser?.uid;

  final CollectionReference _addressesCollection = FirebaseFirestore.instance.collection('addresses');
  
   GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

   final name = TextEditingController();
   final phonenumber = TextEditingController();
   final street = TextEditingController();
   final city = TextEditingController();
   final state = TextEditingController();
   final postalcode = TextEditingController();
   final country = TextEditingController();
   
  // Add init to initialize some address by default.
  @override
  void onInit() {
    _initializeDefaultAddress();
    super.onInit();
  }
  
  Future<void> _initializeDefaultAddress() async {
    try {
      final addresses = await getAddresses();
      if (addresses.isNotEmpty) {
        selectedAddress.value = addresses[0];
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Save new address to Firestore
  Future<void> saveAddress(AddressModel address) async {
    try {
      final addresses = await getAddresses();
      final id = (addresses.length + 1).toString(); // Calculate the next sequential number

      address = address.copyWith(id: id); // Update the address with the calculated id

      await _addressesCollection.doc(userUid).collection('user_addresses').add(address.toMap());
    } catch (e) {
      // Handle error
    }
  }

  Future<void> presaveAddress() async {
    try {

      TFullScreenLoader.openLoadingDiolog('We are processing your information...', TImages.docerAnimation);
      
      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }  
      print('----------------- 1 --------------------');
      // Form Validation 
      if (!addressFormKey.currentState!.validate()) {
          TFullScreenLoader.stopLoading();
          return;
      }
      print('----------------- 2 --------------------');
      // Update user's name
      final newAddress = AddressModel(
      id: '',
      phoneNumber: phonenumber.text.trim(),
      name: name.text.trim(),
      street: street.text.trim(),
      city: city.text.trim(),
      state: state.text.trim(),
      postalCode: postalcode.text.trim(),
      country: country.text.trim(),
      );
      await saveAddress(newAddress);
 
      print('----------------- 4 --------------------');
      //Remove Loader
      TFullScreenLoader.stopLoading();
      
      // Show Success Message 
      TLoaders.successSnackBar(title: 'All Done👍', message: 'Your Address has been Saved.');

      Get.offAll(()=> const UserAddressScreen(),transition: Transition.leftToRightWithFade);

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }


  }

  // Fetch addresses from Firestore
  Future<List<AddressModel>> getAddresses() async {
    try {
    final querySnapshot = await _addressesCollection.doc(userUid).collection('user_addresses').get();

    if (querySnapshot.docs.isNotEmpty) {
      final addresses = querySnapshot.docs
          .map((doc) => AddressModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return addresses;
    }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }

    return [];
  }

  Future<void> selectNewAddress(BuildContext context) async {
    try {
      final addresses = await getAddresses();

      // ignore: use_build_context_synchronously
      showModalBottomSheet(
        context: context,
        builder: (_) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(TSizes.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TSectionHeading(title: 'Select Address', showActionButton: false),
                Column(
                  children: addresses
                      .map((address) => TSingleAddress(
                            address: address,
                            onTap: () {
                              selectedAddress.value = address;
                              Get.back();
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: TSizes.defaultSpace * 2),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const AddNewAddressScreen(), transition: Transition.leftToRightWithFade),
                    child: const Text('Add new address'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
 
  // Delete an address from Firestore
  Future<void> deleteAddress(AddressModel address) async {
    try {
      // Query for the document with the specified ID
      final QuerySnapshot querySnapshot = await _addressesCollection
        .doc(userUid)
        .collection('user_addresses')
        .where("id", isEqualTo: address.id)
        .get();

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      // Delete each matching document
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
      }
      }

      // Optionally, update the selectedAddress if it was the one being deleted
      if (selectedAddress.value.id == address.id) {
        selectedAddress.value = AddressModel.empty();
      }
      
      // Show success message or perform any other actions after successful deletion
      TLoaders.successSnackBar(title: 'All Done', message: 'Address deleted successfully');

      // Navigate to a new screen after deletion
      Get.offAll(() => const UserAddressScreen(), transition: Transition.leftToRightWithFade);
    } catch (e) {
      // Handle error
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
