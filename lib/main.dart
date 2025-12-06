import 'package:ecom_task/features/bottom_navigation/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/api/api_client.dart';
import 'data/repository/product_repository.dart';
import 'features/product_list/product_list_provider.dart';
import 'features/product_list/product_list_screen.dart';
import 'features/favourites/favorites_provider.dart';

void main() {
  final productRepository = ProductRepository(api: ApiClient());

  runApp(
    MultiProvider(
      providers: [
        Provider<ProductRepository>.value(value: productRepository),
        ChangeNotifierProvider(
          create: (context) => ProductListProvider(productRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
