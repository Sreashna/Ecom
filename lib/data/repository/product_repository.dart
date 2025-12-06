import '../../domain/models/product.dart';
import '../../domain/models/review.dart';
import '../../domain/models/user.dart';
import '../api/api_client.dart';


class ProductRepository {
  final ApiClient api;

  ProductRepository({required this.api});

  Future<List<Product>> fetchProducts(int page, int limit) async {
    final data = await api.get("/posts?_page=$page&_limit=$limit");
    return (data as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<Seller> fetchSeller(int id) async {
    final data = await api.get("/users/$id");
    return Seller.fromJson(data);
  }

  Future<List<Review>> fetchReviews(int productId) async {
    final data = await api.get("/comments?postId=$productId");
    return (data as List).map((e) => Review.fromJson(e)).toList();
  }
}
