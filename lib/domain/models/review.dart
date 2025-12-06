class Review {
  final int id;
  final int postId;
  final String name;
  final String body;

  Review({
    required this.id,
    required this.postId,
    required this.name,
    required this.body,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      postId: json['postId'],
      name: json['name'],
      body: json['body'],
    );
  }
}
