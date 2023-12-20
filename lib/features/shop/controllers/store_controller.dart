// import 'package:get/get.dart';
// import '../models/brand_model.dart';
// import '../models/category_model.dart';
// import '../models/product_model.dart';
// import 'categories_controller.dart';
// import 'dummy_data.dart';

// class StoreController extends GetxController {
//   static StoreController get instance => Get.find();

//   List<CategoryModel> getFeaturedCategories() {
//     return CategoryController.instance.getFeaturedCategories(8);
//   }

//   List<BrandModel> getFeaturedBrands() {
//     // Get Featured Brands from your data source
//     return TDummyData.brands.where((brand) => brand.isFeatured ?? false).take(4).toList();
//   }

//   List<ProductModel> getBrandProducts(String brandId) {
//     // Get Featured Brands from your data source
//     return TDummyData.products.where((product) => product.brand!.id == brandId).take(3).toList();
//   }

//   List<BrandModel> getCategoryBrands(String categoryId) {
//     // Get Brands
//     final brands = TDummyData.brandCategory
//         .where((brandCategory) => brandCategory.categoryId == categoryId)
//         .map((e) => TDummyData.brands.where((brand) => brand.id == e.brandId).single)
//         .take(2)
//         .toList();

//     return brands;
//   }

//   List<ProductModel> getCategoryProducts(String categoryId) {
//     // Use .toSet() to get unique products.
//     // First we have to get all subCategories of this Category if any.
//     // Example: Category is Sports -> Sub Categories are Running Shoes, Tracksuits etc
//     final subCategoryIds =
//         TDummyData.categories.where((element) => element.parentId == categoryId).map((e) => e.id).toList();

//     // Get products based on category and sub Categories
//     final products = TDummyData.productCategories
//         .where((productCategory) =>
//             productCategory.categoryId == categoryId || subCategoryIds.contains(productCategory.categoryId))
//         .map((e) => TDummyData.products.where((product) => product.id == e.productId).single)
//         .toSet()
//         .toList();

//     return products;
//   }
// }
