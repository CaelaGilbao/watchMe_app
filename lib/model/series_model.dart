import 'package:firebase_database/firebase_database.dart';

class Series {
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final List<int> genreIds;
  final int id;

  Series({
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.genreIds,
    required this.id,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      title: json['name'], // assuming the field name is 'name' for series
      overview: json['overview'],
      posterPath: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : '',
      releaseDate: json['first_air_date'], // assuming this field name for series
      genreIds: List<int>.from(json['genre_ids']),
      id: json['id'],
    );
  }

  factory Series.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map<dynamic, dynamic>;
    return Series(
      title: data['name'], // assuming the field name is 'name' for series
      overview: data['overview'],
      posterPath: data['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${data['poster_path']}'
          : '',
      releaseDate: data['first_air_date'], // assuming this field name for series
      genreIds: List<int>.from(data['genre_ids']),
      id: data['id'],
    );
  }
}
