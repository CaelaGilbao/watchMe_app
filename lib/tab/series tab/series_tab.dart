import 'package:flutter/material.dart';
import 'package:watch_me/api/api.dart';
import 'package:watch_me/model/series_model.dart';
import 'package:watch_me/tab/series%20tab/series_list_screen.dart';

class SeriesTab extends StatefulWidget {
  const SeriesTab({Key? key}) : super(key: key);

  @override
  State<SeriesTab> createState() => _SeriesTabState();
}

class _SeriesTabState extends State<SeriesTab> {
  late Future<List<Series>> airingTodaySeries;
  late Future<List<Series>> onTheAirSeries;
  late Future<List<Series>> popular2Series;
  late Future<List<Series>> topRated2Series;

  @override
  void initState() {
    airingTodaySeries = Api().getairingTodaySeries();
    onTheAirSeries = Api().getairingTodaySeries();
    popular2Series = Api().getairingTodaySeries();
    topRated2Series = Api().getairingTodaySeries();

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
            _buildCategory('Airing Today', airingTodaySeries, () {
              _navigateToSeriesListScreen(
                  context, 'Airing Today', airingTodaySeries);
            }),
            _buildCategory('On the Air', onTheAirSeries, () {
              _navigateToSeriesListScreen(
                  context, 'On the Air', onTheAirSeries);
            }),
            _buildCategory('Popular', popular2Series, () {
              _navigateToSeriesListScreen(context, 'Popular', popular2Series);
            }),
            _buildCategory('Top Rated', topRated2Series, () {
              _navigateToSeriesListScreen(
                  context, 'Top Rated', topRated2Series);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(
      String categoryName, Future<List<Series>> series, VoidCallback onTap) {
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
              FutureBuilder<List<Series>>(
                future: series,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    int seriesCount = snapshot.data!.length;
                    return Text(
                      '$seriesCount movies',
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

  void _navigateToSeriesListScreen(BuildContext context, String category,
      Future<List<Series>> seriesFuture) async {
    List<Series> series = await seriesFuture; // Wait for the future to complete
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SeriesListScreen(category: category, series: series),
      ),
    );
  }
}
