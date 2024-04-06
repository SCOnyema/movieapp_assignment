import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// Displays the details of a movie
class MovieDetailPage extends StatefulWidget {
  final dynamic movie;

  // constructor requires a dynamic object representing the movie details
  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool isFavorite = false; // Initial favorite status
  late DatabaseReference favoritesRef;

  @override
  void initState() {
    super.initState();
    favoritesRef = FirebaseDatabase.instance.ref('favorites/movies');
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      // Logic to be attended to
    });
  }

  @override
  Widget build(BuildContext context) {
    // UI structure of the movie detail
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie['title'] ?? 'Movie Details'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.movie['poster_path'] != null
                ? Image.network(
              'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}',
              fit: BoxFit.cover,
            )
                : Container(
              height: 200,
              child: Center(child: Text('No Image Available')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.movie['title'] ?? 'No Title',
                      style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: toggleFavorite,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.movie['release_date'],
                style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.movie['overview'] ?? 'No Overview',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
