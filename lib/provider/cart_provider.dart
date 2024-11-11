import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;
  List<Map<String, dynamic>> _favoriteItems = [];

  List<Map<String, dynamic>> get favoriteItems => _favoriteItems;

  CartProvider() {
    _loadCart();
    _loadFavorites();
  }

  _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartData = prefs.getString('cartItems');

    if (cartData != null) {
      List<dynamic> decodedData = json.decode(cartData);
      _cartItems = List<Map<String, dynamic>>.from(decodedData);
      notifyListeners();
    }
  }

  _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoriteData = prefs.getString('favoriteItems');

    if (favoriteData != null) {
      List<dynamic> decodedData = json.decode(favoriteData);
      _favoriteItems = List<Map<String, dynamic>>.from(decodedData);
      notifyListeners();
    }
  }

  _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    String favoriteData = json.encode(_favoriteItems);
    prefs.setString('favoriteItems', favoriteData);
  }

  _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    String cartData = json.encode(_cartItems);
    prefs.setString('cartItems', cartData);
  }

  void addFavorite(Map<String, dynamic> product) {
    if (!_favoriteItems.contains(product)) {
      _favoriteItems.add(product);
      _saveFavorites();
      notifyListeners();
    }
  }

  void removeFavorite(Map<String, dynamic> product) {
    _favoriteItems.removeWhere((item) => item['id'] == product['id']);
    _saveCart();
    _saveFavorites();
    notifyListeners();
  }

  void addItem(Map<String, dynamic> product, int quantity) {
    int existingIndex = cartItems.indexWhere(
      (item) => item['product']['id'] == product['id'],
    );

    if (existingIndex != -1) {
      cartItems[existingIndex]['quantity'] += quantity;
    } else {
      cartItems.add({
        'product': product,
        'quantity': quantity,
      });
    }
    _saveCart();
    notifyListeners();
  }

  void removeItem(int index) {
    log("Removing item at index $index");
    _cartItems.removeAt(index);
    _saveCart();
    notifyListeners();
  }

  void addQuantity(int index) {
    _cartItems[index]['quantity'] += 1;
    notifyListeners();
  }

  void subtractQuantity(int index) {
    if (_cartItems[index]['quantity'] > 1) {
      _cartItems[index]['quantity'] -= 1;
    } else {
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }

  clearCart() {
    _cartItems.clear();
    _saveCart();
    notifyListeners();
  }
}
