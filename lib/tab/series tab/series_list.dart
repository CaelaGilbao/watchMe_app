import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watch_me/model/series_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SeriesList extends StatefulWidget {
  final String category;
  final List<Series> series;

  const SeriesList({
    Key? key,
    required this.category,
    required this.series,
  }) : super(key: key);

  @override
  _SeriesListState createState() => _SeriesListState();

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
}

class _SeriesListState extends State<SeriesList> {
  List<int> selectedGenres = [];

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
                  Text(
                    widget.category,
                    style: const TextStyle(
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
            _buildGenresFilter(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: _filteredSeries.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Color(0xFF6F6F6F),
                ),
                itemBuilder: (context, index) {
                  var series = _filteredSeries[index];
                  return SeriesTile(series: series);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenresFilter() {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: SeriesList.genreMap.entries
              .map(
                (entry) => Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 2, 5),
                  child: ChoiceChip(
                    label: Text(
                      entry.value,
                      style: const TextStyle(color: Colors.white),
                    ),
                    selected: selectedGenres.contains(entry.key),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          selectedGenres.add(entry.key);
                        } else {
                          selectedGenres.remove(entry.key);
                        }
                      });
                    },
                    backgroundColor: const Color(0xFF24528A),
                    selectedColor: const Color(0xFFFC6736),
                    labelStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  List<Series> get _filteredSeries {
    if (selectedGenres.isEmpty) {
      return widget.series;
    } else {
      return widget.series
          .where((series) => series.genreIds
              .any((genreId) => selectedGenres.contains(genreId)))
          .toList();
    }
  }
}

class SeriesTile extends StatefulWidget {
  final Series series;

  const SeriesTile({
    Key? key,
    required this.series,
  }) : super(key: key);

  @override
  _SeriesTileState createState() => _SeriesTileState();
}

class _SeriesTileState extends State<SeriesTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF021B3A),
      child: Column(
        children: [
          ListTile(
            leading: _buildFavoriteIcon(widget.series.id.toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isExpanded
                    ? const Icon(
                        Icons.arrow_drop_up,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
              ],
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (!_isExpanded)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 250,
                    child: Text(
                      widget.series.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getYear(widget.series.releaseDate),
                    style: const TextStyle(
                      color: Color(0xFF4984CD),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _getGenres(widget.series.genreIds),
                ],
              ),
              leading: SizedBox(
                width: 100,
                height: 150,
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Image.network(
                    widget.series.posterPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          if (_isExpanded) _buildExpandedSeriesDetails(widget.series),
        ],
      ),
    );
  }

  Widget _buildExpandedSeriesDetails(Series series) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            height: 150,
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Image.network(
                series.posterPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  series.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _getYear(series.releaseDate),
                  style: const TextStyle(
                    color: Color(0xFF4984CD),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  series.overview,
                  style: const TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 15),
                _getGenres(series.genreIds),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteIcon(String seriesId) {
    return FutureBuilder<bool>(
      future: _isSeriesFavorite(seriesId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.favorite_border, color: Colors.white);
        } else {
          final bool isFavorite = snapshot.data ?? false;
          return IconButton(
            icon: isFavorite
                ? const Icon(Icons.favorite, color: Colors.red)
                : const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              setState(() {
                if (isFavorite) {
                  _removeFromWatchlist(seriesId);
                } else {
                  _addToWatchlist(seriesId);
                }
              });
            },
          );
        }
      },
    );
  }

  Future<bool> _isSeriesFavorite(String seriesId) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      DatabaseReference watchlistRef = FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(currentUserId)
          .child('watchlist');

      // Use once().then() to get the DataSnapshot from the event
      DataSnapshot snapshot = await watchlistRef
          .child(seriesId)
          .once()
          .then((event) => event.snapshot);

      // Check if the snapshot exists and has a value
      if (snapshot.exists && snapshot.value != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> _addToWatchlist(String seriesId) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      DatabaseReference watchlistRef = FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(currentUserId)
          .child('watchlists');

      await watchlistRef.child(seriesId).set(true);
    }
  }

  Future<void> _removeFromWatchlist(String seriesId) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      DatabaseReference watchlistRef = FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(currentUserId)
          .child('watchlist');

      await watchlistRef.child(seriesId).remove();
    }
  }

  Widget _getGenres(List<int> genreIds) {
    Map<int, String> genreMap = SeriesList.genreMap;
    List<Widget> genreWidgets = [];
    for (int genreId in genreIds) {
      if (genreMap.containsKey(genreId)) {
        genreWidgets.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.fromLTRB(0, 0, 8, 8),
            decoration: BoxDecoration(
              color: const Color(0xFF24528A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              genreMap[genreId]!,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      }
    }
    return Wrap(children: genreWidgets);
  }

  String _getYear(String releaseDate) {
    DateTime dateTime = DateTime.tryParse(releaseDate) ?? DateTime.now();
    String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
    return formattedDate;
  }
}
