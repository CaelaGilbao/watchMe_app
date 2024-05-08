import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:watch_me/api/constants.dart';
import 'package:watch_me/model/series_model.dart';
import '../model/movie_model.dart';

class Api {
  //Movies
  final upComingApiUrl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApiUrl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  final topRatedApiUrl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";
  final nowPlayingApiUrl =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey";

  //Series
  final airingTodayApiUrl =
      "https://api.themoviedb.org/3/tv/airing_today?api_key=$apiKey";
  final onTheAirApiUrl =
      "https://api.themoviedb.org/3/tv/on_the_air?api_key=$apiKey";
  final popular2ApiUrl =
      "https://api.themoviedb.org/3/tv/popular?api_key=$apiKey";
  final topRated2ApiUrl =
      "https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey";

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(upComingApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(popularApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(topRatedApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<Movie>> getnowPlayingMovies() async {
    final response = await http.get(Uri.parse(nowPlayingApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  Future<List<Series>> getairingTodaySeries() async {
    final response = await http.get(Uri.parse(airingTodayApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Series> series =
          data.map((series) => Series.fromMap(series)).toList();
      return series;
    } else {
      throw Exception('Failed to load airing today series');
    }
  }

  Future<List<Series>> getonTheAirSeries() async {
    final response = await http.get(Uri.parse(onTheAirApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Series> series =
          data.map((series) => Series.fromMap(series)).toList();
      return series;
    } else {
      throw Exception('Failed to load on the air series');
    }
  }

  Future<List<Series>> getpopular2Series() async {
    final response = await http.get(Uri.parse(popular2ApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Series> series =
          data.map((series) => Series.fromMap(series)).toList();
      return series;
    } else {
      throw Exception('Failed to load popular series');
    }
  }

  Future<List<Series>> gettopRated2Series() async {
    final response = await http.get(Uri.parse(topRated2ApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Series> series =
          data.map((series) => Series.fromMap(series)).toList();
      return series;
    } else {
      throw Exception('Failed to load top rated seriess');
    }
  }
}
