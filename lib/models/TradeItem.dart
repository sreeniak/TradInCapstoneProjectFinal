class TradeItem {
  final String id; // Added this
  final String name;
  final String itemWanted;
  final String imageUrl;
  final String description;
  int quantity;

  TradeItem({
    required this.id, // Updated this
    required this.name,
    required this.itemWanted,
    required this.imageUrl,
    required this.description,
    required this.quantity,
  });

  // Convert item to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Added this
      'name': name,
      'itemWanted': itemWanted,
      'imageUrl': imageUrl,
      'description': description,
      'quantity': quantity,
    };
  }

  // Create an TradeItem from a map
  factory TradeItem.fromMap(Map<String, dynamic> map) {
    return TradeItem(
      id: map['id'], // Added this
      name: map['name'],
      itemWanted: map['itemWanted'],
      imageUrl: map['imageUrl'],
      description: map['description'],
      quantity: map['quantity'],
    );
  }


}