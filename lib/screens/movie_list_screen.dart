import 'package:flutter/material.dart';
import 'package:watch_me/model/movie_model.dart';
import 'package:watch_me/screens/media_list_screen.dart'; 

class MovieListScreen extends StatelessWidget {
  final String category;
  final List<Movie> movies;
  final String searchQuery;
  final Map<int, String> genreMap;

  MovieListScreen({
    Key? key,
    required this.category,
    required this.movies,
    required this.searchQuery,
    required this.genreMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaListScreen<Movie>(
      category: category,
      items: movies,
      searchQuery: searchQuery,
      genreMap: genreMap,
      getTitle: (item) => item.title,
      getOverview: (item) => item.overview,
      getPosterPath: (item) => 'https://image.tmdb.org/t/p/w500${item.posterPath}',
      getReleaseDate: (item) => item.releaseDate,
      getGenreIds: (item) => item.genreIds,
      getId: (item) => item.id.toString(),
    );
  }
}
