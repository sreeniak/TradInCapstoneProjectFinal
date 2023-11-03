// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/TradeItem.dart';



class TradePage extends StatefulWidget {
  //final CartManager cartManager;
  final FirebaseAuth auth;

  TradePage({required this.auth, Key? key}) : super(key: key);
//required this.cartManager,
  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {



  @override
  void initState() {
    super.initState();
    //preloadItemsToFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Text('T R A D E'),
        centerTitle: true,
        toolbarHeight: 100.0,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('products').where('itemTransactionType', isEqualTo: 'Trade').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index].data() as Map<
                  String,
                  dynamic>;
              final itemId = snapshot.data!.docs[index].id;
              final name = productData['name'] ?? 'Default Name';
              final tradeItem = productData['tradeItem'];
              final imageUrl = productData['imageUrl'] ?? 'No image available';
              final description = productData['description'] ??
                  'No description available';
              final quantity = productData['quantity'] as int? ?? 0;

              final product = TradeItem(
                id: itemId,
                name: name,
                itemWanted: tradeItem,
                imageUrl: imageUrl,
                description: description,
                quantity: quantity,
              );

              return Card(
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
                            'Looking for: ' + product.itemWanted,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 12.0),
                        ],
                      ),
                    ),
                  ],
                ),
              );

            },
          );
        },
      ),
      /*floatingActionButton: FloatingActionButton.extended(
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
      */
    );
  }
}