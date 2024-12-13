import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '7e52f5367e0a3cba86aa071779060201'; // Replace with your actual API key

  // Login with username and password
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      // First, get a request token
      final tokenResponse = await http.get(
        Uri.parse('$baseUrl/authentication/token/new?api_key=$apiKey'),
      );
      
      if (tokenResponse.statusCode != 200) {
        throw Exception('Failed to get request token');
      }

      final tokenData = json.decode(tokenResponse.body);
      final requestToken = tokenData['request_token'];

      // Validate the request token with login credentials
      final validateResponse = await http.post(
        Uri.parse('$baseUrl/authentication/token/validate_with_login?api_key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
          'request_token': requestToken,
        }),
      );

      if (validateResponse.statusCode != 200) {
        throw Exception('Invalid credentials');
      }

      // Create a session ID
      final sessionResponse = await http.post(
        Uri.parse('$baseUrl/authentication/session/new?api_key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'request_token': requestToken,
        }),
      );

      if (sessionResponse.statusCode != 200) {
        throw Exception('Failed to create session');
      }

      return json.decode(sessionResponse.body);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Get movie list (popular movies by default)
  Future<Map<String, dynamic>> getMovieList({
    int page = 1,
    String sortBy = 'popularity.desc',
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&page=$page&sort_by=$sortBy'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch movies');
      }

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Failed to get movie list: $e');
    }
  }

  // Get movie details by ID
  Future<Map<String, dynamic>> getMovieDetail(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=credits,videos,reviews'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch movie details');
      }

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Failed to get movie details: $e');
    }
  }
}
