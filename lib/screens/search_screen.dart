import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:watch_me/api/api.dart';
import 'package:watch_me/components/navigation_menu.dart';
import 'package:watch_me/functions/bottom_nav_bar_bloc.dart';
import 'package:watch_me/model/movie_model.dart';
//import 'package:watch_me/model/search_result.dart';
import 'package:watch_me/model/series_model.dart';
import 'package:watch_me/screens/search_result_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watch_me/tab/movie%20tab/movie_list.dart';
import 'package:watch_me/tab/series%20tab/series_list.dart';

class SearchScreen extends StatefulWidget {
  final CollectionReference searchHistoryCollection =
      FirebaseFirestore.instance.collection('searchHistory');

  @override
  _SearchScreenState createState() => _SearchScreenState();

  Stream<QuerySnapshot> getSearchHistory(String userId) {
    return searchHistoryCollection
        .doc(userId)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

class SearchHistoryService {
  final CollectionReference searchHistoryCollection =
      FirebaseFirestore.instance.collection('searchHistory');

  Future<void> addSearchHistory(String userId, String query) async {
    try {
      await searchHistoryCollection.doc(userId).collection('history').add({
        'query': query,
        'timestamp': Timestamp.now(),
      });
      print('Added to firebase successfully');
    } catch (e) {
      print('Error adding search history: $e');
    }
  }
}

class _SearchScreenState extends State<SearchScreen> {
  final BottomNavBarBloc _bottomNavBarBloc = BottomNavBarBloc();
  late Future<List<Movie>> upcomingMovies;
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> topRatedMovies;
  late Future<List<Movie>> nowPlayingMovies;
  late Future<List<Series>> airingTodaySeries;
  late Future<List<Series>> onTheAirSeries;
  late Future<List<Series>> popular2Series;
  late Future<List<Series>> topRated2Series;
  late TextEditingController _searchController = TextEditingController();

  late Future<List<String>> searchSuggestions;
  final FocusNode _searchFocusNode = FocusNode();
  late Future<List<String>> searchHistory;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    upcomingMovies = Api().getUpcomingMovies();
    popularMovies = Api().getPopularMovies();
    topRatedMovies = Api().getTopRatedMovies();
    nowPlayingMovies = Api().getUpcomingMovies();
    airingTodaySeries = Api().getAiringTodaySeries();
    onTheAirSeries = Api().getOnTheAirSeries();
    popular2Series = Api().getPopular2Series();
    topRated2Series = Api().getTopRated2Series();
    searchSuggestions = Future.value([]);

    searchHistory = _getSearchHistory(userId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      SearchHistoryService().addSearchHistory(userId, query);

      Api().search(query).then((result) {
        if (result.movies.isNotEmpty || result.series.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultScreen(
                searchQuery: query,
                movies: result.movies,
                series: result.series,
                //category: 'Search Result',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No results found for "$query"')),
          );
        }
      }).catchError((error) {
        print('Error fetching search results: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching search results')),
        );
      });
    }
  }

  void _getSearchSuggestions(String query) {
    if (query.isNotEmpty) {
      setState(() {
        // Update searchSuggestions with new suggestions
        searchSuggestions = Api().getSearchSuggestions(query);
      });
    } else {
      setState(() {
        // Clear search suggestions if the query is empty
        searchSuggestions = Future.value([]);
      });
    }
  }

  Future<List<String>> _getSearchHistory(String userId) async {
    final historySnapshot = await FirebaseFirestore.instance
        .collection('searchHistory')
        .doc(userId)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .get();

    final List<String> history =
        historySnapshot.docs.map((doc) => doc['query'] as String).toList();

    return history;
  }

  void _removeSearchHistoryItem(String item) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final history = await searchHistory;
    widget.searchHistoryCollection
        .doc(userId)
        .collection('history')
        .where('query', isEqualTo: item)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Remove the item from Firestore
        doc.reference.delete();
      });
    }).catchError((error) {
      print('Error removing search history: $error');
    });
    setState(() {
      // Remove the item from the UI
      history.remove(item);
    });
  }

  Widget _buildSearchHistory(List<String> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
              15.0, 0.0, 8.0, 4.0), // Adjust top and bottom padding
          child: Text(
            'Search History',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: history.map((item) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 7, 0, 20),
                child: GestureDetector(
                  onTap: () {
                    _removeSearchHistoryItem(item);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF24528A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSuggestions() {
    return FutureBuilder<List<String>>(
      future: searchSuggestions,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while fetching suggestions
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle error gracefully
          return Text('Error: ${snapshot.error}');
        } else {
          // Display search suggestions as a list view
          final List<String> suggestions = snapshot.data ?? [];
          return suggestions.isEmpty
              ? Container()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Search Suggestions',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: suggestions.length,
                        separatorBuilder: (context, index) =>
                            const Divider(color: Colors.grey),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: ListTile(
                              title: Text(
                                suggestions[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                              onTap: () {
                                // When a suggestion is tapped, update the search query and trigger search
                                _searchController.text = suggestions[index];
                                _handleSearch(suggestions[index]);
                                // Load search history
                                final userId =
                                    FirebaseAuth.instance.currentUser?.uid ??
                                        '';
                                setState(() {
                                  searchHistory = _getSearchHistory(userId);
                                });
                                // Hide the suggestions overlay after selecting a suggestion
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF021B3A),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 140,
            leadingWidth: 300,
            backgroundColor: const Color(0xFF021B3A),
            floating: true,
            pinned: true,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search',
                    style: TextStyle(
                      color: Color(0xFFFC6736),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      filled: true,
                      fillColor: const Color(0xFF153660),
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF8F8F8F)),
                      hintText: 'What do you want to watch?',
                      hintStyle: const TextStyle(
                        color: Color(0xFF8F8F8F),
                        fontFamily: 'Poppins',
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    onChanged: (query) {
                      // Update search suggestions when text field content changes
                      _getSearchSuggestions(query);
                    },
                    onTap: () {
                      // Show search suggestions overlay when text field is tapped
                      /*SearchSuggestionsOverlay.show(
      context,
      _buildSearchSuggestions(),
    );*/
                    },
                    // Listen for the "done" key press event
                    onSubmitted: (query) {
                      // Handle search on submit
                      _handleSearch(query);
                      // Load search history
                      final userId =
                          FirebaseAuth.instance.currentUser?.uid ?? '';
                      setState(() {
                        searchHistory = _getSearchHistory(userId);
                      });
                    },
                  ),
                ],
              ),
            ),
            centerTitle: false,
            expandedHeight: 150.0,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildSearchSuggestions(),
                FutureBuilder<List<String>>(
                  future: searchHistory,
                  builder: (context, snapshot) {
                    print(
                        'Search History Snapshot: ${snapshot.connectionState}');
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Display a loading indicator while fetching search history
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      // Handle error gracefully
                      print('Error fetching search history: ${snapshot.error}');
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Display search history if available
                      List<String> history = snapshot.data ?? [];
                      print('Search History: $history');
                      return _buildSearchHistory(history);
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                  child: Text(
                    'Trending',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      color: Color(0xFF8F8F8F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FutureBuilder<List<Movie>>(
                  future: popularMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // Handle error gracefully
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final List<Movie> movies = snapshot.data ?? [];
                      return CarouselSlider.builder(
                        itemCount: movies.length,
                        options: CarouselOptions(
                          height: 230,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.4,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          pauseAutoPlayOnTouch: true,
                        ),
                        itemBuilder: (context, index, _) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    movies[index].posterPath,
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 200,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          174, 252, 103, 54),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Trending',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Poppins',
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _bottomNavBarBloc.indexStream,
        builder: (context, snapshot) {
          return BottomNavBar(
            currentIndex: snapshot.data ?? 1,
            onTap: (index) {
              _bottomNavBarBloc.updateIndex(index);
              if (index == 0) {
                Navigator.pushReplacementNamed(context, 'home');
              } else if (index == 2) {
                Navigator.pushReplacementNamed(context, 'profile');
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryMovies(
      String categoryName, Future<List<Movie>> movies, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap, // Invoke the onTap callback when tapped
        child: Container(
          height: 120,
          width: 180,
          decoration: BoxDecoration(
            color: const Color(0xFF153660),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$categoryName',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              FutureBuilder<List<Movie>>(
                future: movies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    int movieCount = snapshot.data!.length;
                    return Text(
                      '$movieCount movies',
                      style: const TextStyle(
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

  Widget _buildCategorySeries(
      String categoryName, Future<List<Series>> series, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap, // Invoke the onTap callback when tapped
        child: Container(
          height: 100,
          width: 180,
          decoration: BoxDecoration(
            color: const Color(0xFF153660),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$categoryName',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              FutureBuilder<List<Series>>(
                future: series,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    int movieCount = snapshot.data!.length;
                    return Text(
                      '$movieCount movies',
                      style: const TextStyle(
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
    List<Movie> movies = await moviesFuture;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieList(
          category: category,
          movies: movies,
        ),
      ),
    );
  }

  void _navigateToSeriesListScreen(BuildContext context, String category,
      Future<List<Series>> seriesFuture) async {
    List<Series> series = await seriesFuture;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeriesList(
          category: category,
          series: series,
        ),
      ),
    );
  }
}
