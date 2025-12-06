import 'package:flutter/foundation.dart';
import '../../data/repository/product_repository.dart';
import '../../domain/models/product.dart';
import '../../domain/models/user.dart';

class ProductListProvider extends ChangeNotifier {
  final ProductRepository repo;

  ProductListProvider(this.repo);

  final List<Product> _allProducts = [];
  List<Product> get products => _allProducts;

  List<Product> filteredProducts = [];

  final Map<int, Seller> sellers = {};

  int page = 1;
  final int limit = 10;
  bool loading = false;
  bool hasMore = true;

  String searchKeyword = '';
  String? sortBySeller;

  Future<void> fetchProducts() async {
    if (loading || !hasMore) return;

    loading = true;
    notifyListeners();

    try {
      final products = await repo.fetchProducts(page, limit);

      if (products.isEmpty) {
        hasMore = false;
      } else {
        _allProducts.addAll(products);
        page++;

        await Future.wait(products.map((product) async {
          if (!sellers.containsKey(product.userId)) {
            sellers[product.userId] = await repo.fetchSeller(product.userId);
          }
        }));
      }

      _applyFilters();
    } catch (e) {
    }

    loading = false;
    notifyListeners();
  }


  void _applyFilters() {
    filteredProducts = _allProducts.where((product) {
      final keyword = searchKeyword.toLowerCase();
      return product.title.toLowerCase().contains(keyword) ||
          product.body.toLowerCase().contains(keyword);
    }).toList();

    if (sortBySeller != null) {
      filteredProducts.sort((a, b) {
        final sellerA = sellers[a.userId]?.name ?? '';
        final sellerB = sellers[b.userId]?.name ?? '';
        print('Sorting: $sellerA vs $sellerB');
        return sortBySeller == 'asc'
            ? sellerA.compareTo(sellerB)
            : sellerB.compareTo(sellerA);
      });
    }
  }


  void updateSearchKeyword(String keyword) {
    searchKeyword = keyword;
    _applyFilters();
    notifyListeners();
  }
  void updateSortBySeller(String? order) {
    sortBySeller = order;
    _applyFilters();
    notifyListeners();
  }

  void clearProducts() {
    _allProducts.clear();
    filteredProducts.clear();
    page = 1;
    hasMore = true;
    notifyListeners();
  }
}
