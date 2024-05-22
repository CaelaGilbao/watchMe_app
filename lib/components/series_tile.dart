import 'package:flutter/material.dart';
import 'package:watch_me/model/series_model.dart';
import 'package:watch_me/screens/media_list_screen.dart';
import 'package:watch_me/screens/search_result_screen.dart';

class SeriesTile extends StatelessWidget {
  final Series series;

  const SeriesTile({
    Key? key,
    required this.series,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaTile(
      item: series,
      getTitle: (item) => item.title,
      getOverview: (item) => item.overview,
      getPosterPath: (item) => item.posterPath,
      getReleaseDate: (item) => item.releaseDate,
      getGenreIds: (item) => item.genreIds,
      getId: (item) => item.id.toString(),
      genreMap: SearchResultScreen.genreMap,
    );
  }
}
