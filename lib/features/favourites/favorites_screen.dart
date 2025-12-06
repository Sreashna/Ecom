import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product_details/product_details_screen.dart';
import 'favorites_provider.dart';
import '../product_list/product_list_provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final productListProvider = Provider.of<ProductListProvider>(context);

    final favoriteProducts = productListProvider.products
        .where((p) => favProvider.favoriteIds.contains(p.id))
        .toList();

    if (favoriteProducts.isEmpty) {
      return Center(child: Text('No favorites yet.'));
    }

    return ListView.builder(
      itemCount: favoriteProducts.length,
      itemBuilder: (context, index) {
        final product = favoriteProducts[index];

        return ListTile(
          leading: Image.network("https://picsum.photos/100?random=${product.id}"),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () => favProvider.toggleFavorite(product.id),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
            );
          },
        );
      },
    );
  }
}
