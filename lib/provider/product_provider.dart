import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  final Dio _dio = Dio();
  List<Map<String, dynamic>> _filteredProducts = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get products {
    if (_filteredProducts.isNotEmpty) {
      return _filteredProducts;
    } else if (_searchInProgress && _filteredProducts.isEmpty) {
      return []; // Return an empty list if a search is in progress but has no results.
    } else {
      return _products;
    }
  }

  bool _searchInProgress = false;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    const url = 'https://fakestoreapi.com/products';
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        List data = response.data;
        _products = data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      log('Error fetching products: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    _searchInProgress = query.isNotEmpty;
    if (query.isEmpty) {
      _filteredProducts.clear();
    } else {
      _filteredProducts = _products
          .where((product) => product['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
