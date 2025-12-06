import 'package:flutter/foundation.dart';
import '../../data/repository/product_repository.dart';
import '../../domain/models/product.dart';
import '../../domain/models/review.dart';

class ProductDetailsProvider extends ChangeNotifier {
  final ProductRepository repo;
  final Product product;

  ProductDetailsProvider({required this.repo, required this.product});

  List<Review> reviews = [];
  bool loading = false;

  final List<Review> _localReviews = [];

  Future<void> fetchReviews() async {
    loading = true;
    notifyListeners();

    final fetchedReviews = await repo.fetchReviews(product.id);
    reviews = [...fetchedReviews, ..._localReviews];

    loading = false;
    notifyListeners();
  }

  void addReview(Review review) {
    _localReviews.add(review);
    reviews = [...reviews, review];
    notifyListeners();
  }
}
