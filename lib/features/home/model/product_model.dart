class ProductModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final String description; // ✅ Add this

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.description, // ✅ Add this
  });

  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductModel(
      id: documentId,
      name: data['name'] ?? '',
      price: (data['price'] is int)
          ? (data['price'] as int).toDouble()
          : (data['price'] ?? 0.0),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'All',
      description: data['description'] ?? 'No description available.', // ✅ Add this
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'description': description, // ✅ Add this
    };
  }
}