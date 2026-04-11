import '../models/product.dart';
import 'cart_persistence_service.dart';

class CartService {
  static final Map<Product, int> _cartItems = {};

  static Map<Product, int> get cartItems => _cartItems;

  static Future<void> init() async {
    _cartItems.addAll(await CartPersistenceService.loadCart());
  }

  static Future<void> addToCart(Product product) async {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
    } else {
      _cartItems[product] = 1;
    }
    await CartPersistenceService.saveCart(_cartItems);
  }

  static Future<void> removeFromCart(Product product) async {
    if (_cartItems.containsKey(product)) {
      if (_cartItems[product]! > 1) {
        _cartItems[product] = _cartItems[product]! - 1;
      } else {
        _cartItems.remove(product);
      }
      await CartPersistenceService.saveCart(_cartItems);
    }
  }

  static Future<void> removeAllFromCart(Product product) async {
    _cartItems.remove(product);
    await CartPersistenceService.saveCart(_cartItems);
  }

  static bool isInCart(Product product) {
    return _cartItems.containsKey(product);
  }

  static int getQuantity(Product product) {
    return _cartItems[product] ?? 0;
  }

  static int get totalItems =>
      _cartItems.values.fold(0, (sum, quantity) => sum + quantity);

  static Future<void> clearCart() async {
    _cartItems.clear();
    await CartPersistenceService.clearCart();
  }
}
