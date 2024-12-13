import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/services.dart';

final movieServiceProvider = Provider((ref) => TMDBService());

final movieListProvider = FutureProvider.autoDispose((ref) async {
  final movieService = ref.watch(movieServiceProvider);
  final response = await movieService.getMovieList();
  
  final List<dynamic> results = response['results'];
  return results.map((movie) => Movie.fromJson(movie)).toList();
});

final movieDetailProvider = FutureProvider.family.autoDispose((ref, int movieId) async {
  final movieService = ref.watch(movieServiceProvider);
  final response = await movieService.getMovieDetail(movieId);
  return MovieDetail.fromJson(response);
});
