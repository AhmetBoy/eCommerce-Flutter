import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService.fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _productsFuture = ApiService.fetchProducts(forceRefresh: true);
    });
    await _productsFuture;
  }

  void _filterProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = _allProducts;
      });
    } else {
      setState(() {
        _filteredProducts = _allProducts
            .where(
              (product) =>
                  product.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      });
    }
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalCartItems = CartService.totalItems;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _openCart,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (totalCartItems > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$totalCartItems',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        title: const Text(
          'DISCOVER',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),

      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Find your perfect device",
                style: TextStyle(fontWeight: FontWeight.w100),
              ),
              SizedBox(height: 8),
              SearchBar(
                controller: _searchController,
                onChanged: _filterProducts,
                textStyle: WidgetStateProperty.all(
                  TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                hintText: "Search Products",
                leading: Icon(Icons.search, color: Colors.grey[500]),

                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                ),

                backgroundColor: WidgetStateProperty.all(Colors.grey[200]),

                elevation: WidgetStateProperty.all(0),

                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),
              // Banner görseli
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  'https://wantapi.com/assets/banner.png',
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 180,
                      child: Center(child: Icon(Icons.broken_image, size: 40)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Hata: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Ürün bulunamadı'));
                    }

                    _allProducts = snapshot.data!;
                    if (_searchController.text.isEmpty) {
                      _filteredProducts = _allProducts;
                    }

                    final productsToDisplay =
                        _filteredProducts.isEmpty &&
                            _searchController.text.isNotEmpty
                        ? _allProducts
                        : (_searchController.text.isEmpty
                              ? _allProducts
                              : _filteredProducts);

                    return GridView.builder(
                      itemCount: productsToDisplay.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                          ),
                      itemBuilder: (context, index) {
                        final product = productsToDisplay[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(product: product),
                              ),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
