import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/image_text/image_text_vertical.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/dummy_data.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: TAppBar(
        title: Text('Search', style: Theme.of(context).textTheme.headlineMedium),
        actions: [TextButton(onPressed: () => Get.back(), child: const Text('Cancel'))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Search bar & Filter Button
              Row(
                children: [
                  /// Search
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal), hintText: 'Search'),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),

                  /// Filter
                  OutlinedButton(
                    onPressed: () => filterModalBottomSheet(context),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey)),
                    child: const Icon(Iconsax.setting, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Brands
              const TSectionHeading(title: 'Brands', showActionButton: false),
              Wrap(
                children: TDummyData.brands
                    .map((brand) => Padding(
                          padding: const EdgeInsets.only(top: TSizes.md),
                          child: TVerticalImageAndText(
                            image: brand.image,
                            title: brand.name,
                            textColor: THelperFunctions.isDarkMode(context) ? TColors.white : TColors.dark,
                            backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.darkerGrey : TColors.light,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Categories
              const TSectionHeading(title: 'Categories', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: TSizes.spaceBtwItems),
                  itemCount: TDummyData.categories.length,
                  shrinkWrap: true,
                  itemBuilder: (_, index) => Row(
                        children: [
                          Image(
                            width: 25,
                            height: 25,
                            color: isDark ? TColors.white : TColors.dark,
                            image: AssetImage(TDummyData.categories[index].image),
                          ),
                          const SizedBox(width: TSizes.spaceBtwItems / 2),
                          Text(TDummyData.categories[index].name)
                        ],
                      )),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> filterModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: TSizes.defaultSpace,
          right: TSizes.defaultSpace,
          top: TSizes.defaultSpace,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TSectionHeading(title: 'Filter', showActionButton: false),
                  IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.close_square))
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections / 2),

              /// Sort
              Text('Sort by', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: TSizes.spaceBtwItems / 2),

              TGridLayout(
                mainAxisExtent: 20,
                itemCount: TDummyData.sortingFilters.length,
                itemBuilder: (_, index) => Row(
                  children: [
                    const Icon(Icons.circle_outlined, size: 18),
                    const SizedBox(width: TSizes.spaceBtwItems/2),
                    Flexible(child: Text(TDummyData.sortingFilters[index].name, overflow: TextOverflow.ellipsis, maxLines: 1)),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Categories

              Text('Category', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: TSizes.spaceBtwItems),
              TGridLayout(
                mainAxisExtent: 20,
                itemCount: TDummyData.categories.length,
                itemBuilder: (_, index) => InkWell(
                  onTap: (){},
                  splashColor: THelperFunctions.isDarkMode(context) ? TColors.darkerGrey : Colors.grey,
                  child: Row(
                    children: [
                      const Icon(Icons.circle_outlined, size: 18),
                      const SizedBox(width: TSizes.spaceBtwItems/2),
                      Flexible(child: Text(TDummyData.categories[index].name, overflow: TextOverflow.ellipsis, maxLines: 1)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// Sort by Radios
              Text('Pricing', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              Row(
                children: [
                  Expanded(child: TextFormField(decoration: const InputDecoration(hintText: '\$ Lowest'))),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(child: TextFormField(decoration: const InputDecoration(hintText: '\$ Highest'))),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('Apply'))),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
    );
  }
}
