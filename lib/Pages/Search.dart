import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedIndex = 1;
  late TextEditingController _searchController;
  List<DocumentSnapshot> allItems = [];
  List<DocumentSnapshot> displayedItems = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _fetchAllItems();  // Load all items from Firestore on initialization
  }

  Future<void> _fetchAllItems() async {
    try {
      final results = await FirebaseFirestore.instance.collection('products').get();
      setState(() {
        allItems = results.docs;
        displayedItems = List.from(allItems); // Initially display all items
      });
    } catch (e) {
      print("Error fetching items: $e");
    }
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedItems = List.from(allItems);
      });
    } else {
      setState(() {
        displayedItems = allItems
            .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {

    } else if (index == 2) {
      Navigator.pushNamed(context, '/cartpage');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/profilepage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        toolbarHeight: 100.0, // Set your desired height here
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            'assets/tradin.png', // Replace with the path to your PNG image
            height: 80.0, // Set the height of the image
            width: 80.0, // Set the width of the image
          ),
        ),
      ),

      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...TradIN',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filterItems(value);
              },
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: displayedItems.length,
              itemBuilder: (context, index) {
                final productData = displayedItems[index].data() as Map<String, dynamic>;
                final price = productData['price'].toString();
                final product = Item(
                  name: productData['name'],
                  price: productData['price'],
                  imageUrl: productData['imageUrl'],
                );

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                  child: ItemTile(item: product),
                );
              },
            ),
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

class ItemTile extends StatelessWidget {
  final Item item;

  ItemTile({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (item.imageUrl != null)
            Image.network(
              item.imageUrl!,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            )
          else
            Container(
              width: 80,
              height: 80,
              color: Colors.grey,
            ),
          SizedBox(height: 8),
          Text(
            item.name, // Display product name
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Price: \$${item.price.toStringAsFixed(2)}',
            // Displaying the price
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

        ],
      ),
    );
  }
}

class Item {
  final String name;
  final double price;
  final String? imageUrl;

  Item({
    required this.name,
    required this.price,
    this.imageUrl,
  });
}

class ProductDetailPage extends StatelessWidget {
  final Item product;

  ProductDetailPage({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        toolbarHeight: 120.0,
        title: Text(product.name),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              product.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Price: \$${product.price.toStringAsFixed(2)}',
              // Displaying the price
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}