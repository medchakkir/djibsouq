class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String category;
  final String description;
  final double rating;
  final int reviews;
  final bool isBestSeller;


  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    this.rating = 4.5,
    this.reviews = 0,
    this.isBestSeller = false,
  });

}

