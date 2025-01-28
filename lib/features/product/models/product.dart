class Product {
  final int id;
  final String name;
  final String author;
  final String description;
  final double price;
  final String cover;
  final int sales;
  final int likes;

  Product({
    required this.id,
    required this.name,
    required this.author,
    required this.description,
    required this.price,
    required this.cover,
    required this.sales,
    required this.likes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      cover: 'https://assign-api.piton.com.tr/api/rest/cover_image/${json['cover']}',
      sales: json['sales'] as int,
      likes: json['likes_aggregate']['aggregate']['count'] as int,
    );
  }
} 