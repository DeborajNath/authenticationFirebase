import 'package:authentication_firebase/components/bottom_navigation_bar.dart';
import 'package:authentication_firebase/constants/index.dart';
import 'package:provider/provider.dart';
import 'package:authentication_firebase/provider/cart_provider.dart';
import 'package:flutter/material.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    double totalBill = 0.0;
    for (var item in cartProvider.cartItems) {
      totalBill += item['product']['price'] * item['quantity'];
    }
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
          backgroundColor: white,
          centerTitle: true,
          title: Text(
            "List of Items",
            style: TextStyle(
              color: black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: cartProvider.cartItems.isEmpty
            ? const Center(
                child: Text('Your cart is empty'),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cartProvider.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartProvider.cartItems[index];
                          return Dismissible(
                            key: Key(item['product']['id'].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            onDismissed: (direction) {
                              // Remove the item from the cartProvider
                              cartProvider.removeItem(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${item['product']['title']} removed from cart'),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    color: white,
                                    child: ListTile(
                                      leading: Image.network(
                                        item['product']['image'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(
                                        item['product']['title'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle:
                                          Text('Quantity: ${item['quantity']}'),
                                      trailing:
                                          Text("\$${item['product']['price']}"),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          cartProvider.addQuantity(index);
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (item['quantity'] == 1) {
                                            cartProvider.removeItem(index);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    '${item['product']['title']} removed from cart'),
                                              ),
                                            );
                                          } else {
                                            cartProvider
                                                .subtractQuantity(index);
                                          }
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // const Spacer(),
                    Row(
                      children: [
                        const Text(
                          "Total Bill",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Spacer(),
                        Text(
                          "\$${totalBill.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
