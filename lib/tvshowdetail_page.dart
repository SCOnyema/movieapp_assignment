import 'package:flutter/material.dart';

class TVShowDetailPage extends StatefulWidget {
  final dynamic tvShow;

  const TVShowDetailPage({Key? key, required this.tvShow}) : super(key: key);

  @override
  _TVShowDetailPageState createState() => _TVShowDetailPageState();
}

class _TVShowDetailPageState extends State<TVShowDetailPage> {
  bool isFavorite = false; // Initial favorite status

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      // Here, you can add logic to save the favorite status in your database or state management solution
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tvShow['name'] ?? 'TV Show Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.tvShow['backdrop_path'] != null
                ? Image.network(
              'https://image.tmdb.org/t/p/w500${widget.tvShow['backdrop_path']}',
              fit: BoxFit.cover,
            )
                : Container(
              height: 250,
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'No Image Available',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.tvShow['name'] ?? 'No Name',
                      style: Theme.of(context).textTheme.headline5,
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
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'First air date: ${widget.tvShow['first_air_date'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.tvShow['overview'] ?? 'No Overview',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
