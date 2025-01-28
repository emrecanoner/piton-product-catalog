import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../product/providers/product_provider.dart';
import '../../product/views/product_detail_screen.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/views/login_screen.dart';
import '../models/category.dart';
import '../../product/models/product.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  Category? selectedCategory;
  List<Category> categories = [];
  List<Product> bestSellerProducts = [];
  List<Product> classicsProducts = [];
  List<Product> childrenProducts = [];

  void _selectCategory(Category? category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _onSearchChanged(String value) {
    // Search logic
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authState = ref.watch(authStateProvider);
    
    return authState.when(
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }
        
        final productsState = ref.watch(productProvider);
        
        return productsState.when(
          data: (products) {
            // Ürünleri kategorilere göre ayır
            bestSellerProducts = products.where((p) => p.id == 1).toList();
            classicsProducts = products.where((p) => p.id == 2).toList();
            childrenProducts = products.where((p) => p.id == 3).toList();
            
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo ve Catalog
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 0.1,
                            height: size.width * 0.1,
                            child: Image.asset(
                              'assets/images/Logo.png',
                              color: const Color(0xFF6251DD),
                            ),
                          ),
                          Text(
                            'Catalog',
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1D1D4E),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Categories
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CategoryChip(
                              label: 'All',
                              isSelected: selectedCategory == null,
                              onTap: () => _selectCategory(null),
                            ),
                            ...categories.map((category) => CategoryChip(
                              label: category.name,
                              isSelected: selectedCategory?.id == category.id,
                              onTap: () => _selectCategory(category),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),

                      // Search Bar
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F5F7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, size: size.width * 0.05),
                            SizedBox(width: size.width * 0.02),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontSize: size.width * 0.035,
                                    color: Colors.grey,
                                  ),
                                ),
                                onChanged: _onSearchChanged,
                              ),
                            ),
                            Icon(Icons.tune, size: size.width * 0.05),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),

                      // Best Seller Section
                      _buildSection(
                        title: 'Best Seller',
                        products: bestSellerProducts,
                        size: size,
                      ),

                      // Classics Section
                      _buildSection(
                        title: 'Classics',
                        products: classicsProducts,
                        size: size,
                      ),

                      // Children Section
                      _buildSection(
                        title: 'Children',
                        products: childrenProducts,
                        size: size,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Scaffold(
            body: Center(
              child: Text('Error: $error'),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Product> products,
    required Size size,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: size.width * 0.045,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D1D4E),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  color: const Color(0xFFEF6B4A),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.01),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: products.map((product) => ProductCard(
              product: product,
              size: size,
            )).toList(),
          ),
        ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6251DD) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF6251DD),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF6251DD),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final Size size;

  const ProductCard({
    super.key,
    required this.product,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.35,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://assign-api.piton.com.tr${product.cover}',
              height: size.width * 0.45,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: size.width * 0.45,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: TextStyle(
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D1D4E),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            product.author,
            style: TextStyle(
              fontSize: size.width * 0.03,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${product.price.toStringAsFixed(2)} \$',
            style: TextStyle(
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6251DD),
            ),
          ),
        ],
      ),
    );
  }
} 