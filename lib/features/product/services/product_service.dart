import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/category.dart';

class ProductService {
  final Dio _dio;

  ProductService(this._dio);

  Future<String> getProductCoverImage(String fileName) async {
    try {
      final response = await _dio.post('/cover_image', data: {
        'fileName': fileName,
      });
      
      print('Cover Image Response: ${response.data}');
      
      if (response.statusCode == 200 && 
          response.data['action_product_image'] != null &&
          response.data['action_product_image']['url'] != null) {
        return response.data['action_product_image']['url'] as String;
      }
      return '';
    } catch (e) {
      print('Error getting cover image: $e');
      return '';
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products/1');
      print('Products Response Raw: ${response.data}');
      
      if (response.statusCode == 200 && response.data['product'] != null) {
        final List<dynamic> productList = response.data['product'];
        print('Product List Length: ${productList.length}');
        
        final products = productList.map((json) {
          print('Processing product: $json');
          return Product.fromJson(json);
        }).toList();
        
        print('Processed Products: $products');
        return products;
      }
      
      if (response.data['error'] != null) {
        throw Exception(response.data['error']);
      }
      
      throw Exception('Ürünler yüklenirken bir hata oluştu');
    } catch (e) {
      print('Error getting products: $e');
      rethrow;
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      print('Categories Response: ${response.data}');
      
      if (response.statusCode == 200 && response.data['category'] != null) {
        final List<dynamic> categoryList = response.data['category'];
        return categoryList.map((json) => Category.fromJson(json)).toList();
      }
      
      throw Exception('Kategoriler yüklenirken bir hata oluştu');
    } catch (e) {
      print('Error getting categories: $e');
      rethrow;
    }
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _dio.get('/products/$categoryId');
      
      if (response.statusCode == 200 && response.data['product'] != null) {
        final List<dynamic> productList = response.data['product'];
        final products = <Product>[];
        
        for (var json in productList) {
          final product = Product.fromJson(json);
          // Her ürün için cover image URL'ini al
          if (product.cover.isNotEmpty) {
            final coverUrl = await getProductCoverImage(product.cover);
            if (coverUrl.isNotEmpty) {
              products.add(Product(
                id: product.id,
                name: product.name,
                author: product.author,
                description: product.description,
                price: product.price,
                cover: coverUrl,
                sales: product.sales,
                likes: product.likes,
                category: product.category,
              ));
              continue;
            }
          }
          products.add(product);
        }
        
        return products;
      }
      
      throw Exception('Ürünler yüklenirken bir hata oluştu');
    } catch (e) {
      print('Error getting products: $e');
      rethrow;
    }
  }
} 