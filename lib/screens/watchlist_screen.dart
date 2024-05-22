import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:watch_me/components/media_tile.dart';
import 'package:watch_me/screens/search_result_screen.dart';

class WatchlistScreen extends StatefulWidget {
  final String watchlistId;

  WatchlistScreen({required this.watchlistId});

  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List<Map<dynamic, dynamic>> movies = [];
  String watchlistName = '';

  @override
  void initState() {
    super.initState();
    _loadWatchlistDetails();
  }

  Future<void> _loadWatchlistDetails() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DatabaseReference watchlistRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId)
          .child('watchlists')
          .child(widget.watchlistId);

      DataSnapshot snapshot = await watchlistRef.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          print('Watchlist Data: $data'); // Print watchlist data
          setState(() {
            watchlistName = data['name'] ?? '';
            movies = (data['mediaList'] as Map<dynamic, dynamic>?)
                    ?.entries
                    .map((entry) => {
                          'id': entry.key,
                          'title': entry.value['title'] ?? '', // Update 'title'
                          'poster': entry.value['posterPath'] ??
                              '', // Correct 'posterPath'
                          'overview': entry.value['overview'] ?? '',
                          'releaseDate': entry.value['releaseDate'] ?? '',
                          'genreIds': entry.value['genreIds'] ?? [],
                        })
                    .toList() ??
                [];
            print('Movies: $movies'); // Print movies list
          });
        }
      }
    }
  }

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
                    watchlistName,
                    style: const TextStyle(
                      color: Color(0xFFFC6736),
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 40), // Adjust the width as needed
                ],
              ),
            ),
            Expanded(
              child: movies.isEmpty
                  ? Center(
                      child: Text(
                        'No movies or series added.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: movies.length * 2 - 1,
                      itemBuilder: (context, index) {
                        if (index.isOdd) {
                          return Divider(
                            color: Color(0xFF6F6F6F),
                            thickness: 1,
                            height: 0,
                          );
                        }
                        var movieIndex = index ~/ 2;
                        var movie = movies[movieIndex];
                        return MediaTile(
                          item: movie,
                          getTitle: (item) => item['title'].toString(),
                          getOverview: (item) => item['overview'].toString(),
                          getPosterPath: (item) => item['poster'].toString(),
                          getReleaseDate: (item) =>
                              item['releaseDate'].toString(),
                          getGenreIds: (item) =>
                              List<int>.from(item['genreIds']),
                          getId: (item) => item['id'].toString(),
                          genreMap: SearchResultScreen.genreMap,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
