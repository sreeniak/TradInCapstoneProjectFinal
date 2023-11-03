import '../models/Item.dart';

class CartManager {
  List<Item> cartItems = [];
  double total = 0.0;

  // Add this method to increment the quantity
  void incrementItemQuantity(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems[index].quantity++;
    }
  }


  void addToTotal(double price) {
    total += price;
  }

  void subtractFromTotal(double price) {
    total -= price;
  }

  void addToCart(Item item) {
    cartItems.add(item);
    addToTotal(item.price);
  }

  // Add a method to update cart items
  void setCartItems(List<Item> items) {
    cartItems = items;
  }


  // Remove an item from the cart
  void removeCartItem(int index) {
    if (index >= 0 && index < cartItems.length) {
      subtractFromTotal(cartItems[index].price);
      cartItems.removeAt(index);
    }
  }

  void clearCart() {
    cartItems.clear();
  }
}


