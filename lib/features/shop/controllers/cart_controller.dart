import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../models/product_variation_model.dart';
import 'dummy_data.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  
  RxDouble totalCartPrice = 0.0.obs;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final String _cartCollection = 'carts';
  // Add the user's UID if you want to associate the cart with a user
  String? userUid = FirebaseAuth.instance.currentUser?.uid;

  // RxMap<String, int> productQuantities = <String, int>{}.obs; // Use to count each product quantity [ID: quantity]

  /// -- Used init to initialize dummy data only
  @override
  void onInit() {
        // Check if the user is signed in before accessing the UID
        if (FirebaseAuth.instance.currentUser != null) {
          userUid = FirebaseAuth.instance.currentUser!.uid;

          // Fetch cart items from Firestore
          fetchCartItemsFromFirestore();
        }
        
    super.onInit();
  }

  Future<List<CartItemModel>> getCartItemsFromFirestore() async {
    List<CartItemModel> cartItems = [];

    try {
      final DocumentReference cartDocRef = _firestore.collection(_cartCollection).doc(userUid);
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
          // Add other fields as needed...
        );
      }).toList();

      print('Cart items fetched from Firestore.');

    } catch (e) {
      print('Error fetching cart items from Firestore: $e');
    }

    return cartItems;
  }


 /// Fetch cart items from Firestore
  Future<void> fetchCartItemsFromFirestore() async {
  try {
    final DocumentReference cartDocRef = _firestore.collection(_cartCollection).doc(userUid);
    final CollectionReference cartItemsCollectionRef = cartDocRef.collection('items');

    final QuerySnapshot querySnapshot = await cartItemsCollectionRef.get();

    

    // Process documents to populate cartItems
    querySnapshot.docs.forEach((doc) {
      final cartItem = CartItemModel(
        productId: doc['productId'],
        variationId: doc['variationId'],
        quantity: doc['quantity'],
        title: doc['title'],
        image: doc['image'],
        price: doc['price'],
        brandName: doc['brandName'],
        // Add other fields as needed...
      );

      // Check if the item already exists in the local list
      final existingIndex = cartItems.indexWhere(
        (item) => item.productId == cartItem.productId && item.variationId == cartItem.variationId,
      );

      if (existingIndex != -1) {
        // Update the existing item
        cartItems[existingIndex] = cartItem;
      } else {
        // Add the new item
        cartItems.add(cartItem);
      }
    });

    // Calculate total cart price
    totalCartPrice.value = cartItems
        .map((e) => calculateSingleProductTotal(e.price!, e.quantity))
        .fold(0, (previous, current) => previous + current);

    print('Cart items fetched from Firestore.');
  } catch (e) {
    print('Error fetching cart items from Firestore: $e');
  }
}


  // Add the cart items to Firestore
  void addSingleItemToCart(ProductModel product, ProductVariationModel variation) async {
    // If the product is already added then increment the count else add new product
    final cartItem = cartItems.firstWhere(
      (item) => item.productId == product.id && item.variationId == variation.id,
      orElse: () => CartItemModel(
        productId: product.id,
        variationId: variation.id,
        quantity: 0,
        title: product.title,
        image: product.thumbnail,
        price: product.salePrice ?? product.price,
        brandName: product.brand!.name,
      ),
    );

    // Increment Cart
    cartItem.quantity += 1;

    // If it's a new product, add it to the cart.
    if (cartItem.quantity == 1) {
      cartItems.add(cartItem);
    }

    // Increment Total Cart Price
    totalCartPrice.value += calculateSingleProductTotal(product.price, 1);

    // Must use .refresh() when the list or Modal is Observable to change UI
    cartItems.refresh();

    // Add the cart item to Firestore
    await _addToFirestore(cartItem);
  }

  Future<void> _addToFirestore(CartItemModel cartItem) async {
    try {
      final DocumentReference cartDocRef = _firestore.collection(_cartCollection).doc(userUid);
      final CollectionReference cartItemsCollectionRef = cartDocRef.collection('items');

      // Check if the item already exists in Firestore
      final QuerySnapshot existingItems = await cartItemsCollectionRef
          .where('productId', isEqualTo: cartItem.productId)
          .where('variationId', isEqualTo: cartItem.variationId)
          .get();

      if (existingItems.docs.isNotEmpty) {
        // Update the quantity of the existing item
        final DocumentSnapshot existingItem = existingItems.docs.first;
        await existingItem.reference.update({
          'quantity': cartItem.quantity,
        });
      } else {
        // Use a unique identifier for each cart item
        final DocumentReference cartItemDocRef = cartItemsCollectionRef.doc();

        await cartItemDocRef.set({
          'productId': cartItem.productId,
          'variationId': cartItem.variationId,
          'quantity': cartItem.quantity,
          'title': cartItem.title,
          'image': cartItem.image,
          'price': cartItem.price?.toDouble(),
          'brandName': cartItem.brandName,
          // Add other fields as needed...
        });
      }

      print('Cart item added to Firestore.');
    } catch (e) {
      print('Error adding cart item to Firestore: $e');
    }
  }



   // Add multiple items to Firestore
  void addMultipleItemsToCart(ProductModel product, ProductVariationModel variation, int quantity) {
    // If the product is already added then increment the count else add new product
    final cartItem = cartItems.firstWhere(
      (item) => item.productId == product.id && item.variationId == variation.id,
      orElse: () => CartItemModel(
        productId: product.id,
        variationId: variation.id,
        quantity: 0,
        title: product.title,
        image: variation.id.isEmpty ? product.thumbnail : variation.image,
        price: variation.id.isEmpty ? product.salePrice ?? product.price : variation.salePrice ?? variation.price,
        brandName: product.brand!.name,
        selectedVariation: variation.id.isNotEmpty ? variation.attributeValues : null,
      ),
    );

    // If it's a new product, add it to Firestore
    if (cartItem.quantity == 0) {
      cartItem.quantity = quantity;
      cartItems.add(cartItem);
      totalCartPrice.value += calculateSingleProductTotal(product.price, quantity);
      _addMultipleItemsToFirestore(product, variation, quantity);
    } else {
      // Check if you need to remove or add items to the cart
      if (cartItem.quantity > quantity) {
        totalCartPrice.value -= calculateSingleProductTotal(cartItem.price!, quantity);
      } else {
        totalCartPrice.value += calculateSingleProductTotal(product.price, quantity);
      }

      cartItem.quantity = quantity;
      _addMultipleItemsToFirestore(product, variation, quantity);
    }

    cartItems.refresh();
  }

  Future<void> _addMultipleItemsToFirestore(ProductModel product, ProductVariationModel variation, int quantity) async {
    try {
      final DocumentReference cartDocRef = _firestore.collection(_cartCollection).doc(userUid);
      final CollectionReference cartItemsCollectionRef = cartDocRef.collection('items');

      // Use a unique identifier for each cart item
      final DocumentReference cartItemDocRef = cartItemsCollectionRef.doc();

      await cartItemDocRef.set({
        'productId': product.id,
        'variationId': variation.id,
        'quantity': quantity,
        'title': product.title,
        'image': variation.id.isEmpty ? product.thumbnail : variation.image,
        'price': variation.id.isEmpty ? product.salePrice ?? product.price : variation.salePrice ?? variation.price,
        'brandName': product.brand!.name,
        // Add other fields as needed...
      });

      print('Cart items added to Firestore.');
    } catch (e) {
      print('Error adding cart items to Firestore: $e');
    }
  }


   // Remove item from cart
  void removeItemFromCart(CartItemModel cartItem) {
    Get.defaultDialog(
      title: 'Remove Product',
      middleText: 'Are you sure you want to remove this product?',
      onConfirm: () {
        // Remove the item from the cart
        cartItems.remove(cartItem);
        // Remove that product from the Product Quantities.
        // productQuantities.remove(cartItem.productId);
        // Remove the price from the total
        totalCartPrice.value -= calculateSingleProductTotal(cartItem.price!, cartItem.quantity);
        cartItems.refresh();
        Get.back();
      },
      barrierDismissible: true,
    );
  }
  
  Future<void> removeItemFromFirestore(CartItemModel cartItem) async {
    try {
      final DocumentReference cartDocRef = _firestore.collection(_cartCollection).doc(userUid);
      final CollectionReference cartItemsCollectionRef = cartDocRef.collection('items');

      // Find the existing cart item document
      final QuerySnapshot querySnapshot = await cartItemsCollectionRef
          .where('productId', isEqualTo: cartItem.productId)
          .where('variationId', isEqualTo: cartItem.variationId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot cartItemDocSnapshot = querySnapshot.docs.first;

        // Remove the cart item document
        await cartItemDocSnapshot.reference.delete();

        print('Cart item removed from Firestore.');
      } else {
        print('Cart item not found in Firestore.');
      }
    } catch (e) {
      print('Error removing cart item from Firestore: $e');
    }
  }


  Future<void> updateCartItemQuantity(CartItemModel cartItem, int newQuantity) async {
    try {
      final DocumentReference cartDocRef = _firestore.collection(_cartCollection).doc(userUid);
      final CollectionReference cartItemsCollectionRef = cartDocRef.collection('items');

      if (newQuantity > 0) {
        // Find the existing cart item document
        final QuerySnapshot querySnapshot = await cartItemsCollectionRef
            .where('productId', isEqualTo: cartItem.productId)
            .where('variationId', isEqualTo: cartItem.variationId)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final DocumentSnapshot cartItemDocSnapshot = querySnapshot.docs.first;

          // Update the quantity field directly with the new value
          await cartItemDocSnapshot.reference.update({'quantity': newQuantity});

          // Update the local cartItem quantity
          cartItem.quantity = newQuantity;
          cartItems.refresh(); // Refresh the UI
        } else {
          print('Cart item not found in Firestore.');
        }
      } else {
        // If the new quantity is less than 1, remove the item from Firestore and local list
        await removeItemFromFirestore(cartItem);
        cartItems.remove(cartItem);
        totalCartPrice.value -= calculateSingleProductTotal(cartItem.price!, cartItem.quantity);
        cartItems.refresh(); // Refresh the UI
      }

      // Update the total cart price
      totalCartPrice.value = cartItems
          .map((e) => calculateSingleProductTotal(e.price!, e.quantity))
          .fold(0, (previous, current) => previous + current);

      print('Cart item quantity updated in Firestore.');
    } catch (e) {
      print('Error updating cart item quantity in Firestore: $e');
    }
  }









 ///================================ Calculations =================================/// 
  double calculateSingleProductTotal(double productPrice, int quantity) {
    return productPrice * quantity;
  }

  String calculateTotalCartItems() {
    
    return cartItems
        .map((element) => element.quantity)
        .fold(0, (previousValue, element) => previousValue + element)
        .toString();
  }

  int calculateSingleProductCartEntries(String productId, String variationId) {
    int cartEntries = 0;

    // If variation is not null get variation total
    if (variationId.isEmpty) {
      cartEntries = cartItems
          .where((item) => item.productId == productId)
          .map((e) => e.quantity)
          .fold(0, (previousQuantity, nextQuantity) => previousQuantity + nextQuantity);
    } else {
      cartEntries = cartItems
          .where((item) => item.productId == productId && item.variationId == variationId)
          .map((e) => e.quantity)
          .fold(0, (previousQuantity, nextQuantity) => previousQuantity + nextQuantity);
    }

    return cartEntries;
  }
}
