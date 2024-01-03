import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drip/common/widgets/success_screen/success_screen.dart';
import 'package:drip/features/personalization/models/address_model.dart';
import 'package:drip/features/shop/models/cart_item_model.dart';
import 'package:drip/features/shop/models/order_model.dart';
import 'package:drip/home_menu.dart';
import 'package:drip/utils/constants/enums.dart';
import 'package:drip/utils/helpers/network_manager.dart';
import 'package:drip/utils/popups/full_screen_loader.dart';
import 'package:drip/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../models/payment_method_model.dart';
import '../screens/checkout/widgets/payment_tile.dart';

class CheckoutController extends GetxController {
  static CheckoutController get instance => Get.find();

  Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  late DateTime checkoutDateTime;
  final String status = "Processing ";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userUid = FirebaseAuth.instance.currentUser?.uid; 
  

  @override
  Future<void> onInit() async {
    selectedPaymentMethod.value = PaymentMethodModel(name: 'Credit Card', image: TImages.creditCard);
      // Fetch cart items from Firestore and populate the cartItems collection
    cartItems.assignAll(await getCartItemsFromFirestore());
    super.onInit();
  }

  Future<void> clearCart() async {
    try {
      final DocumentReference cartDocRef = _firestore.collection('carts').doc(userUid);
      final CollectionReference cartItemsCollectionRef = cartDocRef.collection('items');

      // Delete all cart items
      await cartItemsCollectionRef.get().then((querySnapshot) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });

      // Clear the local cartItems state
      cartItems.clear();

      print('Cart items cleared after order placement.');
    } catch (e) {
      print('Error clearing cart items: $e');
      throw e;
    }
  }

  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(TSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TSectionHeading(title: 'Select Payment Method', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwSections),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Paypal', image: TImages.paypal)),
              const SizedBox(height: TSizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Google Pay', image: TImages.googlePay)),
              const SizedBox(height: TSizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Apple Pay', image: TImages.applePay)),
              const SizedBox(height: TSizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'VISA', image: TImages.visa)),
              const SizedBox(height: TSizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Master Card', image: TImages.masterCard)),
              const SizedBox(height: TSizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Paytm', image: TImages.paytm)),
              const SizedBox(height: TSizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Paystack', image: TImages.paystack)),
              const SizedBox(height: TSizes.spaceBtwItems/2),
              TPaymentTile(paymentMethod: PaymentMethodModel(name: 'Credit Card', image: TImages.creditCard)),
              const SizedBox(height: TSizes.spaceBtwItems/2),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<CartItemModel>> getCartItemsFromFirestore() async {
    List<CartItemModel> cartItems = [];

    try {
      final DocumentReference cartDocRef = _firestore.collection('carts').doc(userUid);
      final CollectionReference cartItemsCollectionRef = cartDocRef.collection('items');

      final QuerySnapshot querySnapshot = await cartItemsCollectionRef.get();

      // Process documents to populate cartItems
      cartItems = querySnapshot.docs.map((doc) {
        return CartItemModel(
          productId: doc['productId'],
          variationId: doc['variationId'],
          quantity: doc['quantity'],
          title: doc['title'],
          image: doc['image'],
          price: doc['price'],
          brandName: doc['brandName'],
          
        );
      }).toList();

      print('Cart items fetched from Firestore.');

    } catch (e) {
      print('Error fetching cart items from Firestore: $e');
    }

    return cartItems;
  }

  Future<void> saveOrderToFirestore(OrderModel order) async {
    try {
      final CollectionReference ordersCollectionRef = FirebaseFirestore.instance.collection('orders').doc(userUid).collection('userOrders');

      // Save order details to the main "orders" collection and generate a unique document ID
      final DocumentReference orderDocRef = await ordersCollectionRef.add({
        'status': order.status,
        'id': order.id,
        'orderDate': order.orderDate,
        'deliveryDate': order.deliveryDate,
        'totalAmount': order.totalAmount,
        'selectedAddress': order.selectedAddress,
        'selectedPaymentMethod': order.selectedPaymentMethod,
        'selectedPaymentImage': order.selectedPaymentImage,
      });

      // Save cart items to the "items" subcollection of the generated document ID
      CollectionReference itemsCollectionRef = orderDocRef.collection('items');

      for (CartItemModel cartItem in order.items) {
        await itemsCollectionRef.add({
          'productId': cartItem.productId,
          'variationId': cartItem.variationId,
          'quantity': cartItem.quantity,
          'title': cartItem.title,
          'image': cartItem.image,
          'price': cartItem.price,
          'brandName': cartItem.brandName,
        });
      }

      print('Order saved to Firestore.');
    } catch (e) {
      print('Error saving order to Firestore: $e');
      throw e;
    }
  }

  Future<void> checkout(
    
    double totalAmount,
    String address,
    String paymentMethod,
    String paymentImage,
  ) async {
    try {

      TFullScreenLoader.openLoadingDiolog('Setting up your order...', TImages.lockAnimation);

       // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected){
        TFullScreenLoader.stopLoading();
        return;
      }  

      checkoutDateTime = DateTime.now();
      // Calculate shipping time (7 days after checkout)
      DateTime shippingTime = checkoutDateTime.add(const Duration(days: 7));
      
      List<CartItemModel> cartItemsFromFirestore = await getCartItemsFromFirestore();

      // Generate a random 5-digit order number starting with "drip"
      String id = 'dr${Random().nextInt(90000) + 10000}';

      // Create an order object with the necessary details
      OrderModel order = OrderModel(
        status: status,
        id: id,
        items: cartItemsFromFirestore,
        orderDate: checkoutDateTime,
        deliveryDate: shippingTime,
        totalAmount: totalAmount, 
        selectedAddress: address,
        selectedPaymentMethod: paymentMethod,
        selectedPaymentImage: paymentImage
      );

      // Save the order to Firestore
      await saveOrderToFirestore(order);

      await clearCart();

      // Show success message or navigate to the order confirmation screen
      
      TFullScreenLoader.stopLoading();
      // Navigate to the order confirmation screen or any other screen
      Get.offAll(
              () => SuccessScreen(
                image: TImages.successfulPaymentIcon,
                title: 'Payment Success!',
                subTitle: 'Your items will be shipped soon!',
                onPressed: () => Get.off(() => const HomeMenu(),transition: Transition.leftToRightWithFade),
              ),transition: Transition.leftToRightWithFade
            );
      TLoaders.successSnackBar(title: 'Order Placed', message: 'Your order has been placed successfully.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      // Handle error
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

}
