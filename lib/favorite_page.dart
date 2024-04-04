import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'moviedetail_page.dart';
import 'tvshowdetail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late DatabaseReference _moviesRef;
  late DatabaseReference _tvShowsRef;

  @override
  void initState() {
    super.initState();
    _moviesRef = FirebaseDatabase.instance.ref('favorites/movies');
    _tvShowsRef = FirebaseDatabase.instance.ref('favorites/tvShows');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Column(
        children: [
          Expanded(
            child: favoritesListWidget(_moviesRef, "movies"),
          ),
          Expanded(
            child: favoritesListWidget(_tvShowsRef, "tvShows"),
          ),
        ],
      ),
    );
  }

  Widget favoritesListWidget(DatabaseReference ref, String type) {
    return StreamBuilder<DatabaseEvent>(
      stream: ref.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading $type favorites"));
        } else if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final Map<dynamic, dynamic> favorites = Map<dynamic, dynamic>.from(snapshot.data!.snapshot.value as Map);
          return ListView(
            children: favorites.entries.map((entry) {
              final favoriteData = entry.value as Map<dynamic, dynamic>;
              return ListTile(
                title: Text(favoriteData['title'] ?? 'No Title'), // Display favorite title
                onTap: () {
                  // Navigate to detail page with full favorite data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => type == "movies"
                          ? MovieDetailPage(movie: favoriteData) // Provide movie detail page with data
                          : TVShowDetailPage(tvShow: favoriteData), // Provide TV show detail page with data
                    ),
                  );
                },
              );
            }).toList(),
          );
        } else {
          return Center(child: Text("No $type favorites added."));
        }
      },
    );
  }
}
