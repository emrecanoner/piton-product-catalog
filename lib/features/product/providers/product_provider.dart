import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../../../core/providers/providers.dart';
import '../../home/providers/search_provider.dart';
import 'category_provider.dart';

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

final productProvider = FutureProvider.family<List<Product>, int>((ref, categoryId) async {
  final productService = ref.watch(productServiceProvider);
  return productService.getProductsByCategory(categoryId);
});

// Best Seller ürünleri için ayrı bir provider
final bestSellerProvider = FutureProvider<List<Product>>((ref) async {
  final productService = ref.watch(productServiceProvider);
  final allProducts = await productService.getProductsByCategory(1); // Tüm ürünleri al
  // Satış sayısına göre sırala ve en çok satanları al
  final sortedProducts = List<Product>.from(allProducts)
    ..sort((a, b) => b.sales.compareTo(a.sales));
  return sortedProducts.take(5).toList(); // İlk 5 ürünü göster
});

// Classics ürünleri için ayrı bir provider
final classicsProvider = FutureProvider<List<Product>>((ref) async {
  final productService = ref.watch(productServiceProvider);
  final products = await productService.getProductsByCategory(2); // Classics kategorisi
  return products;
});

// Children ürünleri için ayrı bir provider
final childrenProvider = FutureProvider<List<Product>>((ref) async {
  final productService = ref.watch(productServiceProvider);
  final products = await productService.getProductsByCategory(3); // Children kategorisi
  return products;
});

// Philosophy ürünleri için provider
final philosophyProvider = FutureProvider<List<Product>>((ref) async {
  final productService = ref.watch(productServiceProvider);
  final products = await productService.getProductsByCategory(4); // Philosophy kategorisi
  return products;
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

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  // Seçili kategoriye göre doğru provider'ı kullan
  final products = switch(selectedCategory?.toLowerCase()) {
    'best seller' => ref.watch(bestSellerProvider),
    'classics' => ref.watch(classicsProvider),
    'children' => ref.watch(childrenProvider),
    'philosophy' => ref.watch(philosophyProvider),
    _ => ref.watch(productProvider(1)), // Default olarak tüm ürünler
  };

  return products.when(
    data: (productList) {
      var filteredList = productList;

      // Sadece arama filtresi uygula (kategori filtresi zaten yukarıda uygulandı)
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        filteredList = filteredList.where((product) =>
          product.name.toLowerCase().contains(query) ||
          (product.author?.toLowerCase() ?? '').contains(query) ||
          (product.description?.toLowerCase() ?? '').contains(query)
        ).toList();
      }

      return AsyncValue.data(filteredList);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});