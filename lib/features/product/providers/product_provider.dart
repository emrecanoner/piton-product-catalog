import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../../../core/providers/providers.dart';

// ProductService provider'ı
final productServiceProvider = Provider<ProductService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  if (prefs == null) {
    throw UnimplementedError('SharedPreferences is not initialized');
  }
  
  final token = prefs.getString('token');
  
  final dio = Dio(BaseOptions(
    baseUrl: 'https://assign-api.piton.com.tr/api/rest',
    validateStatus: (status) => true,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    },
  ));

  // Dio logging interceptor ekleyelim
  dio.interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  ));

  return ProductService(dio);
});

final productProvider = StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) {
  final productService = ref.watch(productServiceProvider);
  return ProductNotifier(productService);
});

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductService _productService;

  ProductNotifier(this._productService) : super(const AsyncValue.loading()) {
    print('ProductNotifier initialized');
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      print('Loading products...');
      state = const AsyncValue.loading();
      final products = await _productService.getProducts();
      print('Products loaded: ${products.length}');
      state = AsyncValue.data(products);
    } catch (e, stack) {
      print('Error loading products: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadProductsByCategory(int categoryId) async {
    try {
      print('Loading products for category: $categoryId');
      state = const AsyncValue.loading();
      final products = await _productService.getProductsByCategory(categoryId);
      print('Products loaded for category: ${products.length}');
      state = AsyncValue.data(products);
    } catch (e, stack) {
      print('Error loading products by category: $e');
      state = AsyncValue.error(e, stack);
    }
  }
} 