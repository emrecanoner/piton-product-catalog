import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../product/models/product.dart';
import '../../product/providers/product_provider.dart';
import '../../product/providers/category_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchFilteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);
  
  // Tüm kategorilerdeki ürünleri birleştir
  final bestSellers = ref.watch(bestSellerProvider);
  final classics = ref.watch(classicsProvider);
  final children = ref.watch(childrenProvider);
  final philosophy = ref.watch(philosophyProvider);
  
  // Eğer tüm provider'lar yüklenmemişse loading döndür
  if (bestSellers is AsyncLoading || classics is AsyncLoading || 
      children is AsyncLoading || philosophy is AsyncLoading) {
    return const AsyncLoading();
  }
  
  // Eğer herhangi bir hata varsa error döndür
  if (bestSellers is AsyncError || classics is AsyncError || 
      children is AsyncError || philosophy is AsyncError) {
    return AsyncError('Error loading products', StackTrace.current);
  }
  
  // Tüm ürünleri birleştir ve Product listesine dönüştür
  final allProducts = <Product>[
    ...(bestSellers.value as List<Product>? ?? []),
    ...(classics.value as List<Product>? ?? []),
    ...(children.value as List<Product>? ?? []),
    ...(philosophy.value as List<Product>? ?? []),
  ];
  
  // Arama sorgusu boşsa ve kategori seçilmemişse tüm ürünleri döndür
  if (searchQuery.isEmpty && selectedCategory == null) {
    return AsyncData(allProducts);
  }
  
  // Önce kategori filtresini uygula
  var filteredProducts = selectedCategory == null 
    ? allProducts 
    : allProducts.where((product) {
        switch (selectedCategory) {
          case 'Best Seller':
            return (bestSellers.value as List<Product>?)?.contains(product) ?? false;
          case 'Classics':
            return (classics.value as List<Product>?)?.contains(product) ?? false;
          case 'Children':
            return (children.value as List<Product>?)?.contains(product) ?? false;
          case 'Philosophy':
            return (philosophy.value as List<Product>?)?.contains(product) ?? false;
          default:
            return false;
        }
      }).toList();
  
  // Sonra arama sorgusunu uygula
  if (searchQuery.isNotEmpty) {
    filteredProducts = filteredProducts.where((product) =>
      product.name.toLowerCase().contains(searchQuery) ||
      (product.author?.toLowerCase() ?? '').contains(searchQuery) ||
      (product.description?.toLowerCase() ?? '').contains(searchQuery)
    ).toList();
  }
  
  return AsyncData(filteredProducts);
}); 