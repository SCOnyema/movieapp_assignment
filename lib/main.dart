import 'package:flutter/material.dart';
import 'app.dart';
import 'search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pure Flix',
      theme: ThemeData.dark().copyWith(
        // Override the dark theme's scaffold background color with black
        scaffoldBackgroundColor: Colors.black,
        // Merge the existing dark text theme with your changes
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white, // Sets the default text color to white
          displayColor: Colors.white, // Sets the display text color to white
        ),
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //logo
            Image.asset(
              'assets/PUREFLIX.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 50), // Adjust as needed
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.purple, // Button background color
                onPrimary: Colors.white, // Text color
              ),
              onPressed: () {
                // Navigate to the HomePage when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => App()),
                );
              },
              child: Text('Start Flixing'),
            ),
          ],
        ),
      ),
    );
  }
}
