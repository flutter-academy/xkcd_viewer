import 'package:flutter/material.dart';
import 'package:xkcd_viewer/comic.dart';

class ComicItemWidget extends StatelessWidget {
  ComicItemWidget(this._comic);

  final Comic _comic;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        this._comic.title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      leading: SizedBox(
        width: 80,
        child: Text(this._comic.pubDate),
      ),
      onTap: () => Navigator.of(context).pushNamed('/comic${this._comic.href}'),
    );
  }
}

class ComicDetailsWidget extends StatelessWidget {
  ComicDetailsWidget(this._comicDetails);

  final ComicDetails _comicDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._comicDetails.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Image.network(this._comicDetails.imageUrl),
          ],
        ),
      ),
    );
  }
}
