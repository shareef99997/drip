import 'package:drip/features/personalization/models/address_model.dart';
import 'package:drip/features/shop/models/payment_method_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final List<CartItemModel> items;
  final String selectedAddress;
  final String selectedPaymentMethod;
  final String selectedPaymentImage;

  OrderModel({
    required this.status, 
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.selectedAddress,
    required this.selectedPaymentMethod,
    required this.deliveryDate,
    required this.selectedPaymentImage,

  });

}
