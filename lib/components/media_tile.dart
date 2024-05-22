import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watch_me/screens/search_result_screen.dart';
import 'package:watch_me/tab/watchlist_helper.dart';

class MediaTile extends StatefulWidget {
  final dynamic item;
  final String Function(dynamic) getTitle;
  final String Function(dynamic) getOverview;
  final String Function(dynamic) getPosterPath;
  final String Function(dynamic) getReleaseDate;
  final List<int> Function(dynamic) getGenreIds;
  final String Function(dynamic) getId;
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
  _MediaTileState createState() => _MediaTileState();
}

class _MediaTileState extends State<MediaTile> {
  bool _isExpanded = false;
  bool _isAddedToWatchlist = false;
  List<Map<dynamic, dynamic>> watchlists = [];

  @override
  void initState() {
    super.initState();
    _initializeWatchlistStatus();
  }

  Future<void> _initializeWatchlistStatus() async {
    bool isFavorite =
        await WatchlistHelper.isItemFavorite(widget.getId(widget.item));
    setState(() {
      _isAddedToWatchlist = isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF021B3A),
      child: Column(
        children: [
          ListTile(
            leading: _buildHeartIcon(widget.getId(widget.item)),
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
          Container(
            width: 230,
            child: Text(
              widget.getTitle(widget.item),
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
    Map<int, String> genreMap = SearchResultScreen.genreMap;
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

    return Wrap(
      children: genreWidgets,
    );
  }

  String _getYear(String releaseDate) {
    if (releaseDate.isEmpty) {
      return '';
    }
    DateTime date = DateTime.parse(releaseDate);
    return DateFormat('yyyy').format(date);
  }

  Widget _buildHeartIcon(String itemId) {
    return GestureDetector(
      onTap: () async {
        if (_isAddedToWatchlist) {
          // If already added, ask for confirmation to remove
          bool confirmRemove = await _showRemoveConfirmationDialog(context);
          if (confirmRemove) {
            await WatchlistHelper.removeFromWatchlist(itemId);
            setState(() {
              _isAddedToWatchlist = false;
            });
          }
        } else {
          // If not added, show watchlist selection dialog
          await _showWatchlistSelectionDialog(context, itemId);
        }
      },
      child: Icon(
        _isAddedToWatchlist ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
    );
  }

  Future<void> _showWatchlistSelectionDialog(
      BuildContext context, String itemId) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    await _loadWatchlists(); // Load the watchlists before showing the dialog

    String? selectedWatchlist = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Watchlist'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      await _addNewWatchlist(context);
                      setState(
                          () {}); // Update the state to reload the watchlists
                    },
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: watchlists.map((watchlist) {
                    return ListTile(
                      title: Text(watchlist['name']),
                      onTap: () => Navigator.pop(context, watchlist['id']),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );

    if (selectedWatchlist != null) {
      await WatchlistHelper.addToWatchlist(
        userId,
        selectedWatchlist,
        itemId,
        widget.getTitle(widget.item),
        widget.getOverview(widget.item),
        widget.getPosterPath(widget.item),
        widget.getReleaseDate(widget.item),
        widget.getGenreIds(widget.item),
        'media', // Assuming you want to add as media type
      );
      setState(() {
        _isAddedToWatchlist = true;
      });
    }
  }

  Future<void> _addNewWatchlist(BuildContext context) async {
    TextEditingController watchlistNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Watchlist'),
          content: TextField(
            controller: watchlistNameController,
            decoration: InputDecoration(hintText: 'Enter watchlist name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () async {
                String watchlistName = watchlistNameController.text;
                if (watchlistName.isNotEmpty) {
                  String? userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId != null) {
                    DatabaseReference watchlistsRef = FirebaseDatabase.instance
                        .ref()
                        .child('users')
                        .child(userId)
                        .child('watchlists');
                    await watchlistsRef.child(watchlistName).set({
                      'name': watchlistName,
                      'movies': {},
                    });

                    // Reload the watchlists and close the new watchlist dialog
                    await _loadWatchlists();
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadWatchlists() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DatabaseReference watchlistsRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId)
          .child('watchlists');
      DataSnapshot snapshot = await watchlistsRef.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          setState(() {
            watchlists = data.entries.map((entry) {
              int totalMovies =
                  (entry.value['mediaList'] as Map<dynamic, dynamic>?)
                          ?.length ??
                      0;
              return {
                'id': entry.key,
                'name': entry.value['name'],
                'totalMovies': totalMovies
              };
            }).toList();
          });
        }
      }
    }
  }

  Future<bool> _showRemoveConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Remove from Watchlist'),
              content: const Text(
                  'Are you sure you want to remove this item from your watchlist?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Remove'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
