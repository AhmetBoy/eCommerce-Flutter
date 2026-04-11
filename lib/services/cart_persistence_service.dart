import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartPersistenceService {
  static const String _cartKey = 'cart_items';

  static Future<void> saveCart(Map<Product, int> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = cartItems.map(
      (product, quantity) => MapEntry(product.id.toString(), {
        'product': product.toJson(),
        'quantity': quantity,
      }),
    );
    final cartString = jsonEncode(cartJson);
    await prefs.setString(_cartKey, cartString);
  }

  static Future<Map<Product, int>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString(_cartKey);
    if (cartString == null) return {};

    final cartJson = jsonDecode(cartString) as Map<String, dynamic>;
    final cartItems = <Product, int>{};
    for (final entry in cartJson.entries) {
      final data = entry.value as Map<String, dynamic>;
      final productJson = data['product'] as Map<String, dynamic>;
      final product = Product.fromJson(productJson);
      final quantity = data['quantity'] as int;
      cartItems[product] = quantity;
    }
    return cartItems;
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
