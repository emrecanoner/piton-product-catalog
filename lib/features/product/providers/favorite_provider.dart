import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class FavoriteProductsNotifier extends StateNotifier<List<Product>> {
  FavoriteProductsNotifier() : super([]);

  void addToFavorites(Product product) {
    if (!state.contains(product)) {
      state = [...state, product];
    }
  }

  void removeFromFavorites(Product product) {
    state = state.where((p) => p.id != product.id).toList();
  }
}

final favoriteProductsProvider =
    StateNotifierProvider<FavoriteProductsNotifier, List<Product>>(
  (ref) => FavoriteProductsNotifier(),
); 