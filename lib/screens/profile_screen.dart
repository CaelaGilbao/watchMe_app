import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:watch_me/components/navigation_menu.dart';
import 'package:watch_me/functions/bottom_nav_bar_bloc.dart';
import 'package:watch_me/screens/edit_user_info.dart';
import 'package:watch_me/screens/watchlist_screen.dart';
import 'package:watch_me/screens/welcome.dart';
import 'dart:io'; // Importing dart:io for File class

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final BottomNavBarBloc _bottomNavBarBloc = BottomNavBarBloc();
  String? displayName;
  String? bio;
  String? photoURL;
  List<Map<dynamic, dynamic>> watchlists = [];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadWatchlists();
  }

  Future<void> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(user.uid);
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          setState(() {
            displayName =
                data['name'] ?? ''; // Load display name or empty string
            bio = data['bio'] ?? ''; // Load bio or empty string
            photoURL = data['photoURL']; // Load photoURL
          });
        }
      }
    }
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

  Future<void> _addNewWatchlist(BuildContext context) async {
    TextEditingController watchlistNameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                        DatabaseReference watchlistsRef = FirebaseDatabase
                            .instance
                            .ref()
                            .child('users')
                            .child(userId)
                            .child('watchlists');
                        await watchlistsRef
                            .child(watchlistName)
                            .set({'name': watchlistName, 'movies': {}});

                        // Refresh the watchlists by reloading them
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF021B3A),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Color(0xFFFC6736),
                      Color(0xFF021B3A),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _signOut(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Add space between elements
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: _getImageProvider(photoURL),
                            ),
                          ),
                          const SizedBox(
                              width: 25), // Add space between elements
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '$displayName',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      print(
                                          "Edit icon tapped"); // Add this line for debugging
                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user != null) {
                                        DatabaseReference userRef =
                                            FirebaseDatabase.instance
                                                .ref()
                                                .child('users')
                                                .child(user.uid);
                                        DataSnapshot snapshot =
                                            await userRef.get();

                                        if (snapshot.exists) {
                                          Map<dynamic, dynamic>? data = snapshot
                                              .value as Map<dynamic, dynamic>?;
                                          if (data != null) {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfileScreen(
                                                  name: data['name'] ?? '',
                                                  age: data['age']?.toString(),
                                                  birthday:
                                                      data['birthday'] ?? '',
                                                  gender: data['gender'] ?? '',
                                                  bio: data['bio'] ?? '',
                                                  profileImage: photoURL != null
                                                      ? photoURL
                                                      : null,
                                                  onSave: (name,
                                                      age,
                                                      birthday,
                                                      gender,
                                                      bio,
                                                      profileImage) {
                                                    setState(() {
                                                      displayName = name;
                                                      this.bio = bio;
                                                      photoURL =
                                                          profileImage?.path;
                                                    });
                                                  },
                                                ),
                                              ),
                                            );
                                            _loadUserProfile();
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 1),
                              Text(
                                'Bio',
                                style: const TextStyle(
                                  color: Color.fromARGB(178, 255, 255, 255),
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                  height: 5), // Add space between elements
                              SizedBox(
                                width: 200,
                                child: Text(
                                  '$bio',
                                  style: const TextStyle(
                                    color: Color.fromARGB(178, 255, 255, 255),
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 10, 0, 0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                child: Text(
                  'Watchlists',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              itemCount: watchlists.length,
              itemBuilder: (context, index) {
                var watchlist = watchlists[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0), // Add space between containers
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WatchlistScreen(
                            watchlistId: watchlist['id'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFF153660),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                watchlist['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Total Movies: ${watchlist['totalMovies']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            onSelected: (value) {
                              if (value == 'delete') {
                                _deleteWatchlist(watchlist['id']);
                              } else if (value == 'rename') {
                                _renameWatchlist(
                                    watchlist['id'], watchlist['name']);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'rename',
                                  child: Text(
                                    'Rename',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ];
                            },
                            color: const Color(0xFF153660),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewWatchlist(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFFC6736),
      ),
      bottomNavigationBar: StreamBuilder<int>(
        stream: _bottomNavBarBloc.indexStream,
        builder: (context, snapshot) {
          return BottomNavBar(
            currentIndex: snapshot.data ?? 2,
            onTap: (index) {
              _bottomNavBarBloc.updateIndex(index);
              if (index == 0) {
                Navigator.pushReplacementNamed(context, 'home');
              } else if (index == 1) {
                Navigator.pushReplacementNamed(context, 'search');
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteWatchlist(String watchlistId) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DatabaseReference watchlistRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userId)
          .child('watchlists')
          .child(watchlistId);
      await watchlistRef.remove();
      await _loadWatchlists();
    }
  }

  Future<void> _renameWatchlist(String watchlistId, String currentName) async {
    TextEditingController renameController =
        TextEditingController(text: currentName);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Watchlist'),
          content: TextField(
            controller: renameController,
            decoration: const InputDecoration(hintText: 'Enter new name'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Rename'),
              onPressed: () async {
                String newName = renameController.text;
                if (newName.isNotEmpty) {
                  String? userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId != null) {
                    DatabaseReference watchlistRef = FirebaseDatabase.instance
                        .ref()
                        .child('users')
                        .child(userId)
                        .child('watchlists')
                        .child(watchlistId);
                    await watchlistRef.update({'name': newName});
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

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => Welcome()), // Navigate to WelcomeScreen
      (route) => false, // Pop all routes until this point
    );
  }

  ImageProvider<Object> _getImageProvider(String? photoURL) {
    if (photoURL == null || photoURL.isEmpty) {
      return const AssetImage('assets/images/default_profile.jpg');
    } else if (photoURL.startsWith('http')) {
      return NetworkImage(photoURL);
    } else {
      return FileImage(File(photoURL));
    }
  }
}
