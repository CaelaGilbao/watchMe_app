import 'package:flutter/material.dart';
import 'package:watch_me/api/api.dart';
import 'package:watch_me/model/movie_model.dart';
import 'package:watch_me/tab/movie%20tab/movie_list_screen.dart';

class MovieTab extends StatefulWidget {
  const MovieTab({Key? key}) : super(key: key);

  @override
  State<MovieTab> createState() => _MovieTabState();
}

class _MovieTabState extends State<MovieTab> {
  late Future<List<Movie>> upcomingMovies;
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> nowPlayingMovies;
  //late Future<List<Movie>> discoverMovies;

  @override
  void initState() {
    upcomingMovies = Api().getUpcomingMovies();
    popularMovies = Api().getPopularMovies();
    topRatedMovies = Api().getTopRatedMovies();
    nowPlayingMovies = Api().getUpcomingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF021B3A),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        child: ListView(
          children: [
            _buildCategory('Now Playing', nowPlayingMovies, () {
              _navigateToMovieListScreen(
                  context, 'Now Playing', nowPlayingMovies);
            }),
            _buildCategory('Upcoming', upcomingMovies, () {
              _navigateToMovieListScreen(context, 'Upcoming', upcomingMovies);
            }),
            _buildCategory('Popular', popularMovies, () {
              _navigateToMovieListScreen(context, 'Popular', popularMovies);
            }),
            _buildCategory('Top Rated', topRatedMovies, () {
              _navigateToMovieListScreen(context, 'Top Rated', topRatedMovies);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(
      String categoryName, Future<List<Movie>> movies, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap, // Invoke the onTap callback when tapped
        child: Container(
          height: 150,
          width: 200,
          decoration: BoxDecoration(
            color: Color(0xFF153660),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$categoryName',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              FutureBuilder<List<Movie>>(
                future: movies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    int movieCount = snapshot.data!.length;
                    return Text(
                      '$movieCount movies',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4984CD),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMovieListScreen(BuildContext context, String category,
      Future<List<Movie>> moviesFuture) async {
    List<Movie> movies = await moviesFuture; // Wait for the future to complete
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MovieListScreen(category: category, movies: movies),
      ),
    );
  }
}
