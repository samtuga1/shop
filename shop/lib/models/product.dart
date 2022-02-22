class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite = false;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isFavorite,
  });
}
