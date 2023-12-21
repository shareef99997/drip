import 'package:get/get.dart';

import '../models/product_model.dart';

class AllProductsController extends GetxController {
  static AllProductsController get instance => Get.find();

  // Variables used to keep the selected features.
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxString selectedSortOption = 'Name'.obs;
  final RxString selectedFilter = ''.obs;

  void assignProducts(List<ProductModel> products) {
    // Assign products to the 'products' list
    this.products.value = products;
    sortProducts('Name');
  }

  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;

    switch (sortOption) {
      case 'Name':
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Higher Price':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Lower Price':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Newest':
        products.sort((a, b) => a.date!.compareTo(b.date!));
        break;
      case 'Sale':
        products.sort((a, b) {
          if (a.salePrice != null && b.salePrice != null) {
            return a.salePrice!.compareTo(b.salePrice!);
          } else if (a.salePrice != null) {
            return -1;
          } else if (b.salePrice != null) {
            return 1;
          }
          return 0;
        });
        break;
      default:
        // Default sorting option: Name
        products.sort((a, b) => a.title.compareTo(b.title));
    }
  }

  void applyFilter(String filter) {
    selectedFilter.value = filter;
    // Apply a filter to the 'products' list based on the selected filter
  }
}
