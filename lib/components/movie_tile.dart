import 'package:flutter/material.dart';
import 'package:watch_me/model/movie_model.dart';
import 'package:watch_me/screens/media_list_screen.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final Map<int, String> genreMap;

  const MovieTile({
    Key? key,
    required this.movie,
    required this.genreMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaTile(
      item: movie,
      getTitle: (item) => item.title,
      getOverview: (item) => item.overview,
      getPosterPath: (item) => item.posterPath,
      getReleaseDate: (item) => item.releaseDate,
      getGenreIds: (item) => item.genreIds,
      getId: (item) => item.id.toString(),
      genreMap: genreMap,
    );
  }
}
