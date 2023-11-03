import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveChatPage extends StatefulWidget {
  const LiveChatPage({Key? key}) : super(key: key);

  @override
  _LiveChatPageState createState() => _LiveChatPageState();
}

class _LiveChatPageState extends State<LiveChatPage> {
  int _selectedIndex = 0;
  late User? user;

  static const String directChatLink = 'https://tawk.to/chat/64d5962794cf5d49dc69b59b/1h7h553bu';
  // alternate link https://tawk.to/LiveChatPage

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
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
      ),
      body: WebView(
        initialUrl: directChatLink, // Use the direct chat link here
        javascriptMode: JavascriptMode.unrestricted,
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
}