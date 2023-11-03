import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Item.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOrderWithItems(List<Item> orderItems) async {
    try {

      String orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final CollectionReference ordersCollection = _firestore.collection('Orders');

      List<Map<String, dynamic>> itemsData = orderItems.map((item) {
        return {
          'name': item.name,
          'price': item.price,
          //'imageUrl': item.imageUrl,
        };
      }).toList();

      User? currentUser = FirebaseAuth.instance.currentUser; // Get the current user
      if (currentUser != null) { // Check if there's an authenticated user
        await ordersCollection.doc(orderId).set({
          'order_id': orderId,
          'items': itemsData,
          'userId': currentUser.uid, // Add the userId to the order document
        });
      } else {
        throw Exception("User not authenticated");
      }
    } catch (e) {
      throw Exception("Error adding order: $e");
    }
  }

  Future<List<QueryDocumentSnapshot>> fetchOrders() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('Orders')
          .where('userId', isEqualTo: currentUser.uid)
          .get()
          .then((querySnapshot) => querySnapshot.docs);
    }
    return [];
  }
}


/*
  // Fetch all orders from the "Orders" collection
  Future<List<QueryDocumentSnapshot>> getAllOrders() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Orders').get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception("Error fetching orders: $e");
    }
  }
}


   */

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradin_app/models/Item.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOrderWithItems(List<Item> orderItems) async {
    // Create a unique order ID (you can customize the order ID generation)
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    final CollectionReference ordersCollection = _firestore.collection('Orders');
    final CollectionReference orderSubcollection = ordersCollection.doc(orderId).collection('Items');

    for (Item item in orderItems) {
      await orderSubcollection.add({
        'name': item.name,
        'price': item.price,
      });
    }
  }

  // Fetch all orders from the "Orders" collection
  Future<List<QueryDocumentSnapshot>> getAllOrders() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Orders').get();
      List<QueryDocumentSnapshot> orders = querySnapshot.docs;

      // Add this print statement to check the retrieved orders
      print("Fetched Orders: $orders");

      return orders;
    } catch (e) {
      throw Exception("Error fetching orders: $e");
    }
  }

}
 */

/*
  Future<List<QueryDocumentSnapshot>> getItemsForOrder(String orderId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Orders').doc(orderId).collection('Items').get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception("Error fetching items for order: $e");
    }
  }

 */

