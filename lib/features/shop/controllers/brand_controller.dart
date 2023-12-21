import 'package:get/get.dart';

import '../models/brand_model.dart';
import '../models/product_model.dart';
import 'dummy_data.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  /// -- Get All Brands
  List<BrandModel> getAllBrands() {
    final brands = TDummyData.brands.toList();
    return brands;
  }

  /// -- Get Brand Products
  List<ProductModel> getBrandProducts(String brandId) {
    // Fetch products against each brand;
    final products = TDummyData.products.where((product) => product.brand?.id == brandId).toList();
    return products;
  }
}
