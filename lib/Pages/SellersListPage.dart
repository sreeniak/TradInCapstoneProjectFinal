import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradin_app/components/cart_manager.dart';
import 'package:tradin_app/models/Item.dart';

class SellersList extends StatefulWidget {
  final CartManager cartManager;
  final FirebaseAuth auth;

  const SellersList({required this.cartManager, required this.auth, Key? key}) : super(key: key);

  @override
  State<SellersList> createState() => _SellersListState();
}

class _SellersListState extends State<SellersList> {
  Future<void> uploadItemToFirestore(Item item) async {
    final user = widget.auth.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    final cartCollection = firestore.collection('newItem/${user.uid}/cart');

    final querySnapshot = await cartCollection.doc(item.id).get();

    if (querySnapshot.exists) {
      int currentQuantity = querySnapshot.data()?['quantity'] ?? 0;
      await cartCollection.doc(item.id).update({
        'quantity': currentQuantity + 1,
      });
    } else {
      await cartCollection.doc(item.id).set({
        'name': item.name,
        'price': item.price,
        'imageUrl': item.imageUrl,
        'description': item.description,
        'quantity': 1,
      });

      await firestore.collection('products').doc(item.id).delete();
    }
  }

  void deleteItem(String itemId) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(itemId).delete();
    } catch (e) {
      print("Error deleting item: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Text('SELLERS-LIST'),
        centerTitle: true,
        toolbarHeight: 100.0,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final itemId = snapshot.data!.docs[index].id;
              final name = productData['name'] ?? 'Default Name';
              final data = productData['price'];
              double price;

              if (data is String) {
                price = double.parse(data);
              } else if (data is double) {
                price = data;
              } else {
                price = 0.0; // Default value
              }

              final imageUrl = productData['imageUrl'] ?? 'image.png';
              final description = productData['description'] ?? 'No description available';
              final quantity = productData['quantity'] as int? ?? 0;
              final itemTransactionType = productData['itemTransactionType'];

              final product = Item(
                id: itemId,
                name: name,
                price: price,
                imageUrl: imageUrl,
                description: description,
                quantity: quantity,
                itemTransactionType: itemTransactionType,
              );

              return Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.all(10.0),
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 100, // Set the width to create a square
                              height: 100, // Set the height to create a square
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("Error loading image: $error");
                                    return Center(child: Icon(Icons.error));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0), // Add spacing between image and text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 16,
                      bottom: 0,
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.redAccent,
                        onPressed: () {
                          // Handle item deletion here
                          deleteItem(product.id);
                        },
                      ),
                    ),
                  ],
                ),
              );





            },
          );
        },
      ),
    );
  }
}
