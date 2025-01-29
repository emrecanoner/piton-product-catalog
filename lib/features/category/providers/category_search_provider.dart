import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../product/models/product.dart';

final categorySearchQueryProvider = StateProvider<String>((ref) => '');

final filteredCategoryProductsProvider = Provider.family<List<Product>, List<Product>>((ref, List<Product> products) {
  final searchQuery = ref.watch(categorySearchQueryProvider).toLowerCase();
  
  if (searchQuery.isEmpty) {
    return products;
  }
  
  return products.where((product) =>
    product.name.toLowerCase().contains(searchQuery) ||
    (product.author?.toLowerCase() ?? '').contains(searchQuery) ||
    (product.description?.toLowerCase() ?? '').contains(searchQuery)
  ).toList();
}); 