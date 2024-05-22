import '../model/movie_model.dart';
import '../model/series_model.dart';

class SearchResult {
  final List<Movie> movies;
  final List<Series> series;

  SearchResult({required this.movies, required this.series});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      movies: (json['results'] as List)
          .map((data) => Movie.fromJson(data))
          .toList(),
      series: (json['results'] as List)
          .map((data) => Series.fromJson(data))
          .toList(),
    );
  }
}