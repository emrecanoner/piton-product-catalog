import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../product/models/product.dart';
import '../../product/providers/product_provider.dart';
import '../providers/category_search_provider.dart';

class CategoryDetailScreen extends ConsumerWidget {
  final String title;
  final AsyncValue<List<Product>> products;

  const CategoryDetailScreen({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Grid için ürün kartı boyutları
    final cardWidth = screenWidth * 0.42;
    final cardHeight = cardWidth * 1.8;
    final imageHeight = cardWidth * 1.75;

    return WillPopScope(
      onWillPop: () async {
        ref.read(categorySearchQueryProvider.notifier).state = '';
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    ref.read(categorySearchQueryProvider.notifier).state = '';
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
                    ),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
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
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) {
                  ref.read(categorySearchQueryProvider.notifier).state = value;
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
            ),

            // Products Grid
            Expanded(
              child: products.when(
                data: (productList) {
                  final filteredProducts = ref.watch(
                    filteredCategoryProductsProvider(productList)
                  );
                  
                  return GridView.builder(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: cardWidth / cardHeight,
                      crossAxisSpacing: screenWidth * 0.04,
                      mainAxisSpacing: screenWidth * 0.04,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 10,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  color: const Color(0xFFF4F4FF),
                                  child: Center(
                                    child: Image.network(
                                      product.cover,
                                      height: imageHeight,
                                      width: cardWidth * 0.99,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: imageHeight,
                                          width: cardWidth * 0.99,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.image_not_supported),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: cardHeight * 0.13,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: screenWidth * 0.02,
                                  right: screenWidth * 0.02,
                                  top: 1,
                                  bottom: screenWidth * 0.01,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: screenWidth * 0.026,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 1),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      product.author,
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: screenWidth * 0.022,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${product.price.toStringAsFixed(2)} \$',
                                                    style: TextStyle(
                                                      color: const Color(0xFF6251DD),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: screenWidth * 0.03,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 