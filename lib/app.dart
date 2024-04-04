import 'package:flutter/material.dart';
import 'package:movieapp_assignment/collection_page.dart';
import 'package:movieapp_assignment/home_page.dart';
import 'package:movieapp_assignment/search_page.dart';
import 'package:movieapp_assignment/favorite_page.dart';
import 'package:movieapp_assignment/moviedetail_page.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PURE FLIX',
      theme: ThemeData(
        brightness: Brightness.dark, // Using dark theme
      ),
      home: MainAppWrapper(), // This is the entry point of the app
    );
  }
}

class MainAppWrapper extends StatefulWidget {
  const MainAppWrapper({Key? key}) : super(key: key);

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {
  int _selectedIndex = 0;

  // all page classes
  final List<Widget> _pageOptions = [
    HomePage(), // Widget for the content of home screen
    CollectionPage(), // Collection page widget
    SearchPage(), // Search page widget
    FavoritePage(), // Favorite page widget
    MovieDetailPage(movie: null,),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pure Flix'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: IndexedStack( // IndexedStack keeps the state of each page as is when switching between tabs
        index: _selectedIndex,
        children: _pageOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video),
            label: 'Collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outlined),
            label: 'Favorite',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        backgroundColor: Colors.black54,
        onTap: _onItemTapped,
      ),
    );
  }
}
