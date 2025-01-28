import 'package:dio/dio.dart';
import '../models/product.dart';

class ProductService {
  final Dio _dio;

  ProductService(this._dio);

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/product/all');
      print('Products Response: ${response.data}');
      
      if (response.statusCode == 200 && response.data['product'] != null) {
        final List<dynamic> productList = response.data['product'];
        return productList.map((json) => Product.fromJson(json)).toList();
      }
      throw Exception('Ürünler yüklenirken bir hata oluştu');
    } catch (e) {
      print('Error getting products: $e');
      rethrow;
    }
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _dio.get('/product/category/$categoryId');
      print('Products Response for category $categoryId: ${response.data}');
      
      if (response.statusCode == 200 && response.data['product'] != null) {
        final List<dynamic> productList = response.data['product'];
        return productList.map((json) => Product.fromJson(json)).toList();
      }
      throw Exception('Kategori ürünleri yüklenirken bir hata oluştu');
    } catch (e) {
      print('Error getting products by category: $e');
      rethrow;
    }
  }

  Future<String> getProductCoverImage(String fileName) async {
    try {
      final response = await _dio.post('/cover_image', data: {
        'fileName': fileName,
      });
      print('Cover Image Response: ${response.data}');
      
      if (response.data['action_product_image'] != null) {
        return response.data['action_product_image'];
      }
      return '';
    } catch (e) {
      print('Error in getProductCoverImage: $e');
      return '';
    }
  }
} 