import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/product_service.dart';
import '../models/category.dart';
import 'product_service_provider.dart';

final categoryProvider = FutureProvider<List<Category>>((ref) async {
  final productService = ref.watch(productServiceProvider);
  return productService.getCategories();
});

// Seçili kategori için provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Kategori listesi için provider (API'daki kategorilerle eşleştirdik)
final categoriesProvider = Provider<List<String>>((ref) => [
  'Best Seller',
  'Classics',
  'Children',
  'Philosophy',
]); 