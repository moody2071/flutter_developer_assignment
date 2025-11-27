import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';

  // Login API
  Future<User> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // The API response structure is slightly different from the required User model,
      // specifically the token field. We will map 'token' to 'accessToken' in the User model.
      return User.fromJson(data);
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Login failed');
    } else {
      throw Exception('Failed to connect to the login service. Status: ${response.statusCode}');
    }
  }

  // Products API with Pagination
  Future<ProductListResponse> getProducts({required int limit, required int skip}) async {
    final url = Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductListResponse.fromJson(data);
    } else {
      throw Exception('Failed to load products. Status: ${response.statusCode}');
    }
  }
}
