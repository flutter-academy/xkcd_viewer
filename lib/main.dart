import 'package:flutter/material.dart';
import 'package:xkcd_viewer/comic.dart';
import 'package:xkcd_viewer/widgets.dart';
import 'package:xkcd_viewer/comics_parser.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xkcd Viewer',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ComicsParser.getComics(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              return ComicListPage(snapshot.data);
            }
            return Center(
              child: Text(
                'Failed to load comics.',
                style: TextStyle(color: Colors.red),
              ),
            );
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return Center(
              child: Text(
                'Invalid internal status.',
                style: TextStyle(color: Colors.red),
              ),
            );
        }
      },
    );
  }
}

class ComicListPage extends StatelessWidget {
  ComicListPage(this._comics);

  final List<Comic> _comics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xkcd Viewer'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: _comics.length,
            itemBuilder: (context, index) => ComicItemWidget(_comics, index)),
      ),
    );
  }
}
