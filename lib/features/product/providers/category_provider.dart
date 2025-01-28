import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/product_service.dart';
import '../models/category.dart';
import 'product_service_provider.dart';

final categoryProvider = FutureProvider<List<Category>>((ref) async {
  final productService = ref.watch(productServiceProvider);
  return productService.getCategories();
});

final selectedCategoryProvider = StateProvider<int>((ref) => 1); // Varsayılan kategori 