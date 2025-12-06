class Product {
  final int id;
  final int userId;
  final String title;
  final String body;

  Product({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }
}
