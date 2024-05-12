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

  Future<List<String>> getSearchSuggestions(String query) async {
    final List<String> suggestions = [];

    suggestions.addAll(await searchMovies(query));
    suggestions.addAll(await searchSeries(query));

    // Return unique suggestions
    return suggestions.toSet().toList();
  }

  Future<List<String>> searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      // Extract titles from movie objects
      final List<String> titles =
          data.map((movie) => Movie.fromMap(movie).title).toList();
      return titles;
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<List<String>> searchSeries(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/tv?api_key=$apiKey&query=$query'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      // Extract names from series objects
      final List<String> names =
          data.map((series) => Series.fromMap(series).title).toList();
      return names;
    } else {
      throw Exception('Failed to search series');
    }
  }

  //Movies
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

  //Series
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
