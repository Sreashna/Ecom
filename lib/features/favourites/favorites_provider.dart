import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {

  static const _key = 'favorite_product_ids';

  Set<int> _favoriteIds = {};

  Set<int> get favoriteIds => _favoriteIds;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key);
    if (ids != null) {
      _favoriteIds = ids.map(int.parse).toSet();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    await prefs.setStringList(_key, _favoriteIds.map((e) => e.toString()).toList());
    notifyListeners();
  }

  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId);
  }
}
