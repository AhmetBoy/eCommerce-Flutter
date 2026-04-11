import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://wantapi.com/products.php';
  static const int _cacheDurationMinutes = 5;

  static List<Product>? _cachedProducts;
  static DateTime? _cacheTimestamp;

  static bool _isCacheValid() {
    if (_cachedProducts == null || _cacheTimestamp == null) {
      return false;
    }
    final now = DateTime.now();
    final difference = now.difference(_cacheTimestamp!);
    return difference.inMinutes < _cacheDurationMinutes;
  }

  static void _clearCache() {
    _cachedProducts = null;
    _cacheTimestamp = null;
  }

  // Ürünleri API'den çekme
  static Future<List<Product>> fetchProducts({
    bool forceRefresh = false,
  }) async {
    try {
      // Force refresh'se cache'i temizle
      if (forceRefresh) {
        _clearCache();
      }

      // Cache'de geçerli veri varsa, oradan döndür
      if (_isCacheValid()) {
        print('[ApiService] Veriler cache\'den yüklendi');
        return _cachedProducts!;
      }

      print('[ApiService] API\'den veri çekiliyor...');
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> productsJson = jsonData['data'];

        final products = productsJson
            .map((json) => Product.fromJson(json))
            .toList();

        // Cache'e kaydet
        _cachedProducts = products;
        _cacheTimestamp = DateTime.now();

        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
