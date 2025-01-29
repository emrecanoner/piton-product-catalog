import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/product.dart';
import '../providers/favorite_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteProductsProvider).contains(product);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'product.details'.tr(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Kitap resmi ve favori ikonu
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Center(
                    child: Image.network(
                      product.cover,
                      height: screenHeight * 0.35,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F4FF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFF6251DD),
                        size: 24,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          ref.read(favoriteProductsProvider.notifier)
                              .removeFromFavorites(product);
                        } else {
                          ref.read(favoriteProductsProvider.notifier)
                              .addToFavorites(product);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Kitap adı
              Center(
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              
              // Yazar adı
              Center(
                child: Text(
                  product.author ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Özet başlığı
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'product.summary'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              
              // Özet metni
              Text(
                product.description ?? 'No description available',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              
              // Satın alma butonu
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Satın alma işlemi
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF6B4A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product.price.toStringAsFixed(2)} \$',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'product.buy_now'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
} 