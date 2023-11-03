
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradin_app/components/cart_manager.dart';
import 'package:tradin_app/models/Item.dart';

import 'ProductDetailsPage.dart';

List<Item> preloadedItems = [
  Item(
    name: 'Beats',
    price: 299,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/beats.png?alt=media&token=1c035c89-b5fc-4601-9c6a-54dd582746a0',
    description: 'Premium quality headphones with immersive sound.',
    quantity: 1,
    id: '',
    itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Bicycle',
    price: 450,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/bicycle.png?alt=media&token=87266b01-4411-4f3a-bd29-0850518e42c6',
    description: 'Sturdy and efficient bicycle for daily commuting.',
    quantity: 1,
    id: '',
    itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Book',
    price: 20,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/book.png?alt=media&token=3cd80aa4-a475-4eac-8a01-30f296d6c96f',
    description: 'Engaging read from best-selling author.',
    quantity: 1,
    id: '',
    itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Camera',
    price: 800,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/camera.png?alt=media&token=73a79252-3856-4953-a1e9-9f34eac66b34',
    description: 'High-resolution camera with exceptional focus quality.',
    quantity: 1,
    id: '',
    itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Dress',
    price: 85,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/dress.png?alt=media&token=4c6f0c9f-53df-41b2-8221-e554e5177990',
    description: 'Elegant dress suitable for both casual and formal occasions.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Handbag',
    price: 120,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/handbag.png?alt=media&token=845484ea-13fc-472e-a848-663d6e4ca4b1',
    description: 'Stylish handbag made with genuine leather.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Helmet',
    price: 50,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/helmet.png?alt=media&token=54c23094-b357-4317-af29-04439d612f37',
    description: 'Safety helmet with comfortable cushioning inside.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'iPad',
    price: 599,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/ipad.png?alt=media&token=d5f220fa-c8ac-44ac-900b-462a3061493b',
    description: 'Latest iPad model with stunning display and fast performance.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'iPod',
    price: 199,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/ipod.png?alt=media&token=3ebcb00b-7208-487c-971c-f31bbd2a0521',
    description: 'Music on the go with extensive battery life.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Laptop',
    price: 1100,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/laptop.png?alt=media&token=a2d8d43f-6c23-4376-ac0b-635b65127f03',
    description: 'Powerful laptop suitable for both work and gaming.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Jacket',
    price: 150,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/jacket.png?alt=media&token=7892d4bc-cd94-4072-b5ff-2903bc443caa',
    description: 'Warm and comfortable jacket for cold weather.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Pot',
    price: 30,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/pot.png?alt=media&token=e02826b0-89d1-4480-b5a9-8ac7326f049f',
    description: 'Durable pot perfect for cooking and serving.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Purse',
    price: 60,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/purse.png?alt=media&token=270a1cf4-833b-4dc8-b40a-ae332a75b22e',
    description: 'Chic purse for carrying essentials.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Shirt',
    price: 40,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/shirt.png?alt=media&token=dc1cf88b-edb2-4c8f-be7d-90afca62b7fc',
    description: 'Cotton shirt with a tailored fit.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'AirPod',
    price: 159,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/airpod.png?alt=media&token=0f90323e-5727-49d4-bd1d-c39fe16ebbff',
    description: 'Wireless earbuds with crystal clear audio quality.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Tees',
    price: 25,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/tees.png?alt=media&token=0cf92ec6-3e6b-45c1-ad63-034e36848c8e',
    description: 'Comfortable tee for daily wear.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Speaker',
    price: 220,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/speaker.png?alt=media&token=ffcd94f0-73c5-4a76-8273-4751c9d7f6a9',
    description: 'Bluetooth speaker with deep bass and clear treble.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
  Item(
    name: 'Shoes',
    price: 90,
    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/tradin-capstone.appspot.com/o/shoes.png?alt=media&token=180de82f-f973-4e18-a217-9bff926c0640',
    description: 'Running shoes with excellent grip and cushioning.',
    quantity: 1,
    id: '', itemTransactionType: 'Sell',
  ),
];

class BuyPage extends StatefulWidget {
  final CartManager cartManager;
  final FirebaseAuth auth;

  BuyPage({required this.cartManager, required this.auth, Key? key}) : super(key: key);

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {

  @override
  void initState() {
    super.initState();
    preloadItemsToFirestore();
  }

  Future<void> uploadItemToFirestore(Item item, {bool removeFromCart = false}) async {
    final user = widget.auth.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;

    if (removeFromCart) {
      final cartItem = await firestore.collection('newItem/${user.uid}/cart').doc(item.id).get();
      if (cartItem.exists) {
        await firestore.collection('products').doc(item.id).set({
          'name': item.name,
          'price': item.price,
          'imageUrl': item.imageUrl,
          'description': item.description,
          'quantity': 1,
          'itemTransactionType': item.itemTransactionType,
        });
        await cartItem.reference.delete();
      }
    } else {
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
          'itemTransactionType': item.itemTransactionType,
        });

        await firestore.collection('products').doc(item.id).delete();
      }
    }
  }



  void addToCart(Item item) {
    widget.cartManager.addToCart(item);
    uploadItemToFirestore(item);
  }

  // Function to navigate to cart page
  void _navigateToCartPage() {
    Navigator.pushNamed(context, '/cartpage');
  }


  Future<void> preloadItemsToFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final productsCollection = firestore.collection('products');

    for (final item in preloadedItems) {
      // item with the same name already exists
      final existingItemQuery = await productsCollection
          .where('name', isEqualTo: item.name)
          .limit(1)
          .get();

      // Only add the item if it doesn't already exist
      if (existingItemQuery.docs.isEmpty) {
        // auto-generate a new document ID.
        final docRef = productsCollection.doc();

        await docRef.set({
          'name': item.name,
          'price': item.price,
          'imageUrl': item.imageUrl,
          'description': item.description,
          'itemTransactionType': item.itemTransactionType,
          'quantity': item.quantity,
          'timestamp': Timestamp.now(),
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Text('B U Y'),
        centerTitle: true,
        toolbarHeight: 100.0,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').where('itemTransactionType', isEqualTo: 'Sell').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6, // Adjust as needed
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index].data() as Map<
                  String,
                  dynamic>;
              final itemId = snapshot.data!.docs[index].id;
              final name = productData['name'] ?? 'Default Name';
              final data = productData['price'];
              double price;

              if (data is String) {
                price = double.parse(data);
              } else if (data is double) {
                price = data;
              } else {
                price = 0.0;
              }

              final imageUrl = productData['imageUrl'] ?? 'image.png';
              final description = productData['description'] ??
                  'No description available';
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

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(product: product, cartManager: widget.cartManager, auth: widget.auth),
                    ),
                  );
                },
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.all(10.0),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("Error loading image: $error");
                                    return Center(child: Icon(Icons.error));
                                  },
                                ),

                              ),
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            SizedBox(height: 12.0),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.shopping_cart, color: Colors.black, size: 28),
                          onPressed: () => addToCart(product),
                          tooltip: 'Add to Cart',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCartPage,
        icon: Icon(Icons.shopping_cart),
        label: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('newItem/${widget.auth.currentUser!.uid}/cart').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              int totalCount = 0;

              // Sum the quantity of all items in the cart
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