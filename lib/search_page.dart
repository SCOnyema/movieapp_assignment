import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TMDB tmdbWithCustomLogs;
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    tmdbWithCustomLogs = TMDB(
      ApiKeys('7b9f27a2dc328bb6cb5177678ae8c959', 'your-access-token'),
    );
  }



  @override
  Widget build(BuildContext context) {
    return const Text('Search page');
  }
}
