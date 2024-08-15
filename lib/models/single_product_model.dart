class SingleProduct {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final String category;

  SingleProduct({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
  });

  factory SingleProduct.fromJson(Map<String, dynamic> json) {
    return SingleProduct(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      images: List<String>.from(json['images']),
      category: json['category']['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'images': images,
      'category': category,
    };
  }
}
