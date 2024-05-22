import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MediaListScreen<T> extends StatefulWidget {
  final String category;
  final List<T> items;
  final String searchQuery;
  final Map<int, String> genreMap;
  final String Function(T) getTitle;
  final String Function(T) getOverview;
  final String Function(T) getPosterPath;
  final String Function(T) getReleaseDate;
  final List<int> Function(T) getGenreIds;
  final String Function(T) getId;

  MediaListScreen({
    required this.category,
    required this.items,
    required this.searchQuery,
    required this.genreMap,
    required this.getTitle,
    required this.getOverview,
    required this.getPosterPath,
    required this.getReleaseDate,
    required this.getGenreIds,
    required this.getId,
  });

  @override
  _MediaListScreenState<T> createState() => _MediaListScreenState<T>();
}

class _MediaListScreenState<T> extends State<MediaListScreen<T>> {
  List<int> selectedGenres = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF021B3A),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildGenresFilter(),
            Expanded(child: _buildMediaList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
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
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildGenresFilter() {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.genreMap.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 2, 5),
              child: ChoiceChip(
                label: Text(entry.value,
                    style: const TextStyle(color: Colors.white)),
                selected: selectedGenres.contains(entry.key),
                onSelected: (isSelected) => setState(() {
                  isSelected
                      ? selectedGenres.add(entry.key)
                      : selectedGenres.remove(entry.key);
                }),
                backgroundColor: const Color(0xFF24528A),
                selectedColor: const Color(0xFFFC6736),
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
                visualDensity: VisualDensity.compact,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMediaList() {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 10),
      itemCount: _filteredItems.length,
      separatorBuilder: (context, index) =>
          const Divider(color: Color(0xFF6F6F6F)),
      itemBuilder: (context, index) {
        var item = _filteredItems[index];
        return MediaTile<T>(
          item: item,
          getTitle: widget.getTitle,
          getOverview: widget.getOverview,
          getPosterPath: widget.getPosterPath,
          getReleaseDate: widget.getReleaseDate,
          getGenreIds: widget.getGenreIds,
          getId: widget.getId,
          genreMap: widget.genreMap,
        );
      },
    );
  }

  List<T> get _filteredItems {
    if (selectedGenres.isEmpty) {
      return widget.items;
    } else {
      return widget.items
          .where((item) => widget
              .getGenreIds(item)
              .any((genreId) => selectedGenres.contains(genreId)))
          .toList();
    }
  }
}

class MediaTile<T> extends StatefulWidget {
  final T item;
  final String Function(T) getTitle;
  final String Function(T) getOverview;
  final String Function(T) getPosterPath;
  final String Function(T) getReleaseDate;
  final List<int> Function(T) getGenreIds;
  final String Function(T) getId;
  final Map<int, String> genreMap;

  const MediaTile({
    Key? key,
    required this.item,
    required this.getTitle,
    required this.getOverview,
    required this.getPosterPath,
    required this.getReleaseDate,
    required this.getGenreIds,
    required this.getId,
    required this.genreMap,
  }) : super(key: key);

  @override
  _MediaTileState<T> createState() => _MediaTileState<T>();
}

class _MediaTileState<T> extends State<MediaTile<T>> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF021B3A),
      child: Column(
        children: [
          ListTile(
            leading: _buildHeartIcon(widget.getId(widget.item)),
            trailing: Icon(
                _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.white),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            contentPadding: EdgeInsets.zero,
          ),
          _isExpanded ? _buildExpandedDetails() : _buildCollapsedDetails(),
        ],
      ),
    );
  }

  Widget _buildCollapsedDetails() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.getTitle(widget.item),
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getYear(widget.getReleaseDate(widget.item)),
            style: const TextStyle(
              color: Color(0xFF4984CD),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          _getGenres(widget.getGenreIds(widget.item)),
        ],
      ),
      leading: SizedBox(
        width: 100,
        height: 150,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: Image.network(widget.getPosterPath(widget.item),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildExpandedDetails() {
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
              child: Image.network(widget.getPosterPath(widget.item),
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.getTitle(widget.item),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _getYear(widget.getReleaseDate(widget.item)),
                  style: const TextStyle(
                    color: Color(0xFF4984CD),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.getOverview(widget.item),
                  style: const TextStyle(
                      color: Colors.white, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 15),
                _getGenres(widget.getGenreIds(widget.item)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGenres(List<int> genreIds) {
    List<String> genreNames =
        genreIds.map((id) => widget.genreMap[id]!).toList();
    return Text(
      genreNames.join(', '),
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
        fontSize: 12,
      ),
    );
  }

  String _getYear(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat.y().format(parsedDate);
  }

  Widget _buildHeartIcon(String itemId) {
    return GestureDetector(
      onTap: () => _showWatchlistDialog(itemId),
      child: const Icon(Icons.favorite_border, color: Colors.white),
    );
  }

  Future<void> _showWatchlistDialog(String itemId) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    List<String> watchlists = await _getWatchlists(userId);
    String? selectedWatchlist = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add to Watchlist'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: watchlists
                .map((watchlist) => ListTile(
                      title: Text(watchlist),
                      onTap: () => Navigator.pop(context, watchlist),
                    ))
                .toList(),
          ),
        );
      },
    );

    if (selectedWatchlist != null) {
      await _addToWatchlist(userId, selectedWatchlist, itemId);
    }
  }

  Future<List<String>> _getWatchlists(String userId) async {
    DatabaseReference watchlistsRef =
        FirebaseDatabase.instance.ref().child('watchlists').child(userId);
    DataSnapshot snapshot = await watchlistsRef.get();
    if (snapshot.exists) {
      return (snapshot.value as Map<dynamic, dynamic>)
          .keys
          .map((key) => key.toString())
          .toList();
    }
    return [];
  }

  Future<void> _addToWatchlist(
      String userId, String watchlist, String itemId) async {
    DatabaseReference watchlistRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userId)
        .child('watchlists')
        .child(watchlist)
        .child(itemId);
    await watchlistRef.set(true);
  }
}
