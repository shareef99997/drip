import 'package:drip/common/widgets/images/t_rounded_image.dart';
import 'package:drip/features/shop/controllers/order_controller.dart';
import 'package:drip/features/shop/models/cart_item_model.dart';
import 'package:drip/features/shop/models/order_model.dart';
import 'package:drip/features/shop/screens/order/widgets/Loading_orders.dart';
import 'package:drip/features/shop/screens/order/widgets/order_item.dart';
import 'package:drip/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TOrderListItems extends StatelessWidget {
  const TOrderListItems({super.key});
  
  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());

    return Obx(() {
        final controller = OrderController.instance;
        final orders = controller.orders;
        final isLoading = controller.isLoading.value; // Add this line

       return isLoading ? 
        const LoadingOrders()
        :
        ListView.separated(
          shrinkWrap: true,
          itemCount: orders.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, index) => const SizedBox(height: TSizes.spaceBtwItems),
          itemBuilder: (_, index) {
            final order = orders[index];
            return TRoundedContainer(
              showBorder: true,
              backgroundColor: THelperFunctions.isDarkMode(context)? Color.fromARGB(255, 64, 64, 64) : const Color.fromARGB(255, 241, 241, 241),
              child: Column(
                children: [
                  /// -- Row 1
                  Row(
                    children: [
                      /// 2 - Status & Date
                      Expanded(
                        child: Row(
                          children: [
                            /// 1 - Icon
                            const Icon(Iconsax.ship),
                            const SizedBox(width: TSizes.spaceBtwItems / 2),
                            /// Status
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Date',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(DateFormat('yyyy-MM-dd').format(order.orderDate), style: Theme.of(context).textTheme.titleLarge),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                                        

                      /// 3 - Status
                      Expanded(
                        child: Row(
                          children: [
                            /// 1 - Icon
                            const Icon(Icons.star_outline_sharp),
                            const SizedBox(width: TSizes.spaceBtwItems / 2),
                            /// Status
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(
                                    order.status,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  /// Icon Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:[
                    /// 4 - Icon
                    IconButton(onPressed: () {_showOrderDetailsDialog(context, order);}, icon: const Icon(Iconsax.arrow_right_34, size: TSizes.iconSm)),
                    ]
                    
                    
                  ),
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
                                    'Order ID',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(
                                    order.id,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleLarge,
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
                                    'Estimated Arrival',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(
                                    DateFormat('yyyy-MM-dd').format(order.deliveryDate),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleLarge,
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
   });
  }

  // Method to show order details dialog
  void _showOrderDetailsDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final dark = THelperFunctions.isDarkMode(context);
        return AlertDialog(
          title: Text('Order Details 🧾'),
          content: Container(
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Row(
                      children:[
                        Text(
                          '📍 ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        Text(
                          '${order.selectedAddress}',
                          style: Theme.of(context).textTheme.bodyMedium,
                          )
                      ]
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        TRoundedContainer(
                          width: 55,
                          height: 30,
                          backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.light : TColors.white,
                          padding: const EdgeInsets.all(TSizes.sm),
                          child: Image(image: AssetImage(order.selectedPaymentImage), fit: BoxFit.contain),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems / 2),
                        Text(order.selectedPaymentMethod, style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),      
                    SizedBox(height: 10),
                    
                  ],
                ),      
                SizedBox(height: 10),
                Text(
                  'Items:',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(height: 5,),
                // Display each item in a Column
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Color.fromARGB(29, 0, 0, 0),),
                  padding: EdgeInsets.all(20),
                  height: 350,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (CartItemModel item in order.items)
                          TOrderItem(item: item,)
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Row(
                        children:[
                          Text(
                            "Total : ",
                            style:  Theme.of(context).textTheme.titleMedium ,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            "\$"+order.totalAmount.toStringAsFixed(2),
                            style:  Theme.of(context).textTheme.titleLarge ,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ] 
                    ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              TextButton(
                onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Cancel Order'),
                    content: Text('Are you sure you want to Cancel this Order?'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('No'),
                            style: ButtonStyle(
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              TextStyle(fontSize: 17,fontWeight: FontWeight.w600), // Set the desired font size
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.red, // Set the desired text color
                            ),
                          ),
                              ),
                          Spacer(),
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                
                                OrderController.instance.removeorder(order);
                                
                                Navigator.of(context).pop(); 
                                Navigator.of(dialogContext).pop();
                              },
                              child: Text('Yes'),
                            ),
                          ),
                        ],
                      )
                      
                    ],
                  );
                },
              ),
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(fontSize: 17,fontWeight: FontWeight.w600), // Set the desired font size
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.red, // Set the desired text color
                  ),
                ),
                child: Text('Cancel Order'),
              ),

            ],
          )
            
          ],
        );
      },
    );
  }


}
