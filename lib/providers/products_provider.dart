import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _skip = 0;
  final int _limit = 10;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (_isLoading) return;

    if (isRefresh) {
      _products = [];
      _skip = 0;
      _hasMore = true;
      _errorMessage = null;
    }

    if (!_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getProducts(limit: _limit, skip: _skip);
      
      _products.addAll(response.products);
      _skip += response.products.length;
      _hasMore = _products.length < response.total;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
