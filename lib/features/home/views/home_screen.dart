import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../product/providers/product_provider.dart';
import '../../product/views/product_detail_screen.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/views/login_screen.dart';
import '../../product/models/category.dart';
import '../../product/models/product.dart';
import '../../product/providers/category_provider.dart';
import '../../category/views/category_detail_screen.dart';
import '../../home/providers/search_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categories = ref.watch(categoriesProvider);
    final bestSellers = ref.watch(bestSellerProvider);
    final classics = ref.watch(classicsProvider);
    final children = ref.watch(childrenProvider);
    final philosophy = ref.watch(philosophyProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: Image.asset('assets/images/Logo.png'),
              ),
              const Text(
                'Catalog',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[200],
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Kategori filtreleri
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('All', selectedCategory == null, () {
                    ref.read(selectedCategoryProvider.notifier).state = null;
                  }),
                  ...categories.map((category) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _buildFilterChip(
                      category,
                      selectedCategory == category,
                      () {
                        ref.read(selectedCategoryProvider.notifier).state = category;
                      },
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Search bar
            _buildSearchBar(ref),

            const SizedBox(height: 24),

            // Filtrelenmiş ürünleri gösteriyoruz
            filteredProducts.when(
              data: (products) {
                if (searchQuery.isNotEmpty || selectedCategory != null) {
                  return _buildSearchResults(context, products);
                } else {
                  return Column(
                    children: [
                      _buildCategorySection(context, 'Best Seller', bestSellers),
                      _buildCategorySection(context, 'Classics', classics),
                      _buildCategorySection(context, 'Children', children),
                      _buildCategorySection(context, 'Philosophy', philosophy),
                    ],
                  );
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6251DD) : const Color(0xFFF4F4FF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF6251DD),
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String title, AsyncValue<List<Product>> products) {
    // Ekran genişliğine göre responsive değerler
    final screenWidth = MediaQuery.of(context).size.width;
    final containerHeight = 140.0;
    final imageWidth = screenWidth * 0.25; // Ekran genişliğinin %25'i
    final imageHeight = containerHeight * 0.9; // Container yüksekliğinin %90'ı
    final cardWidth = screenWidth * 0.6; // Ekran genişliğinin %60'ı

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailScreen(
                        title: title,
                        products: products,
                      ),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: containerHeight,
          child: products.when(
            data: (products) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  width: cardWidth,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: SizedBox(
                            width: imageWidth,
                            height: containerHeight,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                                child: Image.network(
                                  product.cover,
                                  width: imageWidth,
                                  height: imageHeight,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: imageWidth,
                                      height: imageHeight,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image_not_supported),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          product.author,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 9,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: Text(
                                        '${product.price.toStringAsFixed(2)} \$',
                                        style: const TextStyle(
                                          color: Color(0xFF6251DD),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          suffixIcon: Icon(Icons.tune, color: Colors.grey[400]),
          filled: true,
          fillColor: const Color(0xFFF4F4FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Results (${products.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(context, product);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: Image.network(
          product.cover,
          width: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          product.author ?? '',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Text(
          '${product.price.toStringAsFixed(2)} \$',
          style: const TextStyle(
            color: Color(0xFF6251DD),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
} 