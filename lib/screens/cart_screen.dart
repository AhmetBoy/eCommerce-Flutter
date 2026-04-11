import 'package:flutter/material.dart';
import 'package:my_flutter_app/screens/cart_payment_screen.dart';
import '../services/cart_service.dart';
import '../widgets/product_list_card.dart';
import 'product_detail_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItems = CartService.cartItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Sepet')),
      body: cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sepetiniz boş',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ürün eklemek için ana sayfaya dönün',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final entry = cartItems.entries.elementAt(index);
                final product = entry.key;
                final quantity = entry.value;
                return ProductListCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  showQuantity: true,
                  quantity: quantity,
                  onRemove: () {
                    setState(() {
                      CartService.removeFromCart(product);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} sepetten çıkarıldı'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: cartItems.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPaymentScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.add_shopping_cart,
                color: Colors.deepPurpleAccent,
              ),
              label: const Text(
                'Sepeti Onayla',
                style: TextStyle(color: Colors.deepPurpleAccent),
              ),
              backgroundColor: Colors.black,
            ),
    );
  }
}
