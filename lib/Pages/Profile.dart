// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tradin_app/Pages/Feedback.dart';
import 'package:tradin_app/Pages/Settings.dart';
import '../services/firebase_services.dart';
import 'order_placed_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService firebaseService = FirebaseService();
  int _selectedIndex = 3;
  List<QueryDocumentSnapshot> orders = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/searchpage');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/cartpage');
    } else if (index == 3) {
      // No need to push the same page again.

    }
  }


  Future<void> fetchOrders() async {
    try {
      orders = await firebaseService.fetchOrders(); // Assign the fetched orders
      print('Fetched Orders: $orders'); // Add this line to verify if orders are being fetched
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  void confirmSignOut() {
    // Show a confirmation dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close the dialog
                await _signUserOut(); // Perform logout
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signUserOut() async {
    await FirebaseAuth.instance.signOut();


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you for using our app'),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(context, '/firstpage', (route) => false);
    });
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
        ),
        body: Center(
          child: Column(
              children: <Widget>[
                SizedBox(height: 20.0), // Add some spacing

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 150.0,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          await fetchOrders(); // Fetch orders when the button is clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacedOrderPage(orders: orders),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0), // Remove button shadow
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        child: Text(
                          'Your Orders',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 150.0,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle LiveChat button press
                          Navigator.pushNamed(context, '/livechatpage');
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0), // Remove button shadow
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        child: Text(
                          'LiveChat',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

          SizedBox(height: 20.0), // Add some spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 150.0,
                height: 40.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const FeedbackPage()),
                    );
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0), // Remove button shadow
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  child: Text(
                    'Feedback',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              Container(
                width: 150.0,
                height: 40.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0), // Remove button shadow
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 150.0,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle LiveChat button press
                          Navigator.pushNamed(context, '/loginchatpage');
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0), // Remove button shadow
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        child: Text(
                          'Buy&Seller Chat',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: 150.0,
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: ()  {
                          _signUserOut();
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0), // Remove button shadow
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 8.0),  // Spacing between the icon and text
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),



                  ],
                ),
          ]
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
        //backgroundColor: Colors.blueGrey,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[800],
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    ),
    );
  }
}