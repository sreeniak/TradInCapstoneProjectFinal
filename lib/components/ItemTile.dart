// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

import '../models/Item.dart';

class ItemTile extends StatelessWidget {
  Item item;
  //double itemTileHeight;
  double imageWidth;
  double imageHeight;

  ItemTile({
    Key? key,
    required this.item,
    //this.itemTileHeight = 500.0,
    this.imageWidth = 150.0,
    this.imageHeight = 150.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            //height: 300,
            margin: EdgeInsets.only(left: 25),
            width: constraints.maxWidth,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // item pic with specified width and height and reduced spacing
                SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(item.imageUrl),
                  ),
                ),

                SizedBox(height: 5), // Adjust the height as needed for spacing

                // description
                Padding(
                  padding: const EdgeInsets.all(8.0), // Add some padding
                  child: Text(
                    item.description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                // price + details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  // Add horizontal padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Align vertically in the center
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Item name
                          Text(
                            item.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          // Price
                          Text(
                            '\$' + item.price.toStringAsFixed(2),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),

                      // plus button
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
    );
  }
}
