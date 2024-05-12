class Series {
  final String id;
  final String title;
  final String backDropPath;
  final String overview;
  final String posterPath;
  final List<int> genreIds;
  final String releaseDate;

  Series({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.genreIds,
    required this.releaseDate,
  });

  factory Series.fromMap(Map<String, dynamic> map) {
    return Series(
      id: map['id'].toString(),
      title: map['name'],
      backDropPath: map['backdrop_path'] != null ?map['backdrop_path'] : '',
      overview: map['overview'],
      posterPath: map['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${map['poster_path']}'
          : '',
      genreIds: List<int>.from(map['genre_ids'] ?? []),
      releaseDate: map['release_date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'backDropPath': backDropPath,
      'overview': overview,
      'posterPath': posterPath,
      'genreIds': genreIds,
      'releaseDate': releaseDate,
    };
  }
}
