import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/dummy_data.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: TDummyData.orders.length,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, index) => const SizedBox(height: TSizes.spaceBtwItems),
      itemBuilder: (_, index) {
        final order = TDummyData.orders[index];
        return TRoundedContainer(
          showBorder: true,
          backgroundColor: THelperFunctions.isDarkMode(context)? TColors.dark : TColors.light,
          child: Column(
            children: [
              /// -- Row 1
              Row(
                children: [
                  /// 1 - Icon
                  const Icon(Iconsax.ship),
                  const SizedBox(width: TSizes.spaceBtwItems/2 ),

                  /// 2 - Status & Date
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.id,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.apply(color: TColors.primary, fontWeightDelta: 1),
                        ),
                        Text(order.orderDate.toString(), style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),

                  /// 3 - Icon
                  IconButton(onPressed: () {}, icon: const Icon(Iconsax.arrow_right_34, size: TSizes.iconSm)),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),

              /// -- Bottom Row
              Row(
                children: [
                  /// Order No
                  Expanded(
                    child: Row(
                      children: [
                        /// 1 - Icon
                        const Icon(Iconsax.tag),
                        const SizedBox(width: TSizes.spaceBtwItems / 2),

                        /// Order
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                order.id,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Delivery Date
                  Expanded(
                    child: Row(
                      children: [
                        /// 1 - Icon
                        const Icon(Iconsax.calendar),
                        const SizedBox(width: TSizes.spaceBtwItems / 2),

                        /// Status & Date
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shipping Date',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                order.deliveryDate.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
