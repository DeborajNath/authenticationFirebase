import 'package:authentication_firebase/components/bottom_navigation_bar.dart';
import 'package:authentication_firebase/constants/index.dart';
import 'package:authentication_firebase/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CartProvider favoriteProvider = Provider.of<CartProvider>(context);

    return WillPopScope(
      onWillPop: () {
        return RoutingService.gotoWithoutBack(
          context,
          const CustomBottomNavigationBar(),
        );
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Favorites'),
          backgroundColor: white,
        ),
        body: favoriteProvider.favoriteItems.isEmpty
            ? const Center(child: Text('No favorites added'))
            : ListView.builder(
                padding: const EdgeInsets.all(14),
                itemCount: favoriteProvider.favoriteItems.length,
                itemBuilder: (context, index) {
                  final product = favoriteProvider.favoriteItems[index];
                  return Dismissible(
                    key: Key(product['id']
                        .toString()), // Use a unique key for each item
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.red,
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      // Remove from favorites
                      favoriteProvider.removeFavorite(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '${product['title']} removed from favorites')),
                      );
                    },
                    child: Card(
                      color: white,
                      child: ListTile(
                        leading: Image.network(
                          product['image'],
                          fit: BoxFit.cover,
                        ),
                        title: Text(product['title']),
                        subtitle: Text("\$${product['price']}"),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
