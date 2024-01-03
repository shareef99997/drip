import 'package:drip/common/widgets/icons/t_circular_icon.dart';
import 'package:drip/common/widgets/images/t_rounded_image.dart';
import 'package:drip/common/widgets/texts/t_brand_title_text_with_verified_icon.dart';
import 'package:drip/common/widgets/texts/t_product_title_text.dart';
import 'package:drip/features/shop/models/cart_item_model.dart';
import 'package:drip/utils/constants/colors.dart';
import 'package:drip/utils/constants/sizes.dart';
import 'package:drip/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class TOrderItem extends StatelessWidget {
  const TOrderItem({
    super.key,
    required this.item,
  });

  final CartItemModel item;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            /// 1 - Image
            TRoundedImage(
              width: 50,
              height: 50,
              imageUrl: item.image ?? '',
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.darkerGrey : TColors.light,
            ),
            const SizedBox(width: TSizes.spaceBtwItems-6),

            /// 2 - Title, Price, & Size
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Brand and Title
                  TBrandTitleWithVerifiedIcon(title: item.brandName ?? ''),
                  Flexible(child: TProductTitleText(title: item.title ?? '', maxLines: 1)),

                  /// Attributes
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                          'Quantity: ',
                          style:  Theme.of(context).textTheme.bodySmall ,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          item.quantity.toString(),
                          style:  Theme.of(context).textTheme.titleMedium ,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                          ],
                        ),
                        
                        Text(
                          "\$"+item.price!.toStringAsFixed(2),
                          style:  Theme.of(context).textTheme.titleMedium ,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  )
                
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
      ],
    );
  }
}
