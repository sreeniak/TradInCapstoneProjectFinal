



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradin_app/models/Item.dart';
import '../services/firebase_services.dart';
import 'order_placed_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key, required this.orderItems, required List<Item> cartItems})
      : super(key: key);

  final List<Item> orderItems;

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final FirebaseService firebaseService = FirebaseService();
  int _selectedIndex = 0;
  List<QueryDocumentSnapshot> orders = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // No need to push the same page again.
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

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/mainpage');
  }

  Future<void> fetchOrders() async {
    try {
      orders = await firebaseService.fetchOrders(); // Assign the fetched orders
      print('Fetched Orders: $orders'); // Add this line to verify if orders are being fetched
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        centerTitle: true,
        toolbarHeight: 120.0,
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
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...TradIN.ca',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.orderItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.orderItems[index].name),
                  subtitle: Text('Price: \$${widget.orderItems[index].price.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              print('Placing order...');
              await firebaseService.addOrderWithItems(widget.orderItems);
              print('Order placed successfully.');

            },
            child: Text('Place Order'),
          ),


          ElevatedButton(
            onPressed: () async {
              await fetchOrders();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlacedOrderPage(orders: orders),
                ),
              );
            },
            child: Text('View Placed Orders'),
          ),

        ],
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
    );
  }
}



/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Item.dart';

class OrderPage extends StatelessWidget {
  final List<Item> cartItems;

  OrderPage({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    print("Received Cart Items in OrderPage: $cartItems");
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cartItems[index].name),
            subtitle: Text('\$${cartItems[index].price.toStringAsFixed(2)}'),
            leading: Image.network(cartItems[index].imageUrl), // assuming imageUrl is a URL
          );
        },
      ),
    );
  }
}


 */



/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Item.dart';

class OrderPage extends StatefulWidget {
  final List<Item> orderItems;

  OrderPage({required this.orderItems});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    // Access the orderItems from the arguments
    final List<Item> orderItems = ModalRoute.of(context)!.settings.arguments as List<Item>;

    // Now you can use the orderItems to display or process them.

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: ListView.builder(
        itemCount: widget.orderItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.orderItems[index].name),
            subtitle: Text('\$${widget.orderItems[index].price.toStringAsFixed(2)}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save the order to Firebase
          saveOrderToFirebase();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  void saveOrderToFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final orderCollection = FirebaseFirestore.instance.collection('orders');
        widget.orderItems.forEach((item) {
          orderCollection.add({
            'itemName': item.name,
            'itemPrice': item.price,
            // Add other item details here
          }).then((value) {
            print('Order saved to Firebase');
          }).catchError((error) {
            print('Failed to save order: $error');
          });
        });
      }
    } catch (e) {
      print('Error saving order to Firebase: $e');
    }
  }
}

 */