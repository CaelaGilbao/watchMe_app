import 'package:flutter/material.dart';
import 'package:watch_me/model/series_model.dart';
import 'package:watch_me/screens/media_list_screen.dart';

class SeriesListScreen extends StatelessWidget {
  final String category;
  final List<Series> series;
  final String searchQuery;
  final Map<int, String> genreMap;

  SeriesListScreen({
    Key? key,
    required this.category,
    required this.series,
    required this.searchQuery,
    required this.genreMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaListScreen<Series>(
      category: category,
      items: series,
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
