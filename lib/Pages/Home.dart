  // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/material.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import '../components/ItemTile.dart';
  import '../components/cart_manager.dart';
  import '../models/Item.dart';
import 'ProductDetailsPage.dart';





  class Home extends StatefulWidget {
    final CartManager cartManager;
    final FirebaseAuth auth;

    const Home({required this.cartManager, required this.auth, Key? key}) : super(key: key);

    @override
    _HomeState createState() => _HomeState();
  }

  class _HomeState extends State<Home> {
    User? user = FirebaseAuth.instance.currentUser;
    int _selectedIndex = 0;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });

      if (index == 0) {
        // No need
      } else if (index == 1) {
        print('Navigating to Search');
        Navigator.pushNamed(context, '/searchpage');
      } else if (index == 2) {
        print('Navigating to Cart');
        Navigator.pushNamed(context, '/cartpage');
      } else if (index == 3) {
        print('Navigating to Profile');
        Navigator.pushNamed(context, '/profilepage');
      }
    }

    void addToCart(Item item) {
      widget.cartManager.addToCart(item);
      uploadItemToFirestore(item);
    }

    void _navigateToCartPage() {
      Navigator.pushNamed(context, '/cartpage');
    }

    Future<void> uploadItemToFirestore(Item item) async {
      final user = widget.auth.currentUser;
      if (user == null) return;

      final firestore = FirebaseFirestore.instance;
      final cartCollection = firestore.collection('newItem/${user.uid}/cart');

      final querySnapshot = await cartCollection.doc(item.id).get();

      if (querySnapshot.exists) {
        // updating quantity
        int currentQuantity = querySnapshot.data()?['quantity'] ?? 0;
        await cartCollection.doc(item.id).update({
          'quantity': currentQuantity + 1,  // Increase quantity by 1
        });
      } else {
        // Adding new item to cart
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


    void signUserOut() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/firstpage', (route) => false);
    }

    @override
    Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.popUntil(context, (route) => route.isFirst);
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.pink[50],
          appBar: AppBar(
            backgroundColor: Colors.red[200],
            toolbarHeight: 100.0,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/tradin.png',
                height: 80.0,
                width: 80.0,
              ),
            ),
            actions: [
              IconButton(
                onPressed: signUserOut,
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  width: 375.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: Colors.white.withOpacity(0.6),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 4),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...TradIN',
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 85.0,
                      height: 45.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/buypage');
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        child: Text(
                          'Buy',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 85.0,
                      height: 45.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/productlist');
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        child: Text(
                          'Sell',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 85.0,
                      height: 45.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/tradepage');
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        child: Text(
                          'Trade',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  "Today's Recommendations",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('products').limit(5).snapshots(),

                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final items = snapshot.data!.docs.map((doc) {
                      final productData = doc.data() as Map<String, dynamic>;
                      final itemId = doc.id;
                      final name = productData['name'] as String? ?? 'Default Name';
                      final data = productData['price'];
                      double price = (data is String) ? double.parse(data) : (data as double?) ?? 0.0;
                      final imageUrl = productData['imageUrl'] as String? ?? 'image.png';
                      final description = productData['description'] as String? ?? 'No description available';
                      final quantity = productData['quantity'] as int? ?? 0;
                      final itemTransactionType = productData['itemTransactionType'] as String? ?? 'Sell';

                      return Item(
                        id: itemId,
                        name: name,
                        price: price,
                        imageUrl: imageUrl,
                        description: description,
                        quantity: quantity,
                        itemTransactionType: itemTransactionType,
                      );
                    }).toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final product = items[index];
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
                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: IntrinsicHeight(
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      product.imageUrl,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        print("Error loading image: $error");
                                        return Center(child: Icon(Icons.error));
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
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
                                          Text(
                                            product.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.shopping_cart, color: Colors.black, size: 28),
                                    onPressed: () => addToCart(product),
                                    tooltip: 'Add to Cart',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );

                  },
                ),







              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.red[800],
            unselectedItemColor: Colors.black,
            onTap: _onItemTapped,
          ),
        ),
      );
    }
  }
