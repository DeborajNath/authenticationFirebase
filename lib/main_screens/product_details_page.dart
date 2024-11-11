import 'package:authentication_firebase/components/gradient_button.dart';
import 'package:authentication_firebase/constants/index.dart';
import 'package:authentication_firebase/main_screens/checkout_page.dart';
import 'package:authentication_firebase/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int noOfItems = 0;

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    bool isFavorite = cartProvider.favoriteItems
        .any((item) => item['id'] == widget.product['id']);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      widget.product['image'],
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product['title'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                        ),
                        onPressed: () {
                          if (widget.product.containsKey('id')) {
                            if (isFavorite) {
                              cartProvider.removeFavorite(widget.product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Removed from Favorites'),
                                ),
                              );
                            } else {
                              cartProvider.addFavorite(widget.product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to Favorites'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Product is missing ID or invalid data'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Rating: ${widget.product['rating']['rate']} (${widget.product['rating']['count']} reviews)",
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.product['rating']['rate'] > 3.5
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Text(
                        "Price: \$${widget.product['price']}",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product['description'],
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const Text(
                        "Number of Items: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Spacer(),
                      IconButton(
                        color: red,
                        onPressed: () {
                          if (noOfItems > 0) {
                            setState(() {
                              noOfItems--;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.remove,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "$noOfItems",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      IconButton(
                        color: green,
                        onPressed: () {
                          setState(() {
                            noOfItems++;
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          GradientButton(
            onTap: () {
              if (noOfItems > 0) {
                cartProvider.addItem(widget.product, noOfItems);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added $noOfItems items to cart'),
                  ),
                );
                RoutingService.goto(
                  context,
                  const CheckOutPage(),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please add at least one item'),
                  ),
                );
              }
            },
            text: "Add to Cart",
          ),
        ],
      ),
    );
  }
}
