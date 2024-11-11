import 'dart:developer';
import 'package:authentication_firebase/components/willpop.dart';
import 'package:authentication_firebase/constants/index.dart';
import 'package:authentication_firebase/main_screens/product_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:authentication_firebase/provider/product_provider.dart';
import 'package:authentication_firebase/main_screens/login_page.dart';
import 'package:authentication_firebase/provider/auth_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      log('User UID: ${FirebaseAuth.instance.currentUser?.uid}');
    });
  }

  Future<void> _refresh() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    ProductProvider productProvider = Provider.of<ProductProvider>(context);

    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          centerTitle: true,
          title: const Text(
            "HomePage",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () async {
                  await loginProvider.logOut();
                  RoutingService.gotoWithoutBack(
                    context,
                    LoginPage(),
                  );
                },
                child: Text(
                  "Logout",
                  style: TextStyle(color: black, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        body: productProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: _refresh,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        style: TextStyle(color: black),
                        controller: _searchController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.search),
                            hintText: "Search"),
                        onChanged: (query) {
                          productProvider.searchProducts(query);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    productProvider.products.isEmpty
                        ? Image.asset("assets/no_data_found.jpg")
                        : Expanded(
                            child: GridView.builder(
                              itemCount: productProvider.products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 2),
                              itemBuilder: (context, index) {
                                final product = productProvider.products[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsPage(
                                                product: product),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Image.network(
                                              product['image'],
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.contain,
                                            ),
                                            Text(
                                              product['title'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "\$${product['price']}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "Rating: ${product['rating']['rate']}",
                                                  style: TextStyle(
                                                    color: product['rating']
                                                                ['rate'] >
                                                            3.5
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              product['description'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
