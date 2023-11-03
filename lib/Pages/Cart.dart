// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../components/cart_manager.dart';
import 'OrderPage.dart';
import 'package:tradin_app/services/firebase_services.dart';


class CartPage extends StatefulWidget {
  final CartManager cartManager;
  final FirebaseAuth auth;

  CartPage({required this.cartManager, required this.auth});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseService firebaseService = FirebaseService();  // Assuming FirebaseServices is the correct class name
  Map<String, dynamic>? paymentIntent;
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/searchpage');
        break;
      case 2:
        break; // No need to push the same page again.
      case 3:
        Navigator.pushNamed(context, '/profilepage');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  void _deleteItem(Item itemToDelete) {
    int index = widget.cartManager.cartItems.indexOf(itemToDelete);
    if (index != -1) {
      setState(() {
        widget.cartManager.removeCartItem(index);
        deleteItemFromFirebase(itemToDelete.id);
        moveItemToProductsCollection(itemToDelete);
      });
    }
  }

  Future<void> deleteItemFromFirebase(String itemId) async {
    final user = widget.auth.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    final cartCollection = firestore.collection('newItem/${user.uid}/cart');

    await cartCollection.doc(itemId).delete();
    print('Item $itemId deleted from Firestore cart.');
  }

  Future<void> moveItemToProductsCollection(Item item) async {
    try {
      final productsCollection = FirebaseFirestore.instance.collection('products');

      // Add or update the item in the 'products' collection using its id
      await productsCollection.doc(item.id).set({
        'name': item.name,
        'price': item.price,
        'imageUrl': item.imageUrl,
        'description': item.description,
        'quantity': item.quantity,
        'itemTransactionType': item.itemTransactionType,
      }, SetOptions(merge: true));


      print('Item ${item.id} moved to products collection.');
    } catch (e) {
      print('Error moving item to products: $e');
    }
  }


  double calculateTotal() {
    return widget.cartManager.cartItems.fold(
        0.0,
            (total, item) => total + item.price
    );
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Shopping Cart',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartManager.cartItems.length,
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    item: widget.cartManager.cartItems[index],
                    onDelete: () => _deleteItem(widget.cartManager.cartItems[index]),
                    onAdd: () {
                      setState(() {
                        widget.cartManager.incrementItemQuantity(index);
                      });
                    },
                  );
                },
              ),
            ),
            ListTile(
              title: Text('Total', style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
              trailing: Text('\$${(calculateTotal()).toStringAsFixed(2)}', style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(23.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[200],
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Proceed to Payment', style: TextStyle(fontSize: 18.0)),
                onPressed: () async => await makePayment(),
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
      ),
    );
  }

  Future<void> fetchDataFromFirebase() async {
    try {
      if (widget.auth.currentUser != null) {
        final user = widget.auth.currentUser!;
        final querySnapshot = await FirebaseFirestore.instance
            .collection('newItem/${user.uid}/cart')
            .get();
        final items = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return Item(
            id: doc.id,
            name: data['name'],
            price: data['price'].toDouble(),
            imageUrl: data['imageUrl'],
            description: data['description'],
            quantity: data['quantity'],
            itemTransactionType: data['itemTransactionType'],
          );
        }).toList();

        setState(() {
          widget.cartManager.cartItems = items;
        });
      }
    } catch (e) {
      print('Error fetching data from Firebase: $e');
    }
  }


  Future<void> makePayment() async {
    try {
      double totalAmount = calculateTotal();
      int amountInCents = (totalAmount).toInt();

      String amount = amountInCents.toString();
      print("Cart items before payment: ${widget.cartManager.cartItems}");
      paymentIntent = await createPaymentIntent(amount, 'USD');

      // Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret:
              paymentIntent!['client_secret'], //Gotten from payment intent
              style: ThemeMode.dark,
              merchantDisplayName: 'Tradin'))
          .then((value) {});

      // Display Payment sheet
      await displayPaymentSheet();

      if (paymentIntent != null) {
        // Print the cart items being passed to the OrderPage
        print("Items passed to OrderPage: ${widget.cartManager.cartItems}");


        saveTransactionDetailsToFirebase(widget.cartManager.cartItems);

        // Clear the cart after a successful payment
        //widget.cartManager.clearCart();

      }
    } catch (err) {
      throw Exception(err);
    }
  }

  void saveTransactionDetailsToFirebase(List<Item> items) async {
    try {
      final user = widget.auth.currentUser;
      if (user != null) {
        final transactionCollection = FirebaseFirestore.instance.collection('transactions');
        for (var item in items) {
          // Add each item to the transaction collection
          await transactionCollection.add({
            'userId': user.uid,
            'name': item.name,
            'price': item.price,
            //'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      print('Error saving transaction details to Firebase: $e');
    }
  }



  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100.0,
                ),
                SizedBox(height: 10.0),
                Text("Payment Successful!"),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Close the dialog

                    // Place the order after successful payment
                    await firebaseService.addOrderWithItems(widget.cartManager.cartItems); // Updated this line

                    // Clear the cart after a successful payment
                    widget.cartManager.clearCart();

                    // Set paymentIntent to null
                    paymentIntent = null;

                    // Optionally navigate to a confirmation page or display a success message
                    Navigator.pushNamed(context, '/orderConfirmationPage'); // Assuming you have a route named '/orderConfirmationPage' for a confirmation page
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          ),
        );
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8.0), // Added for spacing
                  Text("Payment Failed"),
                ],
              )
            ],
          ),
        ),
      );
    } catch (e) {
      print('$e');
    }
  }







  createPaymentIntent(String amount, String currency) async {
    try {
      // Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      // Make a post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }




  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}


class CartItemWidget extends StatelessWidget {
  final Item item;
  final Function() onDelete;
  final Function() onAdd;

  CartItemWidget({required this.item, required this.onDelete, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Image.network(item.imageUrl, height: 60.0, width: 60.0, fit: BoxFit.cover),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Text('\$${item.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18.0)),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
