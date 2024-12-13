import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = '7e52f5367e0a3cba86aa071779060201'; // Replace with your actual API key

  // Create a guest session for anonymous access
  Future<Map<String, dynamic>> login() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/authentication/guest_session/new?api_key=$apiKey'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create guest session');
      }

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Guest login failed: $e');
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
