import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TMDB tmdbWithCustomLogs;
  late Future<List<dynamic>> searchResults;
  late Future<List<dynamic>> recommendations;
  late Future<List<dynamic>> watchlist;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tmdbWithCustomLogs = TMDB(
      ApiKeys('7b9f27a2dc328bb6cb5177678ae8c959',
          'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3YjlmMjdhMmRjMzI4YmI2Y2I1MTc3Njc4YWU4Yzk1OSIsInN1YiI6IjY1YzIwOTNiOGU4ZDMwMDE2Mjc3ZWZkNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.WlkvgjwIWu2Dbsxv5offtd7l1B00kdoAYqCvwH56k9o'),
    );
    // Initialize with empty search results and fetch recommendations and watchlist
    searchResults = Future.value([]);
    recommendations = fetchRecommendations();
    watchlist = fetchWatchlist();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchRecommendations() async {
    // Fetch recommendations (For You section)
    // This is just an example, you need to implement the logic based on your API and what "For You" means
    final Map<dynamic, dynamic> result = await tmdbWithCustomLogs.v3.movies.getPopular();
    return result['results'];
  }

  Future<List<dynamic>> fetchWatchlist() async {
    // Fetch watchlist (Watchlist section)
    // Replace this with the logic to fetch the user's watchlist
    final Map<dynamic, dynamic> result = await tmdbWithCustomLogs.v3.movies.getUpcoming();
    return result['results'];
  }

  Future<List<dynamic>> fetchSearchResults(String query) async {
    // Fetch search results
    final Map<dynamic, dynamic> result = await tmdbWithCustomLogs.v3.search.queryMovies(query);
    return result['results'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies, TV Series and More...'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onSubmitted: (query) {
                setState(() {
                  searchResults = fetchSearchResults(query);
                });
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            buildSection(context, 'Search Results', searchResults),
          buildSection(context, 'For You', recommendations),
          buildSection(context, 'Watchlist', watchlist),
          // Display search results if there is a search query
          /*if (_searchController.text.isNotEmpty)
            buildSection(context, 'Search Results', searchResults),*/
        ],
      ),
    );
  }
}

Widget buildSection(BuildContext context, String title, Future<List<dynamic>> future){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(title, style: Theme.of(context).textTheme.headline6),
      ),
      FutureBuilder<List<dynamic>>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return Container(
              height: 200, // Adjust based on your styling
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  final movie = snapshot.data![index];
                  return Container(
                    width: 130,
                    margin: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          movie['title'] ?? 'No Title',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Text for movie release date
                        Text(
                          movie['release_date'] ?? 'No Release Date',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('Nothing to display here.'));
          }
        },
      ),
    ],
  );
}
