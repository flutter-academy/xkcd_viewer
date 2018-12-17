import 'package:flutter/material.dart';
import 'package:xkcd_viewer/comic.dart';
import 'package:xkcd_viewer/comics_parser.dart';
import 'package:photo_view/photo_view.dart';

class ComicItemWidget extends StatelessWidget {
  ComicItemWidget(this._comics, this._index);

  final List<Comic> _comics;
  final int _index;

  @override
  Widget build(BuildContext context) {
    var comic = this._comics[this._index];
    return ListTile(
      title: Text(
        comic.title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      leading: SizedBox(
        width: 80,
        child: Text(comic.pubDate),
      ),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ComicViewPage(this._comics, this._index))),
    );
  }
}

class ComicDetailsWidget extends StatelessWidget {
  ComicDetailsWidget(this._comicDetails);

  final ComicDetails _comicDetails;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PhotoView(
        imageProvider: NetworkImage(
          this._comicDetails.imageUrl,
        ),
        backgroundDecoration: BoxDecoration(color: Colors.white),
      ),
    );
  }
}

class ComicViewPage extends StatefulWidget {
  ComicViewPage(this._comics, this._startIndex);

  final List<Comic> _comics;
  final int _startIndex;

  @override
  _ComicViewState createState() =>
      _ComicViewState(this._comics, this._startIndex);
}

class _ComicViewState extends State<ComicViewPage> {
  _ComicViewState(this._comics, int startIndex) {
    this._currentIndex = startIndex;
  }

  int _currentIndex;

  final List<Comic> _comics;

  _gotoPrevComic() {
    setState(() {
      this._currentIndex--;
    });
  }

  _gotoNextComic() {
    setState(() {
      this._currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var comic = this._comics[this._currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(comic.title),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    comic.pubDate,
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    "#${this._currentIndex + 1}/${this._comics.length}",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: <Widget>[
          Container(
            child: IconButton(
                icon: Icon(Icons.arrow_left),
                iconSize: 32,
                padding: EdgeInsets.only(right: 5),
                onPressed: this._currentIndex > 0 ? this._gotoPrevComic : null),
          ),
          Expanded(
            child: FutureBuilder(
              future: ComicsParser.getComicDetails(comic),
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
            ),
          ),
          Container(
            child: IconButton(
                icon: Icon(Icons.arrow_right),
                iconSize: 32,
                padding: EdgeInsets.only(left: 5),
                onPressed: this._currentIndex < this._comics.length - 1
                    ? this._gotoNextComic
                    : null),
          ),
        ],
      ),
    );
  }
}
