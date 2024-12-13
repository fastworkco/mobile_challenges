class Movie {
  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;
  final int voteCount;
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String? ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'] as int,
      overview: json['overview'] as String,
    );
  }
}
