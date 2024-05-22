import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class WatchlistHelper {
  static Future<bool> isItemFavorite(
    String itemId,
  ) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DatabaseReference watchlistsRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId)
          .child('watchlists');

      DataSnapshot snapshot = await watchlistsRef.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> watchlists =
            snapshot.value as Map<dynamic, dynamic>;
        for (var watchlist in watchlists.values) {
          if (watchlist['mediaList'] != null &&
              watchlist['mediaList'][itemId] != null) {
            return true;
          }
        }
      }
    }
    return false;
  }

  static Future<void> addToWatchlist(
    String userId,
    String watchlistId,
    String itemId,
    String title,
    String overview,
    String posterPath,
    String releaseDate,
    List<int> genreIds,
    String type,
  ) async {
    DatabaseReference itemRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userId)
        .child('watchlists')
        .child(watchlistId)
        .child('mediaList')
        .child(itemId);

    await itemRef.set({
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'releaseDate': releaseDate,
      'genreIds': genreIds,
      'type': type,
    });
  }

  static Future<void> removeFromWatchlist(String itemId) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    DatabaseReference watchlistsRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userId)
        .child('watchlists');

    DataSnapshot snapshot = await watchlistsRef.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> watchlists =
          snapshot.value as Map<dynamic, dynamic>;
      for (var watchlistKey in watchlists.keys) {
        DatabaseReference itemRef =
            watchlistsRef.child(watchlistKey).child('mediaList').child(itemId);
        await itemRef.remove();
      }
    }
    print('Item removed from watchlist successfully');
  }

  static Future<List<String>> getWatchlists(String userId) async {
    DatabaseReference watchlistsRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userId)
        .child('watchlists');

    DataSnapshot snapshot = await watchlistsRef.get();

    if (snapshot.exists) {
      Map<dynamic, dynamic> watchlists =
          snapshot.value as Map<dynamic, dynamic>;
      return watchlists.keys.cast<String>().toList();
    } else {
      return [];
    }
  }
}
