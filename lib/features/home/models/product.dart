class Product {
  final int id;
  final String name;
  final String author;
  final String imageUrl;
  final double price;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.author,
    required this.imageUrl,
    required this.price,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      author: json['author'] as String,
      imageUrl: json['cover'] as String, // API'den gelen alan adı 'cover'
      price: (json['price'] as num).toDouble(),
      categoryId: json['category_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'author': author,
      'cover': imageUrl,
      'price': price,
      'category_id': categoryId,
    };
  }
} 