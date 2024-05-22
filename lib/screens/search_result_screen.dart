import 'package:flutter/material.dart';
import 'package:watch_me/components/media_tile.dart';
import 'package:watch_me/model/movie_model.dart';
import 'package:watch_me/model/series_model.dart';

class SearchResultScreen extends StatelessWidget {
  final String searchQuery;
  final List<Movie> movies;
  final List<Series> series;

  const SearchResultScreen({
    Key? key,
    required this.searchQuery,
    required this.movies,
    required this.series,
  }) : super(key: key);

  static const Map<int, String> genreMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Science Fiction',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF021B3A),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Text(
                    'Search Results',
                    style: TextStyle(
                      color: Color(0xFFFC6736),
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Text(
                'Results for "$searchQuery"',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  if (movies.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 10, 5),
                      child: Text(
                        'Movies',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.separated(
                      padding: EdgeInsets.all(8),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: movies.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Color(0xFF6F6F6F),
                      ),
                      itemBuilder: (context, index) {
                        return MediaTile(
                          item: movies[index],
                          getTitle: (movie) => movie.title,
                          getOverview: (movie) => movie.overview,
                          getPosterPath: (movie) => movie.posterPath,
                          getReleaseDate: (movie) => movie.releaseDate,
                          getGenreIds: (movie) => movie.genreIds,
                          getId: (movie) => movie.id.toString(),
                          genreMap: genreMap,
                        );
                      },
                    ),
                  ],
                  if (series.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 10, 5),
                      child: Text(
                        'Series',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.separated(
                      padding: EdgeInsets.all(8),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: series.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Color(0xFF6F6F6F),
                      ),
                      itemBuilder: (context, index) {
                        return MediaTile(
                          item: series[index],
                          getTitle: (series) => series.title,
                          getOverview: (series) => series.overview,
                          getPosterPath: (series) => series.posterPath,
                          getReleaseDate: (series) => series.releaseDate,
                          getGenreIds: (series) => series.genreIds,
                          getId: (series) => series.id.toString(),
                          genreMap: genreMap,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
