import 'package:firebase_database/firebase_database.dart';

class Movie {
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final List<int> genreIds;
  final int id;

  Movie({
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.genreIds,
    required this.id,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : '',
      releaseDate: json['release_date'],
      genreIds: List<int>.from(json['genre_ids']),
      id: json['id'],
    );
  }

  factory Movie.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Movie(
      title: data['title'],
      overview: data['overview'],
      posterPath: data['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${data['poster_path']}'
          : '',
      releaseDate: data['release_date'],
      genreIds: List<int>.from(data['genre_ids']),
      id: data['id'],
    );
  }
}
