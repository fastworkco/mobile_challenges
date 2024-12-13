import 'cast.dart';

class MovieDetail {
  final List<Cast> cast;

  MovieDetail({
    required this.cast,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    final credits = json['credits'] as Map<String, dynamic>;
    final castList = (credits['cast'] as List<dynamic>)
        .map((castJson) => Cast.fromJson(castJson))
        .toList();

    return MovieDetail(cast: castList);
  }
}
