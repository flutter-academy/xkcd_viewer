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
        primarySwatch: Colors.lime,
      ),
      home: HomePage(),
      onGenerateRoute: (settings) {
        if (settings.name.startsWith('/comic')) {
          return MaterialPageRoute(
              builder: (context) =>
                  ComicDetailsPage(settings.name.substring('/comic'.length)));
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var parser = new ComicsParser();
    return FutureBuilder(
      future: parser.getComics(),
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
  ComicListPage(this.comics);

  final List<Comic> comics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xkcd Viewer'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: comics.length,
            itemBuilder: (context, index) => ComicItemWidget(comics[index])),
      ),
    );
  }
}

class ComicDetailsPage extends StatelessWidget {
  ComicDetailsPage(this._comicHref);

  final String _comicHref;

  @override
  Widget build(BuildContext context) {
    var parser = new ComicsParser();
    return FutureBuilder(
      future: parser.getComicDetails(this._comicHref),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData) {
              return ComicDetailsWidget(snapshot.data);
            }
            return Center(
              child: Text(
                'Failed to load comic.',
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
