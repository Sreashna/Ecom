import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product_details/product_details_screen.dart';
import '../favourites/favorites_provider.dart';
import 'product_list_provider.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late TextEditingController _searchController;
  String? _sortOrder;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductListProvider>(context, listen: false);
      provider.fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Products'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (val) {
                    provider.updateSearchKeyword(val);
                  },
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Sort by Seller: ', style: TextStyle(color: Colors.white)),
                    DropdownButton<String>(
                      dropdownColor: Colors.blueAccent,
                      value: _sortOrder,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: SizedBox(),
                      hint: Text('None', style: TextStyle(color: Colors.white)),
                      items: [
                        DropdownMenuItem(value: null, child: Text('None')),
                        DropdownMenuItem(value: 'asc', child: Text('A → Z')),
                        DropdownMenuItem(value: 'desc', child: Text('Z → A')),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _sortOrder = val;
                        });
                        provider.updateSortBySeller(val);
                      }
                      ,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          provider.clearProducts();
          await provider.fetchProducts();
        },
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: provider.filteredProducts.length + (provider.hasMore ? 1 : 0),
          separatorBuilder: (_, __) => Divider(height: 1),
          itemBuilder: (_, index) {
            if (index == provider.filteredProducts.length) {
              provider.fetchProducts();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final product = provider.filteredProducts[index];
            final seller = provider.sellers[product.userId];

            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "https://picsum.photos/100?random=${product.id}",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                seller?.name ?? 'Loading seller...',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Consumer<FavoritesProvider>(
                builder: (context, favProvider, _) {
                  final isFav = favProvider.isFavorite(product.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.redAccent : Colors.grey,
                    ),
                    onPressed: () => favProvider.toggleFavorite(product.id),
                    tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(product: product),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
