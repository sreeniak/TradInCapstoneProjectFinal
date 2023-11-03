import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String itemTransactionType;
  int quantity;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.quantity,
    required this.itemTransactionType,
  });

  // Convert item to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'quantity': quantity,
    };
  }

  // Create an Item from a Firestore document
  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    double priceValue;
    if (data['price'] is String) {
      priceValue = double.tryParse(data['price']) ?? 0.0;
    } else {
      priceValue = (data['price'] ?? 0).toDouble();
    }

    return Item(
      id: doc.id,
      name: data['name'] ?? '',
      price: priceValue,
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      quantity: data['quantity'] ?? 0,
      itemTransactionType: data['itemTransactionType'],
    );
  }

  // Create an Item from a map
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] is String ? double.tryParse(map['price']) : map['price'])?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity'] ?? 0,
      itemTransactionType: map['itemTransactionType'],
    );
  }
}
