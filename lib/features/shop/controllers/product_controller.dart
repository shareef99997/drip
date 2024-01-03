import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/sizes.dart';
import '../models/product_model.dart';
import '../models/product_variation_model.dart';
import 'cart_controller.dart';
import 'dummy_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  // Variables used to keep the selected features.
  final products = <ProductModel>[].obs;
  RxInt cartQuantity = 0.obs;
  RxString variationStockStatus = ''.obs;
  RxMap selectedAttributes = {}.obs;
  RxString selectedProductImage = ''.obs;
  final favorites = <String, RxBool>{}.obs; // Contains [ProductId: true] Favourite Product
  Rx<ProductVariationModel> selectedVariation = ProductVariationModel.empty().obs;
  
  String? userUid = FirebaseAuth.instance.currentUser?.uid;
  /// -- Initialize Products from your backend
  @override
  void onInit() {
    // Initialize your products from Firestore, SQL, Firebase, Local Storage etc
    products.value = TDummyData.products;
    
    super.onInit();
  }

  /// -- Initialize already added Item's Count in the cart.
  void initializeAlreadyAddedProductCount(ProductModel product) {
    // If product has no variations then calculate cartEntries and display total number.
    // Else make default entries to 0 and show cartEntries when variation is selected.
    if (product.productVariations == null || product.productVariations!.isEmpty) {
      cartQuantity.value = CartController.instance.calculateSingleProductCartEntries(product.id, '');
    } else {
      // Get selected Variation if any...
      final variationId = selectedVariation.value.id;
      if (variationId.isNotEmpty) {
        cartQuantity.value = CartController.instance.calculateSingleProductCartEntries(product.id, variationId);
      } else {
        cartQuantity.value = 0;
      }
    }
  }

  /// -- Get All Images from product and Variations
  List<String> getAllProductImages(ProductModel product) {
    // Use Set to add unique images only
    Set<String> images = {};

    // Load thumbnail image
    images.add(product.thumbnail);
    // Assign Thumbnail as Selected Image
    selectedProductImage.value = product.thumbnail;

    // Get all images from the Product Model if not null.
    if (product.images != null) {
      images.addAll(product.images!);
    }

    // Get all images from the Product Variations if not null.
    if (product.productVariations != null) {
      images.addAll(product.productVariations!.map((variation) => variation.image));
    }

    return images.toList();
  }

  /// -- Show Image Popup
  void showEnlargedImage(String image) {
    Get.to(
      transition: Transition.leftToRightWithFade,
      fullscreenDialog: true,
      () => Dialog.fullscreen(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: TSizes.defaultSpace * 2, horizontal: TSizes.defaultSpace),
                child: Image(image: AssetImage(image)),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 150,
                  child: OutlinedButton(onPressed: () => Get.back(), child: const Text('Close')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// -- Get Single Price Or Price Range in case of variations $5 - $29.99
  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.00;

    // If no variation exist return simple price OR sale price
    if (product.productVariations == null) {
      return (product.salePrice?.toStringAsFixed(2) ?? product.price.toStringAsFixed(2)).toString();
    } else {
      // Calculate the smallest and largest prices
      for (var variation in product.productVariations!) {
        // Check if sale price exist
        double priceToConsider = variation.salePrice ?? variation.price;

        if (priceToConsider < smallestPrice) {
          smallestPrice = priceToConsider;
        }

        if (priceToConsider > largestPrice) {
          largestPrice = priceToConsider;
        }
      }
      // If smallest and largest are same. Return single price.
      if (smallestPrice.isEqual(largestPrice)) {
        return largestPrice.toStringAsFixed(2);
      } else {
        return '${smallestPrice.toStringAsFixed(2)} - \$${largestPrice.toStringAsFixed(2)}';
      }
    }
  }

  /// -- Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if(salePrice == null) return null;
    if (originalPrice <= 0 || salePrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// -- Check Product Stock Status
  String getProductStockStatus(ProductModel product){
    return product.stock > 0 ? 'In Stock' : 'Out of Stock';
  }

  /// -- Check Product Variation Stock Status
  void getProductVariationStockStatus(){
    // Use GetX .obs variable to keep updated the stock status when selected variation changes.
    variationStockStatus.value = selectedVariation.value.stock > 0 ? 'In Stock' : 'Out of Stock';
  }

  /// -- Select Attribute, and Variation
  void onAttributeSelected(ProductModel product, attributeName, attributeValue) {
    // When attribute is selected we will first add that attribute to the selectedAttributes.
    final selectedAttributes = Map<String, dynamic>.from(this.selectedAttributes);
    selectedAttributes[attributeName] = attributeValue;
    this.selectedAttributes[attributeName] = attributeValue;

    // Select Product Variation using all the selected Attributes including new one just added.
    // We will simply loop through all product variations and find the match of same Attributes
    // e.g. : Selected Attributes [Color: Green, Size: Small]
    // e.g. : Product Variation [Color: Green, Size: Small] -> Will be selected.
    final ProductVariationModel selectedVariation = product.productVariations!.firstWhere(
      (variation) => _isSameAttributeValues(variation.attributeValues, selectedAttributes),
      orElse: () => ProductVariationModel.empty(),
    );

    // Show the selected Variation image as a Main Image
    if (selectedVariation.image.isNotEmpty) {
      selectedProductImage.value = selectedVariation.image;
    }

    // Show selected variation quantity already in the cart.
    if (selectedVariation.id.isNotEmpty) {
      cartQuantity.value = CartController.instance.calculateSingleProductCartEntries(product.id, selectedVariation.id);
    }

    this.selectedVariation.value = selectedVariation;

    // Update selected product variation status
    getProductVariationStockStatus();
  }

  /// -- Check If selected attributes matches any variation attributes
  bool _isSameAttributeValues(Map<String, dynamic> variationAttributes, Map<String, dynamic> selectedAttributes) {
    // If selectedAttributes contains 3 attributes and current variation contains 2 then return.
    if (variationAttributes.length != selectedAttributes.length) return false;

    // If any of the attributes is different then return. e.g. [Green, Large] x [Green, Small]
    for (final key in variationAttributes.keys) {
      // Attributes[Key] = Value which could be [Green, Small, Cotton] etc.
      if (variationAttributes[key] != selectedAttributes[key]) return false;
    }

    return true;
  }

  /// -- Check Attribute availability / Stock in Variation
  Set<String?> getAttributesAvailabilityInVariation(List<ProductVariationModel> variations, String attributeName) {
    // Pass the variations to check which attributes are available and stock is not 0
    final availableVariationAttributeValues = variations
        .where((variation) =>
            // Check Empty / Out of Stock Attributes
            variation.attributeValues[attributeName] != null &&
            variation.attributeValues[attributeName]!.isNotEmpty &&
            variation.stock > 0)
        // Fetch all non-empty attributes of variations
        .map((variation) => variation.attributeValues[attributeName])
        .toSet();

    return availableVariationAttributeValues;
  }

  /// -- Add selected variation to cart
  void addProductToCart(ProductModel product) {
    // Product do not have any variations, Simply add to cart
    if (product.productVariations == null) {
      print('1======variation is null so add multible items to cart');
      CartController.instance.addMultipleItemsToCart(product, ProductVariationModel.empty(), cartQuantity.value);
      Get.back();
    } else {
      
      final variation = selectedVariation.value;
      print('1======');
      if (variation.id.isEmpty) {
        Get.snackbar(
            'Select Variation', 'To add items in the cart you first have to select a Variation of this product.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      } else {
        CartController.instance.addMultipleItemsToCart(product, variation, cartQuantity.value);
        Get.back();
      }
    }
  }

  /// --------------------------- Favourites -------------------------------///

  /// Method to check if a product is selected (favorite)
  bool isFavourite(String productId) {
    return favorites[productId]?.value ?? false;
  }

  /// -- Add Product to Favourites
  // void toggleFavoriteProduct(String productId) {
  //   // If favourites do not have this product, Add. Else Toggle
  //   if (!favorites.containsKey(productId)) {
  //     favorites[productId] = true.obs;
  //   } else {
  //     favorites[productId]!.value = !favorites[productId]!.value;
  //   }
  // }

  /// Method to get the list of favorite products
  List<ProductModel> favoriteProducts() {
    return products.where((product) => isFavourite(product.id)).toList();
  }




  ////////////////////////////////
  final CollectionReference _favoritesCollection = FirebaseFirestore.instance.collection('favorites');

  // Save the user's favorite products to Firestore
  Future<void> saveFavoritesToFirestore(List<String> favoriteProductIds) async {
    await _favoritesCollection.doc(userUid).set({
      'favorites': favoriteProductIds,
    });
  }

  // Retrieve the user's favorite products from Firestore
 Future<List<ProductModel>> getFavoritesFromFirestore() async {
    final DocumentSnapshot<Object?> snapshot = await _favoritesCollection.doc(userUid).get();
    final data = snapshot.data() as Map<String, dynamic>?;

    final List<String> favoriteProductIds = data != null ? List<String>.from(data['favorites'] ?? []) : [];

    // Fetch the actual ProductModel objects based on the product IDs
    final List<ProductModel> favoriteProducts = products
        .where((product) => favoriteProductIds.contains(product.id))
        .toList();

    return favoriteProducts;
  }

  // Add product to favorites and save to Firestore
  void toggleFavoriteProduct(String productId) {
    // If favorites do not have this product, Add. Else Toggle
    if (!favorites.containsKey(productId)) {
      favorites[productId] = true.obs;
    } else {
      favorites[productId]!.value = !favorites[productId]!.value;
    }

    // Get the list of favorite products and save to Firestore
    final favoriteProductIds = favoriteProducts().map((product) => product.id).toList();
    saveFavoritesToFirestore(favoriteProductIds);
  }
  

  // Fetch the actual ProductModel objects based on the product IDs
  Future<List<ProductModel>> fetchFavoriteProducts(List<String> productIds) async {
    final List<ProductModel> favoriteProducts = products
        .where((product) => productIds.contains(product.id))
        .toList();

    return favoriteProducts;
  }
}
