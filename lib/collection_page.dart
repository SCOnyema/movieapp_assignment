import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tvshowdetail_page.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final String _apiKey = '7b9f27a2dc328bb6cb5177678ae8c959';
  Map<String, Future<List<dynamic>>> tvShowsByGenre = {};

  @override
  void initState() {
    super.initState();

    var genres = {
      'Action & Adventure': 10759,
      'Reality': 10764,
      'Animation': 16,
      'Comedy': 35,
      'Kids': 10762,
      'Documentary': 99,
      'Sci-Fi & Fantansy': 10765,
      'Mystery': 9648,
    };

    genres.forEach((genreName, genreId) {
      tvShowsByGenre[genreName] = fetchTVShowsByGenre(genreId);
    });
  }

  Future<List<dynamic>> fetchTVShowsByGenre(int genreId) async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/discover/tv?api_key=$_apiKey&with_genres=$genreId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load tv shows for genre $genreId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Shows Collections'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: tvShowsByGenre.entries.map((entry) {
            return buildTVShowCategory(context, entry.key, entry.value);
          }).toList(),
        ),
      ),
    );
  }

  Widget buildTVShowCategory(BuildContext context, String title, Future<List<dynamic>> tvShowsFuture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: Theme.of(context).textTheme.headline6),
        ),
        FutureBuilder<List<dynamic>>(
          future: tvShowsFuture,
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final tvShow = snapshot.data![index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TVShowDetailPage(tvShow: tvShow),
                          ),
                        );
                      },
                      child: Container(
                        width: 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${tvShow['poster_path']}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                tvShow['name'] ?? 'No Title',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
  }}
