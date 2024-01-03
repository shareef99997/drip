import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drip/features/shop/models/order_model.dart';
import 'package:drip/features/shop/screens/order/order.dart';
import 'package:drip/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/cart_item_model.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  RxBool isLoading = true.obs;

  RxList<CartItemModel> items = <CartItemModel>[].obs;

  RxList<OrderModel> orders = <OrderModel>[].obs;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final String _ordersCollection = 'orders';
  // Add the user's UID if you want to associate the cart with a user
  String? userUid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Future<void> onInit() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        userUid = FirebaseAuth.instance.currentUser!.uid;
        isLoading.value = true; // Set loading to true while fetching orders
        orders.assignAll(await fetchOrders());
      }
    } catch (e) {
      print('Error fetching Orders from Firestore: $e');
    } finally {
      isLoading.value = false; // Set loading to false when orders are fetched or an error occurs
      print("stop loading");
      print(orders.toString());
      super.onInit();
    }
  }

  String _calculateOrderStatus(DateTime deliveryDate) {
    DateTime currentDate = DateTime.now();
    Duration difference = deliveryDate.difference(currentDate);

    if (difference.inDays > 5) {
      return 'Processing ⏳';
    } else if (difference.inDays >= 0) {
      return 'Shipped ✈️';
    } else {
      return 'Delivered ✅';
    }
  }

  Future<List<OrderModel>> fetchOrders() async {
    List<OrderModel> orders = [];

    try {
      final DocumentReference cartDocRef = _firestore.collection(_ordersCollection).doc(userUid);
      final CollectionReference cartItemsCollectionRef = cartDocRef.collection('userOrders');
      final QuerySnapshot querySnapshot = await cartItemsCollectionRef.orderBy('orderDate', descending: true) // Sort by order date in descending order
        .get();
      // Process documents to populate cartItems
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          // Convert Timestamp to DateTime
          DateTime orderDate = (data['orderDate'] as Timestamp).toDate();
          DateTime deliveryDate = (data['deliveryDate'] as Timestamp).toDate();

          // Fetch items from the subcollection
          List<CartItemModel> items = await fetchItemsFromSubcollection(doc.reference.collection('items'));

          orders.add(OrderModel(
            status: _calculateOrderStatus(deliveryDate),
            id: data['id'],
            items: items,
            totalAmount: data['totalAmount'],
            orderDate: orderDate,
            selectedAddress: data['selectedAddress'],
            selectedPaymentMethod: data['selectedPaymentMethod'],
            deliveryDate: deliveryDate,
            selectedPaymentImage: data['selectedPaymentImage'],
          ));
        }
      }

      print('Orders fetched from Firestore.');
      print(orders.length);
      update(); // Notify observers to update the UI
    } catch (e) {
      print('Error fetching Orders from Firestore: $e');
    }

    return orders;
  }
  
  Future<List<CartItemModel>> fetchItemsFromSubcollection(CollectionReference itemsCollectionRef) async {
    List<CartItemModel> items = [];

    try {
      QuerySnapshot itemsQuerySnapshot = await itemsCollectionRef.get();

      items = itemsQuerySnapshot.docs.map((itemDoc) {
        // Create a CartItemModel from the data in the 'items' subcollection
        return CartItemModel(
          // Map fields accordingly based on your CartItemModel structure
            productId: itemDoc['productId'],
            variationId: itemDoc['variationId'],
            quantity: itemDoc['quantity'],
            title: itemDoc['title'],
            image: itemDoc['image'],
            price: itemDoc['price'],
            brandName: itemDoc['brandName'],
        );
      }).toList();

      print('Items fetched from subcollection.');
    } catch (e) {
      print('Error fetching items from subcollection: $e');
    }

    return items;
  }
  
  Future<void> removeorder(OrderModel order) async {
    try {
      final DocumentReference cartDocRef = _firestore.collection(_ordersCollection).doc(userUid);
      final CollectionReference cartItemsCollectionRef = cartDocRef.collection('userOrders');

      // Find the existing cart item document
      final QuerySnapshot querySnapshot = await cartItemsCollectionRef
          .where('id', isEqualTo: order.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot cartItemDocSnapshot = querySnapshot.docs.first;

        // Remove the cart item document
        await cartItemDocSnapshot.reference.delete();

        print('Order removed from Firestore.');
        
        
        
        TLoaders.successSnackBar(title: 'Order Canceled', message: 'Your order was canceled successfully.');      
        orders.remove(order);
        update(); // Notify observers to update the UI    
      } else {
        print('Order not found in Firestore.');
      }
    } catch (e) {
      print('Error removing Order from Firestore: $e');
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
  

}