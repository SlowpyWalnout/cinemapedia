class MovieVideosResponse {
  final int id;
  final List<MovieVideo> results;

  const MovieVideosResponse({required this.id, required this.results});

  factory MovieVideosResponse.fromJson(Map<String, dynamic> json) {
    return MovieVideosResponse(
      id: json['id'] as int? ?? 0,
      results: (json['results'] as List<dynamic>? ?? [])
          .map((video) => MovieVideo.fromJson(video as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MovieVideo {
  final String iso6391;
  final String iso31661;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String id;
  final DateTime? publishedAt;

  const MovieVideo({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.id,
    required this.publishedAt,
  });

  factory MovieVideo.fromJson(Map<String, dynamic> json) {
    return MovieVideo(
      iso6391: json['iso_639_1'] as String? ?? '',
      iso31661: json['iso_3166_1'] as String? ?? '',
      name: json['name'] as String? ?? '',
      key: json['key'] as String? ?? '',
      site: json['site'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      official: json['official'] as bool? ?? false,
      id: json['id'] as String? ?? '',
      publishedAt: DateTime.tryParse(json['published_at'] as String? ?? ''),
    );
  }
}
