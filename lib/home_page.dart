import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'moviedetail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TMDB tmdbWithCustomLogs;
  late Future<Map<dynamic, dynamic>> nowPlayingMovies;
  late Future<Map<dynamic, dynamic>> popularMovies;
  late Future<Map<dynamic, dynamic>> topRatedMovies;

  @override
  void initState() {
    super.initState();
    tmdbWithCustomLogs = TMDB(
      ApiKeys('7b9f27a2dc328bb6cb5177678ae8c959',
          'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3YjlmMjdhMmRjMzI4YmI2Y2I1MTc3Njc4YWU4Yzk1OSIsInN1YiI6IjY1YzIwOTNiOGU4ZDMwMDE2Mjc3ZWZkNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.WlkvgjwIWu2Dbsxv5offtd7l1B00kdoAYqCvwH56k9o'),
    );
    // assign the futures
    nowPlayingMovies = fetchNowPlayingMovies();
    popularMovies = fetchPopularMovies();
    topRatedMovies = fetchTopRatedMovies();
  }

  Future<Map<dynamic, dynamic>> fetchNowPlayingMovies() async {
    var result = await tmdbWithCustomLogs.v3.movies.getNowPlaying();
    //var result = await tmdbWithCustomLogs.v3.trending.getTrending();
    return result as Map<dynamic, dynamic>;
  }

  Future<Map<dynamic, dynamic>> fetchPopularMovies() async {
    var result = await tmdbWithCustomLogs.v3.movies.getPopular();
    return result as Map<dynamic, dynamic>;
  }

  Future<Map<dynamic, dynamic>> fetchTopRatedMovies() async{
    var result = await tmdbWithCustomLogs.v3.movies.getTopRated();
    return result as Map<dynamic, dynamic>;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Categories')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildMovieCategory(context, 'Now Playing', nowPlayingMovies),
            buildMovieCategory(context, 'Top Rated', topRatedMovies),
            buildMovieCategory(context, 'Popular', popularMovies),
          ],
        ),
      ),
    );
  }

  Widget buildMovieCategory(BuildContext context, String title, Future<Map<dynamic, dynamic>> moviesFuture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: Theme.of(context).textTheme.headline6),
        ),
        FutureBuilder<Map<dynamic, dynamic>>(
          future: moviesFuture, // Pass the Future directly
          builder: (BuildContext context, AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List movies = snapshot.data?['results'] ?? [];
              return Container(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return InkWell( // Wrap the Container with InkWell
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(movie: movie),
                        ),
                      ),
                      child: Container(
                        width: 130,
                        margin: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                height: 180,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie['title'] ?? 'No Title',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    movie['release_date'] ?? 'No Release Date',
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('No data available.'));
            }
          },
        ),
      ],
    );
  }
}
