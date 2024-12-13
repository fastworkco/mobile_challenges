class Cast {
  final int id;
  final String name;
  final String profilePath;

  Cast({
    required this.id,
    required this.name,
    required this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] as int,
      name: json['name'] as String,
      profilePath: json['profile_path'] as String? ?? '',
    );
  }
}
