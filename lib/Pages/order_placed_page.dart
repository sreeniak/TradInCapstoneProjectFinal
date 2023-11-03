



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlacedOrderPage extends StatefulWidget {
  final List<QueryDocumentSnapshot> orders;

  PlacedOrderPage({required this.orders, Key? key}) : super(key: key);

  @override
  State<PlacedOrderPage> createState() => _PlacedOrderPageState();
}

class _PlacedOrderPageState extends State<PlacedOrderPage> {

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Text('O R D E R S - P A G E'),
        centerTitle: true,
        toolbarHeight: 100.0,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: ListView.builder(
        itemCount: widget.orders.length,
        itemBuilder: (context, index) {
          String orderId = widget.orders[index].id;
          List<dynamic> itemsList = widget.orders[index]['items'] ?? [];

          List<Order> items = itemsList.map((item) {
            return Order(name: item['name'], price: item['price']);
          }).toList();

          String orderData = items.map((item) => '${item.name} \$${item.price.toStringAsFixed(2)}').join(", ");

          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4,
            child: ListTile(
              title: Text('Order ID: $orderId', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(orderData),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsPage(orderId: orderId, items: items),
                  ),
                );
              },
            ),
          );
        },
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



class Order {
  String name;
  double price;

  // Constructor
  Order({required this.name, required this.price});
}

class OrderDetailsPage extends StatelessWidget {
  final String orderId;
  final List<Order> items;

  OrderDetailsPage({required this.orderId, required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item Name: ${items[index].name}'),
            subtitle: Text('Price: \$${items[index].price.toStringAsFixed(2)}'),
          );
        },
      ),


    );
  }
}
