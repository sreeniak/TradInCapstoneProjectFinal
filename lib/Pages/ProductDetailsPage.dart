import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/cart_manager.dart';
import '../models/Item.dart';

class ProductDetailsPage extends StatefulWidget {
  final Item product;
  final CartManager cartManager;
  final FirebaseAuth auth;

  ProductDetailsPage({required this.product, required this.cartManager, required this.auth});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  // Your provided function for adding to cart
  void addToCart(Item item) {
    widget.cartManager.addToCart(item);
    uploadItemToFirestore(item);
  }

  Future<void> uploadItemToFirestore(Item item) async {
    final user = widget.auth.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    final cartCollection = firestore.collection('newItem/${user.uid}/cart');

    final querySnapshot = await cartCollection.doc(item.id).get();

    if (querySnapshot.exists) {

      int currentQuantity = querySnapshot.data()?['quantity'] ?? 0;
      await cartCollection.doc(item.id).update({
        'quantity': currentQuantity + 1,  // Increase quantity by 1
      });
    } else {
      // Add new item to the cart
      await cartCollection.doc(item.id).set({
        'name': item.name,
        'price': item.price,
        'imageUrl': item.imageUrl,
        'description': item.description,
        'quantity': 1,  // Set initial quantity to 1
      });

      await firestore.collection('products').doc(item.id).delete();
    }
  }

  // Function to navigate to cart page
  void _navigateToCartPage() {
    Navigator.pushNamed(context, '/cartpage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        backgroundColor: Colors.red[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Hero(
                    tag: widget.product.id,
                    child: Image.network(widget.product.imageUrl),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(widget.product.description),
                  SizedBox(height: 16.0),
                  Text(
                    "Quantity Available: ${widget.product.quantity}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => addToCart(widget.product),
              child: Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red[200],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCartPage,
        icon: Icon(Icons.shopping_cart),
        label: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('newItem/${widget.auth.currentUser!.uid}/cart').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              int totalCount = 0;

              for (var doc in snapshot.data!.docs) {
                int quantity = (doc.data() as Map<String, dynamic>)['quantity'] ?? 0;
                totalCount += quantity;
              }

              return Text(
                '$totalCount',
                style: TextStyle(
                  fontSize: 18,
                ),
              );
            } else {
              return Text('0', style: TextStyle(fontSize: 18));
            }
          },
        ),
        backgroundColor: Colors.redAccent[200],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
